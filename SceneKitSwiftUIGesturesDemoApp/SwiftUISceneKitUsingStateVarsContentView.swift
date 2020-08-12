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
    @State private var aircraftScene    = SCNScene(named: "art.scnassets/ship.scn")!

    var body: some View {
        ZStack {
            Color.black.edgesIgnoringSafeArea(.all)

            SceneView (
                scene: aircraftScene,
                pointOfView: aircraftScene.rootNode.childNode(withName: "distantCameraNode", recursively: true)
            )
            .background(Color.black)
            .gesture(MagnificationGesture()
                        .onChanged{ (value) in
                            print("magnify = \(self.magnify)")
                            self.magnify = value

                            let camera = self.aircraftScene.rootNode.childNode(withName: "distantCameraNode", recursively: true)?.camera

                            let maximumFOV: CGFloat = 25 // Zoom-in.
                            let minimumFOV: CGFloat = 90 // Zoom-out.

                            camera!.fieldOfView /= magnify

                            if camera!.fieldOfView <= maximumFOV {
                                camera!.fieldOfView = maximumFOV
                            }
                            if camera!.fieldOfView >= minimumFOV {
                                camera!.fieldOfView = minimumFOV
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
                    let sunlight = self.aircraftScene.rootNode.childNode(withName: "sunlightNode", recursively: true)?.light

                    if self.sunlightSwitch == true {
                        sunlight!.intensity = 2000.0
                    } else {
                        sunlight!.intensity = 0.0
                    }
                }) {
                    Image(systemName: sunlightSwitch ? "lightbulb.fill" : "lightbulb")
                        .imageScale(.large)
                        .accessibility(label: Text("Light Switch"))
                        .padding()
                }
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

