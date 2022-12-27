//
//  SpacecraftCameraState.swift
//  SceneKitSwiftUIGesturesDemoApp
//
//  Created by James Hillhouse IV on 12/01/22.
//

import Foundation
import SwiftUI
import SceneKit
import simd
import GLKit




class SpacecraftCameraState: ObservableObject {
    
    static let shared = SpacecraftCameraState()
    
    @Published var currentCamera: SCNNode                       = SCNNode()
    @Published var updateCameraAttitude: Bool                   = false
    
    //
    // These have to do with the camera's orientation, etc.
    //
    @Published var currentCameraPivot: SCNMatrix4               = SCNMatrix4()
    @Published var currentCameraRotation: SCNVector4            = SCNVector4()
    @Published var currentCameraOrientation: SCNQuaternion      = SCNQuaternion()
    @Published var currentCameraTransform: SCNMatrix4           = SCNMatrix4()
    @Published var currentCameraTotalPivot: SCNMatrix4          = SCNMatrix4()
    @Published var currentCameraInverseTransform: SCNMatrix4    = SCNMatrix4()
    
        
    //
    // This has to do with the camera's magnification, really FOV.
    //
    let maximumCurrentCameraFOV: CGFloat                        = 15 // Zoom-in. Was 25.
    let minimumCurrentCameraFOV: CGFloat                        = 90 // Zoom-out.
    @Published var currentCameraMagnification: CGFloat          = CGFloat(1.0)
    
    
    
    
    // MARK: -Change Camera Orientation
    
    func changeExteriorCameraOrientation(of currentCameraNode: SCNNode, with value: DragGesture.Value) {
        
        let translationX = Float(value.translation.width)
        let translationY = Float(-value.translation.height)
        
        let anglePan = ( sqrt(pow(translationX,2) + pow(translationY,2)) / 4.0 ) * (Float)(Double.pi) / 180.0
        //print("\(#function) anglePan (in degrees): \(anglePan * 180.0 / .pi)")
        //print("\(#function) anglePan (in radians): \(anglePan)")
        
        var rotationVector = SCNVector4()
        
        rotationVector.x =  0
        rotationVector.y = -translationX
        rotationVector.z = -translationY
        rotationVector.w = anglePan
        
        currentCameraRotation = rotationVector
        //print("\(#function) currentCameraRotation: \(currentCameraRotation)")
        
        //currentCameraNode.rotation = currentCameraRotation
        print("\(#function) currentCameraNode.rotation: \(currentCameraNode.rotation)")
        
        let translationWidthRatio   = translationX / Float(UIScreen.main.bounds.width)
        let translationHeightRatio  = translationY / Float(UIScreen.main.bounds.height)
        
        let cameraEulerX    = Float(-2 * Double.pi) * translationWidthRatio
        let cameraEulerY    = Float(-Double.pi) * translationHeightRatio
        
        currentCameraNode.eulerAngles.y = cameraEulerX
        currentCameraNode.eulerAngles.z = cameraEulerY
        
        //let currentEulers = currentCameraNode.eulerAngles
        print("\(#function) euler angles: \(currentCameraNode.eulerAngles)")
        
        print("\(#function) currentCamera orientation: \(currentCameraNode.orientation)")

        print("\(#function) currentCamera Transform: \(currentCameraNode.transform)")
        
    }
    
    
    
    func changeInteriorCameraOrientation(of currentCameraNode: SCNNode, with value: DragGesture.Value) {
        
        let x = Float(value.translation.width)
        let y = Float(-value.translation.height)
        
        let anglePan = ( sqrt(pow(x,2) + pow(y,2)) / 4.0 ) * (Float)(Double.pi) / 180.0
        //print("\(#function) anglePan (in degrees): \(anglePan * 180.0 / .pi)")
        //print("\(#function) anglePan (in radians): \(anglePan)")
        
        var rotationVector = SCNVector4()
        
        rotationVector.x =  y
        rotationVector.y = -x
        rotationVector.z =  0
        rotationVector.w = anglePan
        
        currentCameraRotation = rotationVector
        //print("\(#function) currentCameraRotation: \(currentCameraRotation)")
        
        currentCameraNode.rotation = currentCameraRotation
        //print("\(#function) currentCameraRotation: \(currentCameraRotation)")
        
    }
    
    
    
    func updateCameraOrientation(of currentCameraNode: SCNNode) {
        
        //print("\n\(#function) currentOrientation: \(currentCameraNode.orientation)")
        
        currentCameraPivot              = currentCameraNode.pivot
        print("\(#function) currentCameraPivot: \(currentCameraPivot)")
        print("\(#function) currentCamera Rotation: \(String(describing: currentCameraNode.rotation))")
        
        //currentCameraTransform          = currentCameraNode.transform
        //print("currentCameraTransform: \(currentCameraTransform)")
        
        let changePivot     = SCNMatrix4Invert(SCNMatrix4MakeRotation(currentCameraNode.rotation.w,
                                                                      currentCameraNode.rotation.x,
                                                                      currentCameraNode.rotation.y,
                                                                      currentCameraNode.rotation.z))
        
        currentCameraPivot  = SCNMatrix4Mult(changePivot, currentCameraPivot)
        print("\(#function) Updated currentCameraPivot: \(currentCameraPivot)")
        currentCameraNode.pivot     = currentCameraPivot
        
        print("\(#function) Updated currentCamera Rotation: \(String(describing: currentCameraNode.rotation))")
        
        print("\(#function) Updated currentCamera Eulers: \(String(describing: currentCameraNode.eulerAngles))")


        
        currentCameraTransform      = SCNMatrix4Identity
        //print("currentCameraTransform: \(currentCameraTransform)")
        
        currentCameraNode.transform = currentCameraTransform
        
    }
    
    
    
    ///
    /// MotionManager.swift's resetReferenceFrame resets the `attitude simd_Quatertian` to the current attitude.
    /// I'm hoping that for gestures, that will be a quaterion of (0,0,0,1).
    /// :-/
    ///
    func resetCameraOrientation(of currentCameraNode: SCNNode) {
        print("\n\n")
        
        currentCameraNode.pivot = SCNMatrix4Identity
        
        //print("currentCameraNode.name: \(currentCameraNode.name)")
        
        // This resets the "neck" of the spacecraft's interior commander camera
        if currentCameraNode.name! + "Node" == SpacecraftCamera.spacecraftCommanderCamera.rawValue {
            currentCameraNode.pivot = SCNMatrix4Identity
            currentCameraNode.simdPivot.columns.3.y = -0.09
        } else {
            currentCameraNode.pivot = SCNMatrix4Identity
        }
        
        currentCameraTotalPivot = SCNMatrix4Identity
    }
    
    
    
    // MARK: -Change Camera FOV (for magnification)
    
    func changeCurrentCameraFOV(of camera: SCNCamera, value: CGFloat) {
        if currentCameraMagnification >= 1.025 {
            currentCameraMagnification  = 1.025
        }
        if currentCameraMagnification <= 0.97 {
            currentCameraMagnification  = 0.97
        }
        
        camera.fieldOfView /= currentCameraMagnification
        
        if camera.fieldOfView <= maximumCurrentCameraFOV {
            camera.fieldOfView          = maximumCurrentCameraFOV
            currentCameraMagnification  = 1.0
        }
        if camera.fieldOfView >= minimumCurrentCameraFOV {
            camera.fieldOfView          = minimumCurrentCameraFOV
            currentCameraMagnification  = 1.0
        }
        
    }
    
    
    
    func resetCurrentCameraFOV(of currentCamera: SCNCamera) {
        print("resetting cameraFOV")
        print("current camera: \(String(describing: currentCamera.name)) FOV: \(currentCamera.fieldOfView)")
        
        if currentCamera.name == SpacecraftCamera.spacecraftChase360Camera.rawValue {
            print("spacecraftChase360Camera FOV: \(currentCamera.fieldOfView)")
            currentCamera.fieldOfView = 45
        }
        
        if currentCamera.name == SpacecraftCamera.spacecraftCommanderCamera.rawValue {
            print("spacecraftCommanderCamera FOV: \(currentCamera.fieldOfView)")
            currentCamera.fieldOfView = 30
        }
        
    }
    
}
