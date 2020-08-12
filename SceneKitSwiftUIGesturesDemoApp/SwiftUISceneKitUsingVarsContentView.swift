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

    private var _aircraftScene          = SCNScene(named: "art.scnassets/ship.scn")
    private var _pointOfViewNode        = SCNScene(named: "art.scnassets/ship.scn")!.rootNode.childNode(withName: "distantCameraNode", recursively: true)!

    var magnification: some Gesture {
        MagnificationGesture()
            .updating($magnifyBy) { (currentState, gestureState, transaction) in
                gestureState = currentState
                //self._aircraftScene!.rootNode.childNode(withName: "distantCameraNode", recursively: true)!.camera?.fieldOfView /= magnifyBy
                self._pointOfViewNode.camera?.fieldOfView /= magnifyBy
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
        mutating get {
            print("Loading Scene Assets.")
            if !isKnownUniquelyReferenced(&_aircraftScene) {
                _aircraftScene = (_aircraftScene?.copy() as! SCNScene)
            }

            if self.sunlightSwitch == true {
                _aircraftScene!.rootNode.childNode(withName: "sunlightNode", recursively: true)!.light?.intensity      = 2000.0
            } else {
                _aircraftScene!.rootNode.childNode(withName: "sunlightNode", recursively: true)!.light?.intensity      = 0
            }

            print("Created and returned a scene.\n\n")
            return _aircraftScene!
        }
        set {
            _aircraftScene = newValue
        }
    }



    // The camera node for the scene.
    var pointOfViewNode: SCNNode? {
        mutating get {
            print("Creating a point of view node from the cameras in the SCN file.")
            if !isKnownUniquelyReferenced(&_pointOfViewNode) {
                _pointOfViewNode = _pointOfViewNode.copy() as! SCNNode
            }
            print("Current Camera Node: \(String(describing: _pointOfViewNode.camera?.name))")

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
            return _pointOfViewNode
        }
        set {
            _pointOfViewNode = newValue!
        }
    }



    var body: some View {
        ZStack {
            Color.black.edgesIgnoringSafeArea(.all)

            SceneView (
                scene: _aircraftScene,
                pointOfView: _pointOfViewNode,
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
                    withAnimation{
                        self.sunlightSwitch.toggle()
                    }
                    if self.sunlightSwitch == true {
                        self._aircraftScene!.rootNode.childNode(withName: "sunlightNode", recursively: true)?.light?.intensity = 2000.0
                    } else {
                        self._aircraftScene!.rootNode.childNode(withName: "sunlightNode", recursively: true)?.light?.intensity = 0.0
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

struct SwiftUISceneKitUsingVarsContentView_Previews: PreviewProvider {
    static var previews: some View {
        SwiftUISceneKitUsingVarsContentView()
    }
}
