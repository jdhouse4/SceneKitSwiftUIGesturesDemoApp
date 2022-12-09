//
//  SpacecraftSceneKitScene.swift
//  SceneKitSwiftUIGesturesDemoApp
//
//  Created by James Hillhouse IV on 12/01/22.
//

import Foundation
import SceneKit




/**
 This is the SceneKit Model for the  of the SwiftUISceneKitCoreMotionDemo app.
 */
final class SpacecraftSceneKitScene: SCNScene, ObservableObject {
    
    static let shared                               = SpacecraftSceneKitScene()

    var spacecraftScene                             = SCNScene(named: "art.scnassets/Spacecraft/Orion_CSM_Assets/Orion_CSM.scn")!

    var spacecraftSceneNode: SCNNode
    
    var spacecraftNode                              = SCNNode()

    /// Aircraft camera strings (This should be an enum)
    @Published var spacecraftNodeString             = "Orion_CSM_Node"
    @Published var spacecraftDistantCameraString    = SpacecraftCamera.spacecraftChase360Camera.rawValue
    @Published var spacecraftInteriorCameraString   = SpacecraftCamera.spacecraftCommanderCamera.rawValue

    /// Aircraft cameras
    @Published var spacecraftCurrentCamera: SCNNode
    @Published var spacecraftDistantCamera: SCNNode
    @Published var spacecraftInteriorCamera: SCNNode

    /// Aircraft camera nodes
    @Published var spacecraftCurrentCameraNode: SCNNode
    @Published var spacecraftDistantCameraNode: SCNNode
    @Published var spacecraftInteriorCameraNode: SCNNode

    /// Orientation
    @Published var spacecraftQuaternion: simd_quatf = simd_quatf(ix: 0.0, iy: 0.0, iz: 0.0, r: 1.0)
    @Published var deltaQuaternion: simd_quatf      = simd_quatf(ix: 0.0, iy: 0.0, iz: 0.0, r: 1.0)
    
    let deltaOrientationAngle: Float                = 0.0078125 * .pi / 180.0 // This results in a 0.5°/s attitude change. 0.015625 = 1°/s

    

    private override init() {
        print("SpacecraftScenekitScene private override initialized")
        self.spacecraftSceneNode          = spacecraftScene.rootNode.childNode(withName: "Orion_CSM_Scene_Node", recursively: true)!
        
        self.spacecraftNode               = spacecraftScene.rootNode.childNode(withName: "Orion_CSM_Node", recursively: true)!
        
        self.spacecraftCurrentCamera      = spacecraftScene.rootNode.childNode(withName: "OrionChase360Camera", recursively: true)!
        
        self.spacecraftDistantCamera      = spacecraftScene.rootNode.childNode(withName: "OrionChase360Camera", recursively: true)!
        
        self.spacecraftInteriorCamera     = spacecraftScene.rootNode.childNode(withName: "OrionCommanderCamera", recursively: true)!

        self.spacecraftCurrentCameraNode  = spacecraftScene.rootNode.childNode(withName: "OrionExteriorCamerasNode", recursively: true)!
        
        self.spacecraftDistantCameraNode  = spacecraftScene.rootNode.childNode(withName: "OrionChase360CameraNode", recursively: true)!

        self.spacecraftInteriorCameraNode = spacecraftScene.rootNode.childNode(withName: "OrionCommanderCameraNode", recursively: true)!

        
        super.init()
        
        // This defines the "neck" of the commander for the camera.
        self.spacecraftInteriorCamera.simdPivot.columns.3.y = -0.09
    }

    
    required init?(coder: NSCoder) {
        print("SpacecraftScenekitScene required initializer")
        self.spacecraftSceneNode          = spacecraftScene.rootNode.childNode(withName: "Orion_CSM_Scene_Node", recursively: true)!
        
        self.spacecraftNode               = spacecraftScene.rootNode.childNode(withName: "Orion_CSM_Node", recursively: true)!
        
        self.spacecraftCurrentCamera      = spacecraftScene.rootNode.childNode(withName: "OrionChase360Camera", recursively: true)!
        
        self.spacecraftDistantCamera      = spacecraftScene.rootNode.childNode(withName: "OrionChase360Camera", recursively: true)!
        
        self.spacecraftInteriorCamera     = spacecraftScene.rootNode.childNode(withName: "OrionCommanderCamera", recursively: true)!
        
        self.spacecraftCurrentCameraNode  = spacecraftScene.rootNode.childNode(withName: "OrionExteriorCamerasNode", recursively: true)!
        
        self.spacecraftDistantCameraNode  = spacecraftScene.rootNode.childNode(withName: "OrionChase360CameraNode", recursively: true)!
        
        self.spacecraftInteriorCameraNode = spacecraftScene.rootNode.childNode(withName: "OrionCommanderCameraNode", recursively: true)!


        super.init(coder: coder)
        
        // This defines the "neck" of the commander for the camera.
        self.spacecraftInteriorCamera.simdPivot.columns.3.y = -0.09
    }
}
