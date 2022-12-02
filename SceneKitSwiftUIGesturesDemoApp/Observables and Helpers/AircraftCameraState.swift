//
//  AircraftCameraState.swift
//  SwiftUISceneKitCoreMotionDemo
//
//  Created by James Hillhouse IV on 8/7/22.
//

import Foundation
import SceneKit
import simd




class AircraftCameraState: ObservableObject {
    
    static let shared = AircraftCameraState()
        
    @Published var currentCamera: SCNNode                       = SCNNode()
    @Published var updateCameraAttitude: Bool                   = false
    
    //
    // These have to do with the camera's orientation, etc.
    //
    @Published var currentCameraPivot: SCNMatrix4               = SCNMatrix4()
    @Published var currentCameraRotation: SCNVector4            = SCNVector4()
    @Published var currentCameraTransform: SCNMatrix4           = SCNMatrix4()
    @Published var currentCameraTotalPivot: SCNMatrix4          = SCNMatrix4()
    @Published var currentCameraInverseTransform: SCNMatrix4    = SCNMatrix4()
    
    
    
    func changeCameraOrientation(of currentCameraNode: SCNNode, with translation: CGSize) {
        //print("\n\(#function) translation: \(translation)")
        
        let x = Float(translation.width)
        let y = Float(-translation.height)

        let anglePan = sqrt(pow(x,2) + pow(y,2)) * (Float)(Double.pi) / 180.0
        //print("\(#function) anglePan (in degrees): \(anglePan * 180.0 / .pi)")

        var rotationVector = SCNVector4()

        rotationVector.x =  y
        rotationVector.y = -x
        rotationVector.z =  0
        rotationVector.w = anglePan

        //node.rotation = rotationVector
        
        currentCameraRotation = rotationVector
        //print("\(#function) currentCameraRotation: \(currentCameraRotation)")
        
        currentCameraNode.rotation = currentCameraRotation
        //print("\(#function) currentCameraRotation: \(currentCameraRotation)")
        
        //let rotationQuaternion = simd_quatf(ix: y, iy: -x, iz: 0, r: anglePan).normalized
        //print("\(#function) rotationQuaternion: \(rotationQuaternion)\n")
    }
    
    
    
    func updateCameraOrientation(of currentCameraNode: SCNNode) {
        
        print("\n\(#function) currentOrientation: \(currentCameraNode.orientation)")
        
        currentCameraPivot              = currentCameraNode.pivot
        print("currentCameraPivot: \(currentCameraPivot)")
        
        currentCameraTransform          = currentCameraNode.transform
        //print("currentCameraTransform: \(currentCameraTransform)")
        
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
        
        if currentCameraNode.name! + "Node" == AircraftCamera.shipCamera.rawValue {
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
        /// But Apple's SwiftUI and SceneKit people will need to resolve a few things, which they haven't done for two years.
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
}
