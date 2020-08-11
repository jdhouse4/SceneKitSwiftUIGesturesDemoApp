//
//  SwiftUISceneKitUsingVarsContentView.swift
//  SceneKitSwiftUIGesturesDemoApp
//
//  Created by James Hillhouse IV on 8/11/20.
//

import SwiftUI
import SceneKit




struct SwiftUISceneKitUsingVarsContentView: View {
    @State private var sunlightSwitch   = true
    @State private var magnify          = CGFloat(1.0)
    @State private var doneMagnifying   = false

    @GestureState private var magnifyBy = CGFloat(1.0)

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




    // Create a scene.
   var aircraftScene: SCNScene {
       get {
           print("Loading Scene Assets.")
           guard let scene = SCNScene(named: "art.scnassets/ship.scn")
           else {
               print("Oopsie, no scene")
               return SCNScene()
           }

           let lightNode = scene.rootNode.childNode(withName: "sunlightNode", recursively: true)

           if self.sunlightSwitch == true {
               lightNode!.light?.intensity      = 2000.0
           } else {
               lightNode!.light?.intensity      = 0
           }

           print("Created and returned a scene.\n\n")
           return scene
       }
   }



    // The camera node for the scene.
    var pointOfViewNode: SCNNode? {
        get {
            print("Creating a point of view node from the cameras in the SCN file.")
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



    var body: some View {
        ZStack {
            Color.black.edgesIgnoringSafeArea(.all)

            SceneView (
                scene: aircraftScene,
                pointOfView: pointOfViewNode,
                options: []
            )
            .gesture(magnification)
            .background(Color.black)

            VStack() {
                Text("Hello, SceneKit!").multilineTextAlignment(.leading).padding()
                    .foregroundColor(Color.gray)
                    .font(.largeTitle)

                Text("Pinch to zoom.")
                    .foregroundColor(Color.gray)
                    .font(.title)

                Spacer(minLength: 300)

                ControlsView(sunlightSwitch: $sunlightSwitch)
            }
        }
        .statusBar(hidden: true)
    }
}

struct SwiftUISceneKitUsingVarsContentView_Previews: PreviewProvider {
    static var previews: some View {
        SwiftUISceneKitUsingVarsContentView()
    }
}
