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
    @Published var currentCameraQuaternion: simd_quatf          = simd_quatf()
    @Published var currentCameraOrientation: SCNQuaternion      = SCNQuaternion()
    @Published var currentCameraTransform: SCNMatrix4           = SCNMatrix4()
    @Published var currentCameraTotalPivot: SCNMatrix4          = SCNMatrix4()
    @Published var currentCameraInverseTransform: SCNMatrix4    = SCNMatrix4()
    
    @Published var deltaQuaternion: simd_quatf                  = simd_quatf()
    @Published var totalQuaternion: simd_quatf                  = simd_quatf()
    
    var cameraOnChangeQuaternion: simd_quatf                    = simd_quatf()
    
    
    var quaternion: simd_quatf                                  = simd_quatf(ix: 0.0, iy: 0.0, iz: 0.0, r: 1.0)
    var startQuaterion: simd_quatf                              = simd_quatf(ix: 0.0, iy: 0.0, iz: 0.0, r: 1.0)
    //var deltaQuaterion: simd_quatf                              = simd_quatf(ix: 0.0, iy: 0.0, iz: 0.0, r: 1.0)
    var updatedQuaterion: simd_quatf                            = simd_quatf(ix: 0.0, iy: 0.0, iz: 0.0, r: 1.0)
    var currentTouchPosition: simd_float3                       = simd_float3()
    var anchorTouchPosition: simd_float3                        = simd_float3()
    var rotationMatrix: SCNMatrix4                              = SCNMatrix4Identity

    
        
    //
    // This has to do with the camera's magnification, really FOV.
    //
    let maximumCurrentCameraFOV: CGFloat                        = 15 // Zoom-in. Was 25.
    let minimumCurrentCameraFOV: CGFloat                        = 90 // Zoom-out.
    @Published var currentCameraMagnification: CGFloat          = CGFloat(1.0)
    
    
    
    
    // MARK: -Change Camera Orientation
    /*
    func changeExteriorCameraOrientation(of currentCameraNode: SCNNode, with value: DragGesture.Value) {
        
        let xTranslation    = Float(value.translation.width)
        let yTranslation    = Float(value.translation.height)
        print("\(#function) xTranslation: \(xTranslation)")
        print("\(#function) yTranslation: \(yTranslation)")
        
        /*
        //let xScaled         = xTranslation / 100.0
        //let yScaled         = yTranslation / 100.0
        
        //let squaredTranslation  = pow(xTranslation,2) + pow(yTranslation,2)
        
        //let xNormalized         = xTranslation / squaredTranslation
        //let yNormalized         = yTranslation / squaredTranslation

        let hypotnuse   = sqrt(pow(xTranslation,2) + pow(yTranslation,2))
        let anglePan    = acos(xTranslation / hypotnuse) * 2.0
        print("\(#function) anglePan (in degrees): \(anglePan * 180.0 / .pi)")
        print("\(#function) anglePan (in radians): \(anglePan)")
        
        var rotationVector = SCNVector4()
        
        rotationVector.x =  0
        rotationVector.y =  yTranslation
        rotationVector.z =  xTranslation
        rotationVector.w = 0
         
        cameraOnChangeQuaternion            = simd_quatf(ix: rotationVector.x, iy: rotationVector.y, iz: rotationVector.z, r: rotationVector.w).normalized
        print("\(#function) Change Angle: \(cameraOnChangeQuaternion.angle * 180.0 / .pi)")
        */
        
        var simdTranslationVector           = simd_float3()
        simdTranslationVector.x             = xTranslation
        simdTranslationVector.y             = yTranslation
        simdTranslationVector.z             = 0.0
        
        var simdTranslationVectorNormalized = simd_normalize(simdTranslationVector)
        print("\(#function) simdTranslationVectorNormalized: \(simdTranslationVectorNormalized)")
    
        var simdTranslationVectorLength     = simd_length(simdTranslationVectorNormalized)
        print("\(#function) simdTranslationVectorLength: \(simdTranslationVectorLength)")
        
        var xNormalized                     = simdTranslationVectorNormalized.x
        var yNormalized                     = simdTranslationVectorNormalized.y
        var zNormalized                     = simdTranslationVectorNormalized.z
        
        
        //var anglePan                        = atan2(yNormalized, xNormalized)
        
        var anglePan                        = acos(xNormalized / simdTranslationVectorLength)
        
        let anchorPosition                  = simd_float3(x: 0.0, y: 0.0, z: 0.0)
        anglePan                            = acos(simd_dot(anchorPosition, simdTranslationVectorNormalized)) / 100.0
        print("\(#function) anglePan: \(anglePan) radians")
        print("\(#function) anglePan: \(anglePan * 180.0 / .pi)°")

        
        simdTranslationVectorNormalized.x   = xNormalized
        simdTranslationVectorNormalized.y   = 0.0//xNormalized
        simdTranslationVectorNormalized.z   = 0.0//yNormalized

        //cameraOnChangeQuaternion            = simd_normalize(simd_quatf(ix: xNormalized, iy: yNormalized, iz: zNormalized, r: anglePan))
        cameraOnChangeQuaternion            = simd_normalize(simd_quatf(ix: 0.0,
                                                                        iy: simdTranslationVectorNormalized.x,
                                                                        iz: simdTranslationVectorNormalized.y,
                                                                        r: anglePan))
        
        currentCameraNode.simdOrientation   = cameraOnChangeQuaternion
        
        /*
        currentCameraRotation = rotationVector
        //print("\(#function) currentCameraRotation: \(currentCameraRotation)")
        
        currentCameraNode.rotation = currentCameraRotation
        //print("\(#function) currentCameraRotation: \(currentCameraRotation)")
        */
    }
    */
    func changeExteriorCameraOrientation(of currentCameraNode: SCNNode, with value: DragGesture.Value) {
        print("\n\(#function)")
        
        //
        // Anchor, or start, touch location.
        //
        anchorTouchPosition     = simd_float3(x: Float(value.startLocation.x),
                                              y: Float(value.startLocation.y),
                                              z: 0.0)
        print("\(#function) anchorTouchPosition: \(anchorTouchPosition)")
        
        anchorTouchPosition     = projectCameraRotationOnSurface(of: anchorTouchPosition)
        print("\(#function) projected rotation on surface anchorTouchPosition: \(anchorTouchPosition)")
        
        
        //
        // Current touch location.
        //
        //currentTouchPosition    = anchorTouchPosition
        currentTouchPosition    = simd_float3(x: Float(value.location.x),
                                              y: Float(value.location.y),
                                              z: 0.0)
        print("\(#function) currentTouchPosition: \(currentTouchPosition)")
        
        currentTouchPosition    = projectCameraRotationOnSurface(of: currentTouchPosition)
        print("\(#function) projected rotation on surface currentTouchPosition: \(currentTouchPosition)")

        
        quaternion = computeIncremental(between: anchorTouchPosition, and: currentTouchPosition, around: startQuaterion).normalized
        print("\(#function) quaternion: \(quaternion)")
        
        let tempAxis = simd_float3(x: -quaternion.axis.z, y: -quaternion.axis.y, z: quaternion.axis.x)
        
        quaternion = simd_quatf(angle: quaternion.angle, axis: tempAxis).normalized
        print("\(#function) revised quaternion: \(quaternion)")

        //currentCameraNode.orientation   = quaternion
        currentCameraNode.simdOrientation   = quaternion.normalized
        
        //currentCameraQuaternion = currentCameraNode.simdOrientation
        deltaQuaternion         = quaternion
        //updatedQuaterion = simd_mul(updatedQuaterion, deltaQuaternion).normalized

        //updatedQuaterion = simd_mul(updatedQuaterion, deltaQuaternion).normalized
        
        //currentCameraNode.simdOrientation = updatedQuaterion

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
        
        /*
        currentCameraRotation = rotationVector
        //print("\(#function) currentCameraRotation: \(currentCameraRotation)")
        
        currentCameraNode.rotation = currentCameraRotation
        //print("\(#function) currentCameraRotation: \(currentCameraRotation)")
        */
    }
    
    
    
    func updateCameraOrientation(of currentCameraNode: SCNNode) {
        
        print("\n\(#function) currentOrientation: \(currentCameraNode.orientation)")
        
        //updatedQuaterion = simd_mul(updatedQuaterion, deltaQuaternion).normalized
        
        //currentCameraNode.simdOrientation = updatedQuaterion
        
        //updatedQuaterion = simd_quatf()
        
        //currentCameraNode.simdOrientation   = simd_quatf(ix: 0.0, iy: 0.0, iz: 0.0, r: 1.0)
        
        
        currentCameraPivot              = currentCameraNode.pivot
        print("currentCameraPivot: \(currentCameraPivot)")
        print("currentCamera FOV: \(String(describing: currentCameraNode.camera?.fieldOfView))")
        
        currentCameraTransform          = currentCameraNode.transform
        //print("currentCameraTransform: \(currentCameraTransform)")
        
        let changePivot = SCNMatrix4Invert(SCNMatrix4MakeRotation(currentCameraNode.rotation.w,
                                                                  currentCameraNode.rotation.x,
                                                                  currentCameraNode.rotation.y,
        currentCameraNode.rotation.z))
        
        currentCameraPivot         = SCNMatrix4Mult(changePivot, currentCameraPivot)
        currentCameraNode.pivot     = currentCameraPivot
        
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
    
    
    
    func projectCameraRotationOnSurface( of touchPoint: simd_float3) -> simd_float3 {
        
        //
        // CODING NOTE:
        //
        // The code for -projectOnSurface: and -computeIncrementalRotation come from Ray Wenderlich's post
        // "How To Rotate a 3D Object Using Touches with OpenGL", which can be found at the following link,
        // http://www.raywenderlich.com/12667/how-to-rotate-a-3d-object-using-touches-with-opengl
        //
        // I have slightly modified his post's code and will repost it at some later time.
        //
        // I want to thank Ray for helping me.
        //
        
        let width   = UIScreen.main.bounds.size.width
        let height  = UIScreen.main.bounds.size.height
        let diag    = sqrt(pow(width, 2) + pow(height, 2))
        
        let screenScale = UIScreen.main.scale
        print("\(#function) screen scale: \(screenScale)")

        
        let radius: Float         = Float(width) / 2.0
        let center: simd_float3 = simd_float3(Float(width / 2.0), Float(height / 2.0), 0.0)
        print("\(#function) screen center: \(center)")
        
        var pixelCoordinateVector   = touchPoint - center // This is why I love simd!
        print("\(#function) touchPoint: \(touchPoint)")
        print("\(#function) pixelCoordinateVector: \(pixelCoordinateVector)")

        
        // Inverting pixelCoordinateVector's y-coord because the y-axis on the screen is negative.
        pixelCoordinateVector.y     *= -1
        
        let radiusSquared: Float    = pow(radius, 2)
        let lengthSquared: Float    = pow(pixelCoordinateVector.x, 2) + pow(pixelCoordinateVector.y, 2)
        print("\(#function) radiusSquared: \(radiusSquared)")
        print("\(#function) lengthSquared: \(lengthSquared)")
        
        if lengthSquared <= radiusSquared {
            
            pixelCoordinateVector.z = sqrtf( radiusSquared - lengthSquared )
            
        } else {
            
            // One way...
            /*
             pixelCoordinateVector.x *= radius / sqrtf(lengthSquared)
             pixelCoordinateVector.y *= radius / sqrtf(lengthSquared)
             pixelCoordinateVector.z =  0.0
             */
            
            // Another way.
            pixelCoordinateVector.z = radiusSquared / ( 2.0 * sqrtf(lengthSquared) )
            
            let length: Float       = sqrtf(lengthSquared + pow(pixelCoordinateVector.z, 2))
            print("\(#function) length: \(length)")

            
            pixelCoordinateVector   = simd_make_float3(pixelCoordinateVector.x / length,
                                                       pixelCoordinateVector.y / length,
                                                       pixelCoordinateVector.z / length)
            print("\(#function) pixelCoordinateVector: \(pixelCoordinateVector)")

            pixelCoordinateVector   *= length
            print("\(#function) pixelCoordinateVector: \(pixelCoordinateVector)")
        }
        
        return simd_normalize(pixelCoordinateVector)
        
    }
    
    
    
    func computeIncremental(between startTouchLocation: simd_float3, and currentTouchLocation: simd_float3, around initialQuaternion: simd_quatf) -> simd_quatf {
        
        //
        // CODING NOTE:
        //
        // The code for -projectOnSurface: and -computeIncrementalRotation come from Ray Wenderlich's post
        // "How To Rotate a 3D Object Using Touches with OpenGL", which can be found at the following link,
        // http://www.raywenderlich.com/12667/how-to-rotate-a-3d-object-using-touches-with-opengl
        //
        // I have slightly modified his post's code and will repost it at some later time.
        //
        // I want to thank Ray for helping me.
        //
        print("\(#function) anchorTouchPosition: \(startTouchLocation)")
        print("\(#function) currentTouchPosition: \(currentTouchLocation)")
        
        let axis   = simd_cross(startTouchLocation, currentTouchLocation)
        //let axis               = startTouchLocation * currentTouchLocation
        print("\(#function) axis: \(axis)")
        
        let dotProduct   = simd_dot(startTouchLocation, currentTouchLocation)
        print("\(#function) dotProduct: \(dotProduct)")
        
        let angle        = acosf(dotProduct) * 1.8
        print("\(#function) angle: \(angle)")
        
        let rotationQuaternion  = simd_quatf(angle: angle, axis: axis).normalized
        print("\(#function) rotationQuaternion: \(rotationQuaternion)")
        
        let tempQuaternion      = simd_mul(rotationQuaternion, initialQuaternion).normalized
        print("\(#function) tempQuaternion: \(tempQuaternion)")
        
        return simd_mul(rotationQuaternion, initialQuaternion).normalized
    }
    
    
    

}
