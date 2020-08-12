//
//  SceneKitWithSwiftUIContentView.swift
//  SceneKitSwiftUIGesturesDemoApp
//
//  Created by James Hillhouse IV on 7/30/20.
//


import SwiftUI
import SceneKit



struct SceneKitWithSwiftUIContentView: View {
    @State private var sunlightSwitch   = true
    @State private var magnify          = CGFloat(1.0)

    var magnification: some Gesture {
        MagnificationGesture()
            .onChanged{ (value) in
                self.magnify = value
                print("MagnificationGesture .onChanged value = \(value)")

                // Below doesn't work.
                /*
                let maximumFOV: CGFloat = 25 // This is what determines the farthest point into which to zoom.
                let minimumFOV: CGFloat = 90 // This is what determines the farthest point from which to zoom.

                self.aircraftScene.rootNode.childNode(withName: "distantCameraNode", recursively: true)?.camera?.fieldOfView /= magnify

                if (self.aircraftScene.rootNode.childNode(withName: "distantCameraNode", recursively: true)?.camera!.fieldOfView)! <= maximumFOV {
                    self.aircraftScene.rootNode.childNode(withName: "distantCameraNode", recursively: true)?.camera?.fieldOfView = maximumFOV
                }
                if (self.aircraftScene.rootNode.childNode(withName: "distantCameraNode", recursively: true)?.camera!.fieldOfView)! >= minimumFOV {
                    self.aircraftScene.rootNode.childNode(withName: "distantCameraNode", recursively: true)?.camera?.fieldOfView = minimumFOV
                }
                */
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

            let maximumFOV: CGFloat = 25 // This is what determines the farthest point into which to zoom.
            let minimumFOV: CGFloat = 90 // This is what determines the farthest point from which to zoom.

            scene.rootNode.childNode(withName: "distantCameraNode", recursively: true)?.camera?.fieldOfView /= magnify

            if (scene.rootNode.childNode(withName: "distantCameraNode", recursively: true)?.camera!.fieldOfView)! <= maximumFOV {
                scene.rootNode.childNode(withName: "distantCameraNode", recursively: true)?.camera?.fieldOfView = maximumFOV
            }
            if (scene.rootNode.childNode(withName: "distantCameraNode", recursively: true)?.camera!.fieldOfView)! >= minimumFOV {
                scene.rootNode.childNode(withName: "distantCameraNode", recursively: true)?.camera?.fieldOfView = minimumFOV
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
                pointOfView: aircraftScene.rootNode.childNode(withName: "distantCameraNode", recursively: true),
                options: []
            )
            .background(Color.black)
            .gesture(magnification)

            VStack() {
                Text("Hello, SceneKit!").multilineTextAlignment(.leading).padding()
                    .foregroundColor(Color.gray)
                    .font(.largeTitle)

                Text("Pinch to zoom.")
                    .foregroundColor(Color.gray)
                    .font(.title)

                Spacer(minLength: 300)

                // Doesn't work because redraw redefines aircraftScene with default light intensity (1000)
                /*
                Button( action: {
                    withAnimation{
                        self.sunlightSwitch.toggle()
                    }
                    if self.sunlightSwitch == true {
                        self.aircraftScene.rootNode.childNode(withName: "sunlightNode", recursively: true)?.light?.intensity = 2000.0
                    } else {
                        self.aircraftScene.rootNode.childNode(withName: "sunlightNode", recursively: true)?.light?.intensity = 0.0
                    }
                }) {
                    Image(systemName: sunlightSwitch ? "lightbulb.fill" : "lightbulb")
                        .imageScale(.large)
                        .accessibility(label: Text("Light Switch"))
                        .padding()
                }*/
                ControlsView(sunlightSwitch: $sunlightSwitch)
            }
        }
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
