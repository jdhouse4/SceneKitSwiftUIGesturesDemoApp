//
//  SwiftUISceneKitUsingVarsWithCopyContentView.swift
//  SceneKitSwiftUIGesturesDemoApp
//
//  Created by James Hillhouse IV on 8/12/20.
//

import SwiftUI
import SceneKit




struct SwiftUISceneKitUsingVarsWithCopyContentView: View {
    @State private var sunlightSwitch   = true
    @State private var magnify          = CGFloat(1.0)

    private var _aircraftScene          = SCNScene(named: "art.scnassets/ship.scn")

    var magnification: some Gesture {
        MagnificationGesture()
            .onChanged{ (value) in
                self.magnify = value
                print("MagnificationGesture .onChanged value = \(value)")

                if self.magnify >= 1.01 {
                    self.magnify = 1.01
                }
                if self.magnify <= 0.99 {
                    self.magnify = 0.99
                }

                let maximumFOV: CGFloat = 25 // This is what determines the farthest point into which to zoom.
                let minimumFOV: CGFloat = 90 // This is what determines the farthest point from which to zoom.

                self._aircraftScene!.rootNode.childNode(withName: "distantCameraNode", recursively: true)?.camera?.fieldOfView /= magnify

                if (self._aircraftScene!.rootNode.childNode(withName: "distantCameraNode", recursively: true)?.camera!.fieldOfView)! <= maximumFOV {
                    self._aircraftScene!.rootNode.childNode(withName: "distantCameraNode", recursively: true)?.camera?.fieldOfView = maximumFOV
                    self.magnify = 1.0
                }
                if (self._aircraftScene!.rootNode.childNode(withName: "distantCameraNode", recursively: true)?.camera!.fieldOfView)! >= minimumFOV {
                    self._aircraftScene!.rootNode.childNode(withName: "distantCameraNode", recursively: true)?.camera?.fieldOfView = minimumFOV
                    self.magnify = 1.0
                }
            }
    }

    // Create a scene.
    var aircraftScene: SCNScene {
        mutating get {
            print("Loading Scene Assets.")
            if !isKnownUniquelyReferenced(&_aircraftScene) {
                _aircraftScene = (_aircraftScene?.copy() as! SCNScene)
            }

            print("Created and returned a scene.\n\n")
            return _aircraftScene!
        }
        set {
            _aircraftScene = newValue
        }
    }



    var body: some View {
        ZStack {
            Color.black.edgesIgnoringSafeArea(.all)

            SceneView (
                scene: _aircraftScene,
                pointOfView: _aircraftScene!.rootNode.childNode(withName: "distantCameraNode", recursively: true)!,
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


                Text("Magnification: \(magnify, specifier: "%.2f")")
                    .foregroundColor(Color.gray)
                    .font(.title3)
                    .padding()


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

struct SwiftUISceneKitUsingVarsWithCopyContentView_Previews: PreviewProvider {
    static var previews: some View {
        SwiftUISceneKitUsingVarsWithCopyContentView()
    }
}
