//
//  SwiftUISceneKitUsingStateObjectVarsContentView.swift
//  SceneKitSwiftUIGesturesDemoApp
//
//  Created by James Hillhouse IV on 8/12/20.
//

import SwiftUI
import SceneKit



/*
extension SCNScene: ObservableObject {
    // Only here so I can use @StateObject on an instance of SCNScene.
}
*/



struct SwiftUISceneKitUsingStateObjectVarsContentView: View {
    @State private var sunlightSwitch       = true
    @State private var cameraSwitch         = true
    @State private var povName              = "distantCamera"
    @State private var magnification        = CGFloat(1.0)
    @State private var isDragging           = true
    //@StateObject private var aircraftScene  = SCNScene(named: "art.scnassets/ship.scn")!
    private var aircraftScene  = SCNScene(named: "art.scnassets/ship.scn")!

    // SceneView.Options for affecting the SceneView.
    //private var sceneViewCameraOption       = SceneView.Options.allowsCameraControl

    var drag: some Gesture {
        DragGesture()
            .onChanged { _ in self.isDragging = true }
            .onEnded { _ in self.isDragging = false }
    }


    var magnify: some Gesture {
        MagnificationGesture()
            .onChanged{ (value) in
                print("magnify = \(self.magnification)")
                self.magnification = value

                if self.magnification >= 1.01 {
                    self.magnification = 1.01
                }
                if self.magnification <= 0.99 {
                    self.magnification = 0.99
                }

                // If this capability is desired, SCNScene must be extended to conform to ObservableObject.
                let camera = self.aircraftScene.rootNode.childNode(withName: povName, recursively: true)?.camera

                let maximumFOV: CGFloat = 25 // Zoom-in.
                let minimumFOV: CGFloat = 90 // Zoom-out.

                camera!.fieldOfView /= magnification

                if camera!.fieldOfView <= maximumFOV {
                    camera!.fieldOfView = maximumFOV
                    self.magnification        = 1.0
                }
                if camera!.fieldOfView >= minimumFOV {
                    camera!.fieldOfView = minimumFOV
                    self.magnification        = 1.0
                }
            }
            .onEnded{ value in
                print("Ended pinch with value \(value)\n\n")
            }
    }


    var body: some View {
        ZStack {
            Color.black.edgesIgnoringSafeArea(.all)

            SceneView (
                scene: aircraftScene,
                pointOfView: aircraftScene.rootNode.childNode(withName: povName, recursively: true)
            )

            VStack() {
                Text("Hello, SceneKit!").multilineTextAlignment(.leading).padding()
                    .foregroundColor(Color.gray)

                    .font(.largeTitle)

                Text("Pinch to zoom.")
                    .foregroundColor(Color.gray)
                    .font(.title)

                /*
                Text("Magnification: \(magnify, specifier: "%.2f")")
                    .foregroundColor(Color.gray)
                    .font(.title3)
                    .padding()

                Text("FOV: \((self.aircraftScene.rootNode.childNode(withName: povName, recursively: true)?.camera!.fieldOfView)!, specifier: "%.2f")")
                    .foregroundColor(Color.gray)
                    .font(.title3)
                */

                Spacer(minLength: 300)

                HStack (spacing: 5) {
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

                    Button( action: {
                        withAnimation {
                            self.cameraSwitch.toggle()
                        }
                        if self.cameraSwitch == false {
                            povName = "shipCamera"
                        }
                        if self.cameraSwitch == true {
                            povName = "distantCamera"
                        }
                        print("\(povName)")
                    }) {
                        Image(systemName: cameraSwitch ? "video.fill" : "video")
                            .imageScale(.large)
                            .accessibility(label: Text("Camera Switch"))
                            .padding()
                    }
                }
            }
        }
        .gesture(magnify)
        .statusBar(hidden: true)
    }
}

struct SwiftUISceneKitUsingStateObjectVarsContentView_Previews: PreviewProvider {
    static var previews: some View {
        SwiftUISceneKitUsingStateObjectVarsContentView()
    }
}
