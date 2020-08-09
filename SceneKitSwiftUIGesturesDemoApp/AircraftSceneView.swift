//
//  AircraftSceneView.swift
//  SceneKitSwiftUIGesturesDemoApp
//
//  Created by James Hillhouse IV on 8/8/20.
//

import SwiftUI
import SceneKit



struct AircraftSceneView: View {
    @Binding var sunlightSwitch: Bool



    // Create a scene.
    var aircraftScene: SCNScene {
        get {
            print("\nLoading Scene Assets.")
            guard let scene = SCNScene(named: "art.scnassets/ship.scn")
            else {
                print("Oopsie, no scene")
                return SCNScene()
            }

            print("Setting lightIntensity property")
            if self.sunlightSwitch == true {
                scene.rootNode.childNode(withName: "sunlightNode", recursively: true)?.light?.intensity = 2000.0
            } else {
                scene.rootNode.childNode(withName: "sunlightNode", recursively: true)?.light?.intensity = 0.0
            }


            print("Created and returned a scene.")
            return scene
        }
    }


    /*
    var lightIntensity: CGFloat {
        get {
            print("Creating a new lightIntensity property.")
            return (aircraftScene.rootNode.childNode(withName: "sunlightNode", recursively: true)?.light!.intensity)!
        }
        set {
            print("Setting lightIntensity property")
            if self.sunlightSwitch == true {
                aircraftScene.rootNode.childNode(withName: "sunlightNode", recursively: true)?.light?.intensity = 2000.0
            } else {
                aircraftScene.rootNode.childNode(withName: "sunlightNode", recursively: true)?.light?.intensity = 0.0
            }
        }
    }
    */

    /*
    // The camera node for the scene.
    var pointOfViewNode: SCNNode? {
        get {
            print("Creating a point of view node from the cameras in the SCN file.")
            var node = SCNNode()

            node = aircraftScene.rootNode.childNode(withName: "distantCameraNode", recursively: true)!
            print("Current Camera Node: \(String(describing: node.camera?.name))")

            /*
            let maximumFOV: CGFloat = 25 // This is what determines the farthest point into which to zoom.
            let minimumFOV: CGFloat = 90 // This is what determines the farthest point from which to zoom.

            if !doneMagnifying {
                node.camera?.fieldOfView /= magnifyBy
            } else {
                node.camera?.fieldOfView /= magnify
            }

            if node.camera!.fieldOfView <= maximumFOV {
                node.camera!.fieldOfView = maximumFOV
            }
            if node.camera!.fieldOfView >= minimumFOV {
                node.camera!.fieldOfView = minimumFOV
            }
            */
            return node
        }
    }
    */



    var body: some View {
        SceneView(scene: aircraftScene,
                  pointOfView: aircraftScene.rootNode.childNode(withName: "distantCameraNode", recursively: true)!,
                  options: [])
    }
}
