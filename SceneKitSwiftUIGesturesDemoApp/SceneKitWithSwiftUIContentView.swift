//
//  SceneKitWithSwiftUIContentView.swift
//  SceneKitSwiftUIGesturesDemoApp
//
//  Created by James Hillhouse IV on 7/30/20.
//


import SwiftUI
import SceneKit



struct SceneKitWithSwiftUIContentView: View {
    
    @State private var magnify          = CGFloat(1.0)
    @State private var doneMagnifying   = false

    @GestureState var magnifyBy         = CGFloat(1.0)

    var magnification: some Gesture {
        MagnificationGesture()
            .updating($magnifyBy) { (currentState, gestureState, transaction) in
                gestureState = currentState
            }
            .onChanged{ (value) in
                self.magnify = value
            }
            .onEnded { _ in
                self.doneMagnifying = true
            }
    }


    // The camera node for the scene.
    var cameraNode: SCNNode? {
        get {
            print("Creating camera node from the cameras in the SCN file.")
            var node = SCNNode()

            node = aircraftScene.rootNode.childNode(withName: "distantCameraNode", recursively: true)!
            print("Current Camera Node: \(String(describing: node.camera?.name))")


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

            return node
        }
    }



     // Create a scene.
    var aircraftScene: SCNScene {
        get {
            print("Loading Scene Assets.")
            guard let scene = SCNScene(named: "art.scnassets/ship.scn")
            else {
                print("Oopsie, no scene")
                return SCNScene()
            }

            print("Created and returned a scene.\n\n")
            return scene
        }
    }



    var body: some View {
        ZStack {
            Color.black.edgesIgnoringSafeArea(.all)

            SceneView (
                scene: aircraftScene,
                pointOfView: cameraNode,
                options: []
            )
            .background(Color.black)

            VStack() {
                Text("Hello, SceneKit!").multilineTextAlignment(.leading).padding()
                    .foregroundColor(Color.gray)
                    .font(.largeTitle)

                Text("Pinch to zoom.")
                    .foregroundColor(Color.gray)
                    .font(.title)

                Spacer(minLength: 300)
            }
        }
        .gesture(magnification)
        .statusBar(hidden: true)
    }
}


struct SceneKitWithSwiftUIContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            SceneKitWithSwiftUIContentView()
        }
    }
}
