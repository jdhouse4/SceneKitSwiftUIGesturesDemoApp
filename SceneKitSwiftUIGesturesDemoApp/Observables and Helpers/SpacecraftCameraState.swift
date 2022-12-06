//
//  SpacecraftCameraState.swift
//  SwiftUISceneKitCoreMotionDemo
//
//  Created by James Hillhouse IV on 8/7/22.
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
    
    var quaternion: simd_quatf                                  = simd_quatf(ix: 0.0, iy: 0.0, iz: 0.0, r: 1.0)
    var startQuaterion: simd_quatf                              = simd_quatf(ix: 0.0, iy: 0.0, iz: 0.0, r: 1.0)
    var deltaQuaterion: simd_quatf                              = simd_quatf(ix: 0.0, iy: 0.0, iz: 0.0, r: 1.0)
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

    func changeExteriorCameraOrientation(of currentCameraNode: SCNNode, with value: DragGesture.Value) {
        //print("\(#function) translation: \(translation)")
        
        print("\(#function) Starting currentCameraRotation: \(currentCameraRotation)")
        
        let x = Float(value.translation.width)
        let y = Float(-value.translation.height)

        let anglePan = ( sqrt(pow(x,2) + pow(y,2)) / 4.0 ) * (Float)(Double.pi) / 180.0
        //print("\(#function) anglePan (in degrees): \(anglePan * 180.0 / .pi)")
        //print("\(#function) anglePan (in radians): \(anglePan)")

        var rotationVector = SCNVector4()

        rotationVector.x =  0
        rotationVector.y = -x
        rotationVector.z = -y
        rotationVector.w = anglePan

        /*
        startQuaterion = currentCameraNode.simdOrientation
        //print("\(#function) startQuaternion: \(startQuaterion)")
         
        deltaQuaterion      = simd_quatf(ix: rotationVector.x, iy: rotationVector.y, iz: rotationVector.z, r: rotationVector.w).normalized
        print("\(#function) deltaQuaternion: \(deltaQuaterion)")

        updatedQuaterion    = simd_mul(startQuaterion, deltaQuaterion).normalized
        print("\(#function) updatedQuaternion: \(updatedQuaterion)")

        //currentCameraNode.simdOrientation = updatedQuaterion
        print("\(#function) currentCamera.simdOrientation: \(currentCameraNode.simdOrientation)")
         */
        
        currentCameraRotation = rotationVector
        //print("\(#function) currentCameraRotation: \(currentCameraRotation)")
        
        currentCameraNode.rotation = currentCameraRotation
        //print("\(#function) currentCameraRotation: \(currentCameraRotation)")
        
        
        //print("\n")
    }
    
    
    
    func changeInteriorCameraOrientation(of currentCameraNode: SCNNode, with value: DragGesture.Value) {
        //print("\(#function) translation: \(translation)")
        
        print("\(#function) Starting currentCameraRotation: \(currentCameraRotation)")
        
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
         startQuaterion = currentCameraNode.simdOrientation
         //print("\(#function) startQuaternion: \(startQuaterion)")
         
         deltaQuaterion      = simd_quatf(ix: rotationVector.x, iy: rotationVector.y, iz: rotationVector.z, r: rotationVector.w).normalized
         print("\(#function) deltaQuaternion: \(deltaQuaterion)")
         
         updatedQuaterion    = simd_mul(startQuaterion, deltaQuaterion).normalized
         print("\(#function) updatedQuaternion: \(updatedQuaterion)")
         
         //currentCameraNode.simdOrientation = updatedQuaterion
         print("\(#function) currentCamera.simdOrientation: \(currentCameraNode.simdOrientation)")
         */
        
        currentCameraRotation = rotationVector
        //print("\(#function) currentCameraRotation: \(currentCameraRotation)")
        
        currentCameraNode.rotation = currentCameraRotation
        //print("\(#function) currentCameraRotation: \(currentCameraRotation)")
        
        
        //print("\n")
    }
    
    
    
    func updateCameraOrientation(of currentCameraNode: SCNNode) {
        
        print("\n\(#function) currentOrientation: \(currentCameraNode.orientation)")
        
        currentCameraPivot              = currentCameraNode.pivot
        print("currentCameraPivot: \(currentCameraPivot)")
        
        currentCameraTransform          = currentCameraNode.transform
        //print("currentCameraTransform: \(currentCameraTransform)")
        
        /*
        currentCameraInverseTransform   = SCNMatrix4Invert(currentCameraTransform)
        //print("currentCameraInverseTransform: \(currentCameraInverseTransform)")
        
        currentCameraTotalPivot         = SCNMatrix4Mult(
            currentCameraInverseTransform,
            currentCameraPivot)
        //print("currentCameraTotalPivot: \(currentCameraTotalPivot)")
        
        currentCameraPivot              = SCNMatrix4Mult(
            currentCameraInverseTransform,
            currentCameraPivot)
        //print("currentCameraPivot: \(currentCameraPivot)")
        
        currentCameraNode.pivot         = currentCameraPivot
        
        currentCameraTransform          = SCNMatrix4Identity
        //print("currentCameraTransform: \(currentCameraTransform)")
        
        currentCameraNode.transform     = currentCameraTransform
         */
        
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
    
    
    
    /*
    func changedCurrentCameraOrientation(of node: SCNNode, with value: DragGesture.Value) {
        
        ///
        /// Someday, use the example in the Medium post, "[SceneKit Rotations with Quaternions]"(https://medium.com/@jacob.waechter/scenekit-rotations-with-quaternions-d74dc6ba68c6)
        ///
        /// and https://stackoverflow.com/questions/44991038/get-vector-in-scnnode-environment-from-touch-location-swift.
        ///
        /// Either SceneView needs to be able to be accessed as a, say, `self.sceneView` within the SCNSceneRendererDelegate or, better yet,
        /// within the Struct in which the SceneView is declared and defined so that one might be able to do, you know,
        /// ```
        /// func getDirection(for point: CGPoint, in view: SCNView) -> SCNVector3 {
        ///     let farPoint  = view.unprojectPoint(SCNVector3Make(point.x, point.y, 1))
        ///     let nearPoint = view.unprojectPoint(SCNVector3Make(point.x, point.y, 0))
        ///
        ///     return SCNVector3Make(farPoint.x - nearPoint.x, farPoint.y - nearPoint.y, farPoint.z - nearPoint.z)
        /// }```
        ///
        /// Or gosh, even, in a DragGesture or TapGesture,
        /// ```
        /// let scneneView = recognizer.view as! SCNView
        /// let p          = recognizer.location(in: scnView)
        /// let hitResults = scnView.hitTest(p, options: [:])
        ///
        /// if let hit = hitResults.first{
        ///     let worldTouch = simd_float3(result.worldCoordinates)
        ///     ...
        /// }
        /// ```
        ///
        /// I write this because, as of April 2022, nearly two full years since SceneView was introduced in SwiftUI, one can do any of these.
        ///
        /// That sorta sucks because it takes a whole host of things off the table that are commonly used SceneKit techniques for performing hit testing or
        /// just trying to get the worldLocation and localLocation of nodes.
        ///
        /// To do these things now requires using UIViewRepresentable and just the usual crap code that SwiftUI was supposed to take-away from us.
        ///
        print("\n\(#function) startLocation: \(value.startLocation)")
        print("\(#function) currentLocation: \(value.location)")
        
        var startVector3    = simd_float3()
        var startNorm3      = simd_float3()
        var endVector3      = simd_float3()
        var endNorm3        = simd_float3()
        var axis            = simd_float3()
        
        if let start = value.startLocation as CGPoint? {
            startVector3 = simd_float3(x: Float(start.x), y: Float(start.y), z: 0.0)
            //print("\(#function) startVector3: \(startVector3)")
            
            startNorm3 = simd_normalize(startVector3)
        }
        
        if let end = value.location as CGPoint? {
            endVector3 = simd_float3(x: Float(end.x), y: Float(end.y), z: 0.0)
            //print("\(#function) endVector3: \(endVector3)")
            
            endNorm3 = simd_normalize(endVector3)
        }
        
        print("\(#function) node.simdWorldPosition: \(node.simdWorldPosition)")
        print("\(#function) node.simdWorldOrientation: \(node.simdWorldOrientation)")
        
        let angle = acosf(simd_dot(startNorm3, endNorm3))
        print("\(#function) angle (in degrees): \(angle * 180.0 / .pi)")

        /// Modify startVector3 and endVector3 so that the cross, or vector, product isn't only about the z-axis.
        startVector3    = simd_normalize(simd_float3(x: startVector3.x, y: startVector3.y, z: node.position.z))
        endVector3      = simd_normalize(simd_float3(x: endVector3.x, y: endVector3.y, z: node.position.z))
        
        axis = simd_normalize(simd_cross(startVector3, endVector3))
        print("\(#function) axis: \(axis)")
        
        /// Remove the z-component because rotation about the z-axis is not desired.
        //axis = simd_normalize(simd_float3(x: axis.x, y: -axis.y, z: 0.0))
        //print("\(#function) Revised axis (removed z-component): \(axis)")

        let newOrientation: simd_quatf = simd_quatf(angle: -angle, axis: axis).normalized
        print("\(#function) newOrientation: \(newOrientation)")
        
        let currentOrientation = node.simdOrientation
        print("\(#function) currentOrientation = \(currentOrientation)\n")
        
        print("\(#function) node.simdOrientation: \(node.simdOrientation)")
        //node.simdOrientation = simd_normalize(newOrientation * currentOrientation)
        print("\(#function) node.simdOrientation: \(node.simdOrientation)")
    }
     */
    
    
    // MARK: -Change Camera FOV

    func changeCurrentCameraFOV(of camera: SCNCamera, value: CGFloat) {
        if currentCameraMagnification >= 1.025 {
            currentCameraMagnification  = 1.025
        }
        if currentCameraMagnification <= 0.97 {
            currentCameraMagnification  = 0.97
        }
        
        //let maximumFOV: CGFloat = 25 // Zoom-in.
        //let minimumFOV: CGFloat = 90 // Zoom-out.
        
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
    
    
    
    func beginCameraNodeTouches(of currentCameraNode: SCNNode, with value: DragGesture.Value) {
        
        print("\n\(#function)!")
        
        anchorTouchPosition     = simd_float3(x: Float(value.location.x),
                                          y: Float(value.location.y),
                                          z: 0.0)
        print("\(#function) anchorTouchPosition: \(anchorTouchPosition)")
        
        anchorTouchPosition     = projectCameraRotationOnSurface(of: anchorTouchPosition)
        print("\(#function) projected rotation on surface anchorTouchPosition: \(anchorTouchPosition)")

        currentTouchPosition    = anchorTouchPosition
        print("\(#function) currentTouchPosition: \(currentTouchPosition)")

        startQuaterion          = quaternion
        print("\(#function) startQuaternion: \(quaternion)")

        //currentCameraNode.simdOrientation = startQuaterion
    }
    
    
    /*
    func changeCameraNodeTouches(of currentCameraNode: SCNNode, with value: DragGesture.Value) {
        
        let rotationX   = -1.0 * GLKMathDegreesToRadians(Float(value.translation.width) / 2.0)
        let rotationY   = -1.0 * GLKMathDegreesToRadians(Float(value.translation.height) / 2.0)
        print("\(#function) rotationX: \(rotationX)")
        print("\(#function) rotationY: \(rotationY)")

        var glkRotationMatrix           = SCNMatrix4ToGLKMatrix4(rotationMatrix)
        print("\(#function) glkRotationMatrix: \(glkRotationMatrix)")

        
        let xAxis: GLKVector3           = GLKMatrix4MultiplyVector3(SCNMatrix4ToGLKMatrix4(SCNMatrix4Invert(rotationMatrix)), GLKVector3Make(1.0, 0.0, 0.0))
        print("\(#function) xAxis: \(xAxis)")


        rotationMatrix  = SCNMatrix4FromGLKMatrix4(GLKMatrix4Rotate(glkRotationMatrix, rotationX, xAxis.x, xAxis.y, xAxis.z))
        
        glkRotationMatrix           = SCNMatrix4ToGLKMatrix4(rotationMatrix)
        
        let yAxis: GLKVector3       = GLKMatrix4MultiplyVector3(SCNMatrix4ToGLKMatrix4(SCNMatrix4Invert(rotationMatrix)), GLKVector3Make(0.0, 1.0, 0.0))
        print("\(#function) yAxis: \(yAxis)")

        rotationMatrix  = SCNMatrix4FromGLKMatrix4(GLKMatrix4Rotate(glkRotationMatrix, rotationY, yAxis.x, yAxis.y, yAxis.z))
        
        currentTouchPosition    = simd_float3(x: Float(value.location.x), y: Float(value.location.y), z: 0.0)
        
        currentTouchPosition    = projectCameraRotationOnSurface(of: currentTouchPosition)
        print("\(#function) currentTouchPosition: \(currentTouchPosition)")

        quaternion = computeIncremental()
        print("\(#function) quaternion: \(quaternion)")

        //currentCameraNode.simdOrientation = quaternion
    }
    */
    
    
    func changeCameraNodeTouches(of currentCameraNode: SCNNode, with value: DragGesture.Value) {
        
        print("\n\(#function)!")
        
        anchorTouchPosition     = simd_float3(x: Float(value.startLocation.x),
                                              y: Float(value.startLocation.y),
                                              z: 0.0)
        print("\(#function) anchorTouchPosition: \(anchorTouchPosition)")
        
        anchorTouchPosition     = projectCameraRotationOnSurface(of: anchorTouchPosition)
        print("\(#function) projected rotation on surface anchorTouchPosition: \(anchorTouchPosition)")
        
        startQuaterion          = quaternion
        print("\(#function) startQuaternion: \(quaternion)")
        
        let startTouchLocation  = simd_float3(x: Float(value.startLocation.x),
                                              y: Float(value.startLocation.y),
                                              z: 0.0)

        //currentTouchPosition    = anchorTouchPosition
        currentTouchPosition    = simd_float3(x: Float(value.location.x),
                                              y: Float(value.location.y),
                                              z: 0.0)
        print("\(#function) currentTouchPosition: \(currentTouchPosition)")
        
        /*
        let difference = CGPointMake(CGFloat(currentTouchPosition.x - startTouchLocation.x),
                                     CGFloat(currentTouchPosition.y - startTouchLocation.y))
        print("\(#function) difference of anchor and current touch points: \(difference)")
        
        let differenceX = currentTouchPosition.x - startTouchLocation.x
        print("\(#function) differenceX of anchor and current touch points: \(differenceX)")

        print("\(#function) value.translation: \(value.translation)")
         */
        

        let rotationX   = -1.0 * GLKMathDegreesToRadians(Float(value.translation.width) / 2.0) / 10.0
        let rotationY   = 1.0 * GLKMathDegreesToRadians(Float(value.translation.height) / 2.0) / 10.0
        print("\(#function) rotationX: \(rotationX)")
        print("\(#function) rotationY: \(rotationY)")
        //print("\(#function) rotationMatrix: \(rotationMatrix)")


        var glkRotationMatrix           = SCNMatrix4ToGLKMatrix4(rotationMatrix)
        print("\(#function) glkRotationMatrix: \(NSStringFromGLKMatrix4(glkRotationMatrix))")

        
        let xAxis: GLKVector3   = GLKMatrix4MultiplyVector3(SCNMatrix4ToGLKMatrix4(SCNMatrix4Invert(rotationMatrix)), GLKVector3Make(1.0, 0.0, 0.0))
        print("\(#function) xAxis: \(NSStringFromGLKVector3(xAxis))")
        
        rotationMatrix          = SCNMatrix4FromGLKMatrix4(GLKMatrix4Rotate(glkRotationMatrix, rotationX, xAxis.x, xAxis.y, xAxis.z))
        
        glkRotationMatrix       = SCNMatrix4ToGLKMatrix4(rotationMatrix)
        
        let yAxis: GLKVector3   = GLKMatrix4MultiplyVector3(SCNMatrix4ToGLKMatrix4(SCNMatrix4Invert(rotationMatrix)), GLKVector3Make(0.0, 1.0, 0.0))
        print("\(#function) yAxis: \(NSStringFromGLKVector3(yAxis))")
        
        rotationMatrix  = SCNMatrix4FromGLKMatrix4(GLKMatrix4Rotate(glkRotationMatrix, rotationY, yAxis.x, yAxis.y, yAxis.z))
        
        //currentTouchPosition    = simd_float3(x: Float(value.location.x), y: Float(value.location.y), z: 0.0)
        //print("\(#function) currentTouchPosition: \(currentTouchPosition)")

        currentTouchPosition    = projectCameraRotationOnSurface(of: currentTouchPosition)
        print("\(#function) currentTouchPosition: \(currentTouchPosition)")
        
        quaternion = computeIncremental().normalized
        print("\(#function) quaternion: \(quaternion)")
        
        quaternion = simd_quatf(ix: 0.0, iy: quaternion.axis.y, iz: quaternion.axis.x, r: quaternion.angle)
        
        //currentCameraNode.orientation   = quaternion
        currentCameraNode.simdOrientation   = quaternion.normalized
    }
    
    
    
    func updateCameraNodeTouches(of currentCameraNode: SCNNode) {
        let rotationMatrix = GLKMatrix4MakeWithQuaternion(GLKQuaternionMake(quaternion.axis.x, quaternion.axis.y, quaternion.axis.z, quaternion.angle))
        
        currentCameraTransform = currentCameraNode.transform
        
        var modelMatrix = SCNMatrix4ToGLKMatrix4(currentCameraTransform)
        modelMatrix     = GLKMatrix4Multiply(modelMatrix, rotationMatrix)
        //currentCameraTransform = SCNMatrix4FromGLKMatrix4(modelMatrix)
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
        
        let radius: Float       = Float(diag / 3.0)
        let center: simd_float3 = simd_float3(Float(width / 2.0), Float(height / 2.0), 0.0)
        
        var pixelCoordinateVector   = touchPoint - center // This is why I love simd!
        
        // Inverting pixelCoordinateVector's y-coord because the y-axis on the screen is negative.
        pixelCoordinateVector.y     *= -1
        
        let radiusSquared: Float    = pow(radius, 2)
        let lengthSquared: Float    = pow(pixelCoordinateVector.x, 2) + pow(pixelCoordinateVector.y, 2)
        
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
            pixelCoordinateVector   = simd_make_float3(pixelCoordinateVector.x / length,
                                                       pixelCoordinateVector.y / length,
                                                       pixelCoordinateVector.z / length)
        }
        
        return simd_normalize(pixelCoordinateVector)
        
    }

    
    
    func computeIncremental() -> simd_quatf {
        
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
        print("\(#function) anchorTouchPosition: \(anchorTouchPosition)")
        print("\(#function) currentTouchPosition: \(currentTouchPosition)")

        let axis   = simd_cross(anchorTouchPosition, currentTouchPosition)
        //let axis               = anchorTouchPosition * currentTouchPosition
        print("\(#function) axis: \(axis)")

        let dotProduct   = simd_dot(anchorTouchPosition, currentTouchPosition)
        print("\(#function) dotProduct: \(dotProduct)")

        let angle        = acosf(dotProduct)
        print("\(#function) angle: \(angle)")

        
        let rotationQuaternion  = simd_quatf(angle: angle, axis: axis).normalized
        print("\(#function) rotationQuaternion: \(rotationQuaternion)")

     
        let tempQuaternion              = simd_mul(rotationQuaternion, startQuaterion)
        print("\(#function) tempQuaternion: \(tempQuaternion)")

        return simd_mul(rotationQuaternion, startQuaterion)
    }
    
    
    
    
}
