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
    //@Published var currentCameraPivot: SCNMatrix4               = SCNMatrix4()
    //@Published var currentCameraRotation: SCNVector4            = SCNVector4()
    //@Published var currentCameraOrientation: SCNQuaternion      = SCNQuaternion()
    @Published var currentEulerAngles: simd_float3              = simd_float3()
    @Published var totalCommanderCameraEulerAngles: simd_float3 = simd_float3()
    @Published var totalChase360CameraEulerAngles: simd_float3  = simd_float3()
    @Published var currentCameraTransform: SCNMatrix4           = SCNMatrix4()
    //@Published var currentCameraTotalPivot: SCNMatrix4          = SCNMatrix4()
    //@Published var currentCameraInverseTransform: SCNMatrix4    = SCNMatrix4()
    
        
    //
    // This has to do with the camera's magnification, really FOV.
    //
    let maximumCurrentCameraFOV: CGFloat                        = 15 // Zoom-in. Was 25.
    let minimumCurrentCameraFOV: CGFloat                        = 90 // Zoom-out.
    @Published var currentCameraMagnification: CGFloat          = CGFloat(1.0)
    
    
    
    
    // MARK: -Change Camera Orientation
    
    func changeExteriorCameraOrientation(of currentCameraNode: SCNNode, with value: DragGesture.Value) {
        
        print("\n")
        
        //currentCameraNode.simdEulerAngles = totalCommanderCameraEulerAngles
        //print("\(#function) simdEulerAngles: \(currentCameraNode.simdEulerAngles)")
        //print("\(#function) rotation: \(currentCameraNode.rotation)")
        
        
        let translationX = Float(value.translation.width)
        let translationY = Float(-value.translation.height)
        
        /*
        //
        // Rotation Matrix
        //
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
        
        currentCameraNode.rotation = currentCameraRotation
        print("\(#function) currentCameraNode.rotation: \(currentCameraNode.rotation)")
        */
         
        //
        // Euler Angles
        //
        print("\(#function) Beginning of DragGesture .onChanged of \(currentCameraNode.name!) simdEulerAngles: \(currentCameraNode.simdEulerAngles)")
        print("\(#function) Beginning of DragGesture .onChanged of \(currentCameraNode.name!) Total simdEulerAngles: \(totalChase360CameraEulerAngles)")

        let translationWidthRatio   = translationX / Float(UIScreen.main.bounds.width)
        let translationHeightRatio  = translationY / Float(UIScreen.main.bounds.height)
        
        let cameraEulerX    = Float(-2 * Double.pi) * translationWidthRatio
        let cameraEulerY    = Float(-Double.pi) * translationHeightRatio
        
        currentCameraNode.eulerAngles.y = cameraEulerX + totalChase360CameraEulerAngles.y
        currentCameraNode.eulerAngles.z = cameraEulerY + totalChase360CameraEulerAngles.z
        
        //currentEulerAngles = currentCameraNode.simdEulerAngles
        print("\(#function) End of DragGesture .onChanged simdEulerAngles: \(currentCameraNode.simdEulerAngles)")
        print("\(#function) End of DragGesture .onChanged of \(currentCameraNode.name!) Total simdEulerAngles: \(totalChase360CameraEulerAngles)")
        //print("\(#function) rotation: \(currentCameraNode.rotation)")
        
    }
    
    
    
    func changeInteriorCameraOrientation(of currentCameraNode: SCNNode, with value: DragGesture.Value) {
        
        print("\n")

        let translationX = Float(value.translation.width)
        let translationY = Float(-value.translation.height)
        
        /*
        //
        // Rotation
        //
        let anglePan = ( sqrt(pow(translationX,2) + pow(translationY,2)) / 4.0 ) * (Float)(Double.pi) / 180.0
        //print("\(#function) anglePan (in degrees): \(anglePan * 180.0 / .pi)")
        //print("\(#function) anglePan (in radians): \(anglePan)")
        
        var rotationVector = SCNVector4()
        
        rotationVector.x =  translationY
        rotationVector.y = -translationX
        rotationVector.z =  0
        rotationVector.w = anglePan
        
        currentCameraRotation = rotationVector
        //print("\(#function) currentCameraRotation: \(currentCameraRotation)")
        
        currentCameraNode.rotation = currentCameraRotation
        //print("\(#function) currentCameraRotation: \(currentCameraRotation)")
        */
        
        
        //
        // Euler Angles
        //
        //print("\(#function) Beginning of DragGesture .onChanged simdEulerAngles: \(currentCameraNode.simdEulerAngles)")
        print("\(#function) Beginning of DragGesture .onChanged of \(currentCameraNode.name!) Total simdEulerAngles: \(totalCommanderCameraEulerAngles)")

        let translationWidthRatio   = translationX / Float(UIScreen.main.bounds.width)
        let translationHeightRatio  = translationY / Float(UIScreen.main.bounds.height)
        
        let cameraEulerX    = Float(-2 * Double.pi) * translationWidthRatio
        let cameraEulerY    = Float(-Double.pi) * translationHeightRatio
        
        currentCameraNode.eulerAngles.y =    cameraEulerX + totalCommanderCameraEulerAngles.y
        currentCameraNode.eulerAngles.x = -( cameraEulerY + -( totalCommanderCameraEulerAngles.x ) )
        
        //currentEulerAngles = currentCameraNode.simdEulerAngles
        //print("\(#function) End of DragGesture .onChanged simdEulerAngles: \(currentCameraNode.simdEulerAngles)")
        print("\(#function) End of DragGesture .onChanged of \(currentCameraNode.name!) Total simdEulerAngles: \(totalCommanderCameraEulerAngles)")
        //print("\(#function) rotation: \(currentCameraNode.rotation)")

    }
    
    
    
    func updateCameraOrientation(of currentCameraNode: SCNNode) {
        
        //print("\n\(#function) currentOrientation: \(currentCameraNode.orientation)")
        
        
        //
        // Using Euler Angles
        //
        //print("\(#function) Current Eulers: \(String(describing: currentCameraNode.simdEulerAngles))")
        //print("\(#function) Total Eulers: \(String(describing: totalCommanderCameraEulerAngles))")

        
        //print("\(#function) Current Camera Node is: \(currentCameraNode.name!)")

        //
        // Determine the camera for which to set the total euler angles.
        if currentCameraNode.name! + "Node" == SpacecraftCamera.spacecraftCommanderCamera.rawValue {
            
            print("\(#function) Current Camera Node is: \(currentCameraNode.name!)")
            
            totalCommanderCameraEulerAngles     = currentCameraNode.simdEulerAngles
            
            currentCameraNode.simdEulerAngles   = totalCommanderCameraEulerAngles
            print("\(#function) Total Interior Eulers after adding: \(String(describing: totalCommanderCameraEulerAngles))")

            
        }
        if currentCameraNode.name! == SpacecraftCamera.spacecraftChase360Camera.rawValue {
            
            print("\(#function) Current Camera Node is: \(currentCameraNode.name!)")
            
            totalChase360CameraEulerAngles      = currentCameraNode.simdEulerAngles

            currentCameraNode.simdEulerAngles   = totalChase360CameraEulerAngles
            print("\(#function) Total Eulers after adding: \(String(describing: totalChase360CameraEulerAngles))")

        }

        //print("\(#function) currentCamera Rotation: \(String(describing: currentCameraNode.rotation))")
        /*let changeRotation     = SCNMatrix4Invert(SCNMatrix4MakeRotation(currentCameraNode.rotation.w,
                                                                      currentCameraNode.rotation.x,
                                                                      currentCameraNode.rotation.y,
                                                                    currentCameraNode.rotation.z))
        */
        
        /*
        //
        // Using Pivot
        //
        currentCameraPivot      = currentCameraNode.pivot
        print("\(#function) currentCameraPivot: \(currentCameraPivot)")
        
        currentCameraPivot    = SCNMatrix4Mult(changeRotation, currentCameraPivot)
        //currentCameraPivot  = SCNMatrix4Mult(currentCameraPivot, changeRotation) // Don't do this!

        //print("\(#function) Updated currentCameraPivot: \(currentCameraPivot)")
        currentCameraNode.pivot = currentCameraPivot
        
        print("\(#function) Updated currentCamera Rotation: \(String(describing: currentCameraNode.rotation))")
        
        currentCameraTransform  = SCNMatrix4Identity
        print("\(#function) currentCameraTransform: \(currentCameraTransform)")
        
        currentCameraNode.transform = currentCameraTransform
         */
        
        /*
        //
        // Using Transform
        //
        currentCameraTransform          = currentCameraNode.transform
        print("\(#function) currentCameraTransform: \(currentCameraTransform)")
        
        currentCameraTransform  = SCNMatrix4Mult(changeRotation, currentCameraTransform)
        //currentCameraTransform  = SCNMatrix4Mult(currentCameraTransform, changeRotation)
        
        currentCameraNode.transform = currentCameraTransform
        print("\(#function) currentCameraTransform: \(currentCameraTransform)")
        */
         
    }
    
    
    
    ///
    /// MotionManager.swift's resetReferenceFrame resets the `attitude simd_Quatertian` to the current attitude.
    /// I'm hoping that for gestures, that will be a quaterion of (0,0,0,1).
    /// :-/
    ///
    func resetCameraOrientation(of currentCameraNode: SCNNode) {
        print("\n\n")
        
        currentCameraNode.transform = SCNMatrix4Identity
        
        print("\(#function) currentCameraNode.name: \(currentCameraNode.name)")
        
        // This resets the "neck" of the spacecraft's interior commander camera
        if currentCameraNode.name! + "Node" == SpacecraftCamera.spacecraftCommanderCamera.rawValue {
            print("\(#function) RESET currentCameraNode.name: \(currentCameraNode.name!)")
            print("\(#function) RESET SpacecraftCamera.spacecraftCommanderCamera.rawValue: \(SpacecraftCamera.spacecraftCommanderCamera.rawValue)")

            totalCommanderCameraEulerAngles         *= 0.0
            //currentCameraNode.transform             = SCNMatrix4Identity
            currentCameraNode.simdEulerAngles       *= 0.0
            currentCameraNode.simdPivot.columns.3.y = -0.09
        } else if currentCameraNode.name! == SpacecraftCamera.spacecraftChase360Camera.rawValue{
            print("\(#function) RESET currentCameraNode.name: \(currentCameraNode.name!)")
            print("\(#function) RESET SpacecraftCamera.spacecraftCommanderCamera.rawValue: \(SpacecraftCamera.spacecraftCommanderCamera.rawValue)")

            totalChase360CameraEulerAngles  *= 0.0
            //currentCameraNode.transform     = SCNMatrix4Identity
            currentCameraNode.simdEulerAngles   *= 0.0
        }
        
        //currentCameraTotalPivot = SCNMatrix4Identity
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
