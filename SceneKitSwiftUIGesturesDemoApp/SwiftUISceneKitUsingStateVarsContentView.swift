//
//  SwiftUISceneKitUsingStateVarsContentView.swift
//  SceneKitSwiftUIGesturesDemoApp
//
//  Created by James Hillhouse IV on 8/10/20.
//

import SwiftUI
import SceneKit




struct SwiftUISceneKitUsingStateVarsContentView: View {
    @State private var sunlightSwitch   = true
    @State private var magnify          = CGFloat(1.0)
    @State private var aircraftScene    = SCNScene(named: "art.scnassets/ship.scn")



    var body: some View {
        ZStack {
            Color.black.edgesIgnoringSafeArea(.all)

            SceneView (
                scene: aircraftScene,
                pointOfView: aircraftScene?.rootNode.childNode(withName: "distantCameraNode", recursively: true),
                options: []
            )
            .background(Color.black)
            .gesture(MagnificationGesture()
                        .onChanged{ (value) in
                            print("magnify = \(self.magnify)")
                            self.magnify = value

                            let maximumFOV: CGFloat = 25 // This is what determines the farthest point into which to zoom.
                            let minimumFOV: CGFloat = 90 // This is what determines the farthest point from which to zoom.

                            self.aircraftScene!.rootNode.childNode(withName: "distantCameraNode", recursively: true)?.camera?.fieldOfView /= magnify

                            if (self.aircraftScene!.rootNode.childNode(withName: "distantCameraNode", recursively: true)?.camera!.fieldOfView)! <= maximumFOV {
                                self.aircraftScene!.rootNode.childNode(withName: "distantCameraNode", recursively: true)?.camera?.fieldOfView = maximumFOV
                            }
                            if (self.aircraftScene!.rootNode.childNode(withName: "distantCameraNode", recursively: true)?.camera!.fieldOfView)! >= minimumFOV {
                                self.aircraftScene!.rootNode.childNode(withName: "distantCameraNode", recursively: true)?.camera?.fieldOfView = minimumFOV
                            }

                        }
            )

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
                        self.aircraftScene!.rootNode.childNode(withName: "sunlightNode", recursively: true)?.light?.intensity = 2000.0
                    } else {
                        self.aircraftScene!.rootNode.childNode(withName: "sunlightNode", recursively: true)?.light?.intensity = 0.0
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

struct SwiftUISceneKitUsingStateVarsContentView_Previews: PreviewProvider {
    static var previews: some View {
        SwiftUISceneKitUsingStateVarsContentView()
    }
}

