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

    var _previousUpdateTime: TimeInterval   = 0.0
    var _deltaTime: TimeInterval            = 0.0



    /*:
    MARK:- Initializers
    */
    override init()
    {
        print("AircraftScene object initialized.")

        //
        // MARK: Create an instance of PFMotionMangerInstance.
        //
        self.motionManager      = PFMotionManager.sharedMotionMangerInstance
        self.sceneQuaternion    = self.motionManager.sceneQuaternion!



        super.init()

        aircraft                = SCNScene(named: "art.scnassets/ship.scn")!
        aircraftNode            = rootNode.childNode(withName: "ship", recursively: true)!
    }



    required init?(coder: NSCoder) {
        self.motionManager      = PFMotionManager.sharedMotionMangerInstance
        self.sceneQuaternion    = self.motionManager.sceneQuaternion!

        super .init(coder: coder)
    }


    func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval)
    {

        // The main input pump for the simulator.

        if _previousUpdateTime == 0.0
        {
            _previousUpdateTime     = time
        }


        _deltaTime                  = time - _previousUpdateTime
        _previousUpdateTime         = time


        //
        // MARK: Update the attitude.quaternion from device manager
        //
        motionManager.updateAttitudeQuaternion()


        //
        // MARK: ChaseCamera
        //
        /*
        if aSceneView.pointOfView?.name == CameraType.OrionChaseCamera.rawValue
        {
        }


        //
        // MARK: CommanderCamera
        //
        if aSceneView.pointOfView?.name == CameraType.OrionCommanderCamera.rawValue
        {
        }
         */
    }
}
