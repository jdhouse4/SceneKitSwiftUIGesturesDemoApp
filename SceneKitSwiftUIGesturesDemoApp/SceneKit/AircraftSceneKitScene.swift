//
//  AircraftSceneKitScene.swift
//  SwiftUISceneKitCoreMotionDemo
//
//  Created by James Hillhouse IV on 10/18/20.
//

import Foundation
import SceneKit




/**
 This is the SceneKit Model for the  of the SwiftUISceneKitCoreMotionDemo app.
 */
final class AircraftSceneKitScene: SCNScene, ObservableObject {
    
    static let shared                           = AircraftSceneKitScene()

    var aircraftScene                           = SCNScene(named: "art.scnassets/ship.scn")!
    var aircraftSceneNode: SCNNode
    
    var aircraftNode                            = SCNNode()

    /// Aircraft camera strings (This should be an enum)
    @Published var aircraftNodeString           = "shipNode"
    @Published var aircraftDistantCameraString  = AircraftCamera.distantCamera.rawValue

    /// Aircraft cameras
    @Published var aircraftCurrentCamera: SCNNode

    @Published var aircraftShipCamera: SCNNode

    /// Aircraft camera nodes
    @Published var aircraftCurrentCameraNode: SCNNode
    
    @Published var aircraftShipCameraNode: SCNNode
    
    /// Orientation
    @Published var aircraftQuaternion: simd_quatf   = simd_quatf(ix: 0.0, iy: 0.0, iz: 0.0, r: 1.0)
    @Published var deltaQuaternion: simd_quatf      = simd_quatf(ix: 0.0, iy: 0.0, iz: 0.0, r: 1.0)
    
    let deltaOrientationAngle: Float                = 0.0078125 * .pi / 180.0 // This results in a 0.5°/s attitude change. 0.015625 = 1°/s

    

    private override init() {
        print("AircraftScenekitScene private override initialized")
        self.aircraftSceneNode          = aircraftScene.rootNode.childNode(withName: "shipSceneNode", recursively: true)!
        
        self.aircraftNode               = aircraftScene.rootNode.childNode(withName: "shipNode", recursively: true)!
        
        self.aircraftCurrentCamera      = aircraftScene.rootNode.childNode(withName: "distantCamera", recursively: true)!

        self.aircraftShipCamera         = aircraftScene.rootNode.childNode(withName: "shipCamera", recursively: true)!
        
        self.aircraftCurrentCameraNode  = aircraftScene.rootNode.childNode(withName: "distantCameraNode", recursively: true)!

        self.aircraftShipCameraNode     = aircraftScene.rootNode.childNode(withName: "shipCameraNode", recursively: true)!

        
        super.init()
    }

    
    required init?(coder: NSCoder) {
        print("AircraftScenekitScene required initializer")
        self.aircraftSceneNode          = aircraftScene.rootNode.childNode(withName: "shipSceneNode", recursively: true)!
        
        self.aircraftNode               = aircraftScene.rootNode.childNode(withName: "shipNode", recursively: true)!

        self.aircraftCurrentCamera      = aircraftScene.rootNode.childNode(withName: "distantCamera", recursively: true)!

        self.aircraftShipCamera         = aircraftScene.rootNode.childNode(withName: "shipCamera", recursively: true)!

        self.aircraftCurrentCameraNode  = aircraftScene.rootNode.childNode(withName: "distantCameraNode", recursively: true)!

        self.aircraftShipCameraNode     = aircraftScene.rootNode.childNode(withName: "shipCameraNode", recursively: true)!


        super.init(coder: coder)
    }
}
