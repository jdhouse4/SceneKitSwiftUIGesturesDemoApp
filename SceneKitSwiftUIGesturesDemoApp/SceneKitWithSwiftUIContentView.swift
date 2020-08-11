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
    @State private var pointOfViewNode  = (SCNScene(named: "art.scnassets/ship.scn")?.rootNode.childNode(withName: "distantCameraNode", recursively: true))!

    @GestureState private var magnifyBy = CGFloat(1.0)



    var body: some View {
        ZStack {
            Color.black.edgesIgnoringSafeArea(.all)

            SceneView (
                scene: aircraftScene,
                pointOfView: self.pointOfViewNode,
                options: []
            )
            .background(Color.black)
            .gesture(MagnificationGesture()
                        .onChanged{ (value) in
                            print("magnify = \(self.magnify)")
                            self.magnify = value

                            let maximumFOV: CGFloat = 25 // This is what determines the farthest point into which to zoom.
                            let minimumFOV: CGFloat = 90 // This is what determines the farthest point from which to zoom.

                            self.pointOfViewNode.camera?.fieldOfView /= magnify

                            if self.pointOfViewNode.camera!.fieldOfView <= maximumFOV {
                                self.pointOfViewNode.camera!.fieldOfView = maximumFOV
                            }
                            if self.pointOfViewNode.camera!.fieldOfView >= minimumFOV {
                                self.pointOfViewNode.camera!.fieldOfView = minimumFOV
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


struct SceneKitWithSwiftUIContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            SceneKitWithSwiftUIContentView()
        }
    }
}
