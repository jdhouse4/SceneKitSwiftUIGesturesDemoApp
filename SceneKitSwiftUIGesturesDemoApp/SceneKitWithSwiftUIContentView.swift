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
    @State private var aircraftScene    = SCNScene(named: "art.scnassets/ship.scn")

    var camera: SCNNode {
        let node = (SCNScene(named: "art.scnassets/ship.scn")?.rootNode.childNode(withName: "distantCameraNode", recursively: true))!

        let maximumFOV: CGFloat = 25 // This is what determines the farthest point into which to zoom.
        let minimumFOV: CGFloat = 90 // This is what determines the farthest point from which to zoom.

        node.camera?.fieldOfView /= magnify

        if node.camera!.fieldOfView <= maximumFOV {
            node.camera!.fieldOfView = maximumFOV
        }
        if node.camera!.fieldOfView >= minimumFOV {
            node.camera!.fieldOfView = minimumFOV
        }

        return node
    }


    var body: some View {
        ZStack {
            Color.black.edgesIgnoringSafeArea(.all)

            SceneView (
                scene: aircraftScene,
                pointOfView: camera,
                options: []
            )
            .background(Color.black)
            .gesture(MagnificationGesture()
                        .onChanged{ (value) in
                            print("magnify = \(self.magnify)")
                            self.magnify = value
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


struct SceneKitWithSwiftUIContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            SceneKitWithSwiftUIContentView()
        }
    }
}
