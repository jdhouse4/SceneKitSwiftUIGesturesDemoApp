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

            /*
           let lightNode = scene.rootNode.childNode(withName: "sunlightNode", recursively: true)

           if self.sunlightSwitch == true {
               lightNode!.light?.intensity      = 2000.0
           } else {
               lightNode!.light?.intensity      = 0
           }
            */

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

            return node
        }/*
        set {
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

        }*/
    }


    var fieldOfView: CGFloat {
        get {
            return (self.pointOfViewNode?.camera!.fieldOfView)!
        }
        set {
            let maximumFOV: CGFloat = 25 // This is what determines the farthest point into which to zoom.
            let minimumFOV: CGFloat = 90 // This is what determines the farthest point from which to zoom.

            if !doneMagnifying {
                pointOfViewNode?.camera?.fieldOfView /= magnifyBy
            } else {
                pointOfViewNode?.camera?.fieldOfView /= magnify
            }

            if (pointOfViewNode?.camera!.fieldOfView)! <= maximumFOV {
                pointOfViewNode?.camera?.fieldOfView = maximumFOV
            }
            if (pointOfViewNode?.camera!.fieldOfView)! >= minimumFOV {
                pointOfViewNode?.camera?.fieldOfView = minimumFOV
            }

            //pointOfViewNode?.camera?.fieldOfView = newValue
        }
    }



    var lightNode: SCNNode {
        get {
            return aircraftScene.rootNode.childNode(withName: "sunlightNode", recursively: true)!
        }
    }



    var lightIntensity: CGFloat {
        get {
            return aircraftScene.rootNode.childNode(withName: "sunlightNode", recursively: true)!.light!.intensity
        }
        set {
            aircraftScene.rootNode.childNode(withName: "sunlightNode", recursively: true)!.light!.intensity = newValue
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

                Button( action: {
                    withAnimation{ self.sunlightSwitch.toggle() }

                    //self.sunlightSwitch ? lightIntensity = 2000.0 : self.lightIntensity = 0
                    if self.sunlightSwitch == false {
                        lightIntensity = 0.0
                    }
                }) {
                    Image(systemName: sunlightSwitch ? "lightbulb.fill" : "lightbulb")
                        .imageScale(.large)
                        .accessibility(label: Text("Light Switch"))
                        .padding()
                }

                //ControlsView(sunlightSwitch: $sunlightSwitch)
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
