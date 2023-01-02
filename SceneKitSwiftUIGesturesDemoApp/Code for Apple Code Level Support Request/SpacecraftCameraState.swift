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
    @Published var currentEulerAngles: simd_float3              = simd_float3()
    @Published var totalCommanderCameraEulerAngles: simd_float3 = simd_float3()
    @Published var totalChase360CameraEulerAngles: simd_float3  = simd_float3()
    @Published var currentCameraTransform: SCNMatrix4           = SCNMatrix4()
    
        
    //
    // This has to do with the camera's magnification, really FOV.
    //
    let maximumCurrentCameraFOV: CGFloat                        = 15 // Zoom-in. Was 25.
    let minimumCurrentCameraFOV: CGFloat                        = 90 // Zoom-out.
    @Published var currentCameraMagnification: CGFloat          = CGFloat(1.0)
    
    
    
    
    // MARK: -Change Camera Orientation
    
    func changeExteriorCameraOrientation(of currentCameraNode: SCNNode, with value: DragGesture.Value) {
        
        //print("\n")
        
        //currentCameraNode.simdEulerAngles = totalCommanderCameraEulerAngles
        //print("\(#function) simdEulerAngles: \(currentCameraNode.simdEulerAngles)")
        //print("\(#function) rotation: \(currentCameraNode.rotation)")
        
        
        let translationX = Float(value.translation.width)
        let translationY = Float(-value.translation.height)
        
         
        //
        // Using Euler Angles
        //
        //print("\(#function) Beginning of DragGesture .onChanged of \(currentCameraNode.name!) simdEulerAngles: \(currentCameraNode.simdEulerAngles)")
        //print("\(#function) Beginning of DragGesture .onChanged of \(currentCameraNode.name!) Total simdEulerAngles: \(totalChase360CameraEulerAngles)")

        let translationWidthRatio   = translationX / Float(UIScreen.main.bounds.width)
        let translationHeightRatio  = translationY / ( Float(UIScreen.main.bounds.height) * 2.0 ) // This is to slow-down pitch, which can be a pain when also yawing.
        
        let cameraEulerX    = Float(-2 * Double.pi) * translationWidthRatio
        let cameraEulerY    = Float(-Double.pi) * translationHeightRatio
        
        currentCameraNode.eulerAngles.y = cameraEulerX + totalChase360CameraEulerAngles.y
        
        if abs(cameraEulerY + totalChase360CameraEulerAngles.z) > abs(Float(Double.pi / 2.0)) {

            //print("\(#function) Ooopsie! Angle too high.")
            
            if cameraEulerY + totalChase360CameraEulerAngles.z > 0 {
                
                currentCameraNode.eulerAngles.z = Float(Double.pi / 2.0)
                
            } else {
                
                currentCameraNode.eulerAngles.z = -Float(Double.pi / 2.0)
                
            }
            
        } else {
        
            currentCameraNode.eulerAngles.z = cameraEulerY + totalChase360CameraEulerAngles.z
            
        }
        
        //print("\(#function) End of DragGesture .onChanged simdEulerAngles: \(currentCameraNode.simdEulerAngles)")
        //print("\(#function) End of DragGesture .onChanged of \(currentCameraNode.name!) Total simdEulerAngles: \(totalChase360CameraEulerAngles)")
        
    }
    
    
    
    func changeInteriorCameraOrientation(of currentCameraNode: SCNNode, with value: DragGesture.Value) {
        
        //print("\n")

        let translationX = Float(value.translation.width)
        let translationY = Float(-value.translation.height)
        

        //
        // Using Euler Angles
        //
        //print("\(#function) Beginning of DragGesture .onChanged simdEulerAngles: \(currentCameraNode.simdEulerAngles)")
        print("\(#function) Beginning of DragGesture .onChanged of \(currentCameraNode.name!) Total simdEulerAngles: \(totalCommanderCameraEulerAngles)")

        let translationWidthRatio   = translationX / Float(UIScreen.main.bounds.width)
        let translationHeightRatio  = translationY / Float(UIScreen.main.bounds.height)
        
        let cameraEulerX    = Float(-2 * Double.pi) * translationWidthRatio
        let cameraEulerY    = Float(-Double.pi) * translationHeightRatio
        
        currentCameraNode.eulerAngles.y =    cameraEulerX + totalCommanderCameraEulerAngles.y
        currentCameraNode.eulerAngles.x = -( cameraEulerY + -( totalCommanderCameraEulerAngles.x ) )
        
        //print("\(#function) End of DragGesture .onChanged simdEulerAngles: \(currentCameraNode.simdEulerAngles)")
        //print("\(#function) End of DragGesture .onChanged of \(currentCameraNode.name!) Total simdEulerAngles: \(totalCommanderCameraEulerAngles)")

    }
    
    
    
    func updateCameraOrientation(of currentCameraNode: SCNNode) {
        
        //
        // Using Euler Angles
        //
        //print("\(#function) Current Eulers: \(String(describing: currentCameraNode.simdEulerAngles))")
        //print("\(#function) Total Eulers: \(String(describing: totalCommanderCameraEulerAngles))")


        //
        // Determine the camera node for which to set the total euler angles.
        //
        if currentCameraNode.name! + "Node" == SpacecraftCamera.spacecraftCommanderCamera.rawValue {
            
            //print("\(#function) Current Camera Node is: \(currentCameraNode.name!)")
            
            totalCommanderCameraEulerAngles     = currentCameraNode.simdEulerAngles
            
            //print("\(#function) Total Interior Eulers after adding: \(String(describing: totalCommanderCameraEulerAngles))")

            
        }
        if currentCameraNode.name! == SpacecraftCamera.spacecraftChase360Camera.rawValue {
            
            //print("\(#function) Current Camera Node is: \(currentCameraNode.name!)")
            
            totalChase360CameraEulerAngles      = currentCameraNode.simdEulerAngles

            print("\(#function) Total Eulers after adding: \(String(describing: totalChase360CameraEulerAngles))")

        }

    }
    
    
    
    func resetCameraOrientation(of currentCameraNode: SCNNode) {
        print("\n")
        
        currentCameraNode.transform = SCNMatrix4Identity
        
        print("\(#function) currentCameraNode.name: \(currentCameraNode.name!)")
        
        // This resets the "neck" of the spacecraft's interior commander camera
        if currentCameraNode.name! + "Node" == SpacecraftCamera.spacecraftCommanderCamera.rawValue {
            
            //print("\(#function) RESET currentCameraNode.name: \(currentCameraNode.name!)")
            //print("\(#function) RESET SpacecraftCamera.spacecraftCommanderCamera.rawValue: \(SpacecraftCamera.spacecraftCommanderCamera.rawValue)")

            totalCommanderCameraEulerAngles         *= 0.0
            //currentCameraNode.transform             = SCNMatrix4Identity
            currentCameraNode.simdEulerAngles       *= 0.0
            currentCameraNode.simdPivot.columns.3.y = -0.09
            
        } else if currentCameraNode.name! == SpacecraftCamera.spacecraftChase360Camera.rawValue{
            
            //print("\(#function) RESET currentCameraNode.name: \(currentCameraNode.name!)")
            //print("\(#function) RESET SpacecraftCamera.spacecraftCommanderCamera.rawValue: \(SpacecraftCamera.spacecraftCommanderCamera.rawValue)")

            totalChase360CameraEulerAngles          *= 0.0
            //currentCameraNode.transform             = SCNMatrix4Identity
            currentCameraNode.simdEulerAngles       *= 0.0
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
