//
//  AircraftScene.swift
//  SceneKitSwiftUIGesturesDemoApp
//
//  Created by James Hillhouse IV on 10/16/20.
//

import Foundation
import SceneKit



class AircraftScene: SCNScene, SCNSceneRendererDelegate {

    var aircraft: SCNScene      = SCNScene()
    var aircraftNode: SCNNode   = SCNNode()
    var motionManager: PFMotionManager
    var sceneQuaternion: SCNQuaternion


    /*:
    MARK:- Initializers
    */
    override init()
    {
        print("AircraftScene object initialized.")

        //
        // MARK: Create an instance of PFMotionMangerInstance.
        //
        self.motionManager      = PFMotionManager.missionOrionSharedMotionMangerInstance
        self.sceneQuaternion    = self.motionManager.sceneQuaternion



        super.init()

        aircraft                = SCNScene(named: "art.scnassets/ship.scn")!
        aircraftNode            = rootNode.childNode(withName: "ship", recursively: true)!
    }
}
