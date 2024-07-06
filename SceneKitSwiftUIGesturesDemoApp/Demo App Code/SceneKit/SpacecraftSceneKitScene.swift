//
//  SpacecraftSceneKitScene.swift
//  SceneKitSwiftUIGesturesDemoApp
//
//  Created by James Hillhouse IV on 12/01/22.
//

import Foundation
import SceneKit



@globalActor actor SceneActor: GlobalActor {
    
    static let shared = SceneActor()
    
}



/**
 This is the SceneKit Model for the  of the SwiftUISceneKitCoreMotionDemo app.
 */

final class SpacecraftSceneKitScene: SCNScene, ObservableObject {
    
    @MainActor public static let shared    = SpacecraftSceneKitScene()
    
    private let serialQueue     = DispatchQueue(label: "serialQueue")
    
    var spacecraftScene         = SCNScene(named: "art.scnassets/Spacecraft/Orion_CSM_Assets/Orion_CSM.scn")!
    @MainActor var spacecraftSceneNode: SCNNode
    
    /// Aircraft camera strings (This should be an enum)
    @Published var spacecraftNodeString                 = "Orion_CSM_Node"
    @Published var spacecraftChase360CameraString       = SpacecraftCamera.spacecraftChase360Camera.rawValue
    @Published var spacecraftCommanderCameraString      = SpacecraftCamera.spacecraftCommanderCamera.rawValue
    
    /// Spacecraft cameras
    @Published var spacecraftCurrentCamera: SCNNode
    
    @Published var spacecraftChase360Camera: SCNNode
    @Published var spacecraftCommanderCamera: SCNNode
    
    
    /// Spacecraft camera nodes
    // Thses are published so that they are exposed to the Camera Buttons View for switching cameras.
    @Published var spacecraftCurrentCameraNode: SCNNode
    
    @Published var spacecraftChase360CameraNode: SCNNode
    @Published var spacecraftCommanderCameraNode: SCNNode
    
    
    private override init() {
        print("SpacecraftScenekitScene private override initialized")
        self.spacecraftSceneNode            = await spacecraftScene.rootNode.childNode(withName: "Orion_CSM_Scene_Node", recursively: true)!
        
        //self.spacecraftNode               = spacecraftScene.rootNode.childNode(withName: "Orion_CSM_Node", recursively: true)!
        
        self.spacecraftCurrentCamera            = spacecraftScene.rootNode.childNode(withName: "OrionChase360Camera", recursively: true)!
        
        self.spacecraftChase360Camera           = spacecraftScene.rootNode.childNode(withName: "OrionChase360Camera", recursively: true)!
        
        self.spacecraftCommanderCamera          = spacecraftScene.rootNode.childNode(withName: "OrionCommanderCamera", recursively: true)!
        
        self.spacecraftCurrentCameraNode        = spacecraftScene.rootNode.childNode(withName: "OrionChase360CameraNode", recursively: true)!
        
        self.spacecraftChase360CameraNode       = spacecraftScene.rootNode.childNode(withName: "OrionChase360CameraNode", recursively: true)!
        
        self.spacecraftCommanderCameraNode      = spacecraftScene.rootNode.childNode(withName: "OrionCommanderCameraNode", recursively: true)!
        
        
        super.init()
        
        // This defines the "neck" of the commander for the camera.
        self.spacecraftCommanderCamera.simdPivot.columns.3.y = -0.09
    }
    
    
    //
    // This class will never be subclassed.
    //
    internal required init?(coder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
        
    }
    
}
