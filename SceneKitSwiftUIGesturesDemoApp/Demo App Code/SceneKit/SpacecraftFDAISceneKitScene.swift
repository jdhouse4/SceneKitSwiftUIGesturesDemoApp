//
//  SpacecraftFDAISceneKitScene.swift
//  SceneKitSwiftUIGesturesDemoApp
//
//  Created by James Hillhouse IV on 1/2/23.
//

import Foundation
import SceneKit




final class SpacecraftFDAISceneKitScene: SCNScene, ObservableObject {
    
    static let shared                       = SpacecraftFDAISceneKitScene()
    
    var spacecraftFDAIScene                 = SCNScene(named: "art.scnassets/Spacecraft/Orion_CSM_Assets/Orion_CM_FDAI.scn")!
    
    var spacecraftFDAISceneNode: SCNNode
    
    var spacecraftFDAINode                  = SCNNode()
    

}
