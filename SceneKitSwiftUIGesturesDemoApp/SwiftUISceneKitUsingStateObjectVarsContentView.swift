//
//  SwiftUISceneKitUsingStateObjectVarsContentView.swift
//  SceneKitSwiftUIGesturesDemoApp
//
//  Created by James Hillhouse IV on 8/12/20.
//

import SwiftUI
import SceneKit




extension SCNScene: ObservableObject {
    // Nothing here for now.
}




struct SwiftUISceneKitUsingStateObjectVarsContentView: View {
    @State private var sunlightSwitch       = true
    @State private var cameraSwitch         = true
    @State private var povName              = "distantCameraNode"
    @State private var magnify              = CGFloat(1.0)
    @StateObject private var aircraftScene  = SCNScene(named: "art.scnassets/ship.scn")!

    private var aircraftPOVNode             = SCNScene(named: "art.scnassets/ship.scn")!.rootNode
    private var sceneViewCameraOption       = SceneView.Options.allowsCameraControl



    var body: some View {
        ZStack {
            Color.black.edgesIgnoringSafeArea(.all)

            SceneView (
                scene: aircraftScene,
                pointOfView: aircraftPOVNode.childNode(withName: povName, recursively: true) /*,
                options: [sceneViewCameraOption]*/
            )
            .background(Color.black)

            .gesture(MagnificationGesture()
                        .onChanged{ (value) in
                            print("magnify = \(self.magnify)")
                            self.magnify = value

                            if self.magnify >= 1.01 {
                                self.magnify = 1.01
                            }
                            if self.magnify <= 0.99 {
                                self.magnify = 0.99
                            }

                            // If this capability is desired, aircraftScene must be extended to conform to ObservableObject.
                            let camera = self.aircraftScene.rootNode.childNode(withName: povName, recursively: true)?.camera

                            let maximumFOV: CGFloat = 25 // Zoom-in.
                            let minimumFOV: CGFloat = 90 // Zoom-out.

                            camera!.fieldOfView /= magnify

                            if camera!.fieldOfView <= maximumFOV {
                                camera!.fieldOfView = maximumFOV
                                self.magnify        = 1.0
                            }
                            if camera!.fieldOfView >= minimumFOV {
                                camera!.fieldOfView = minimumFOV
                                self.magnify        = 1.0
                            }
                        }
                        .onEnded{ _ in
                            print("Ended pinch\n\n")
                        }
            )

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

                Text("FOV: \((self.aircraftScene.rootNode.childNode(withName: "distantCameraNode", recursively: true)?.camera!.fieldOfView)!, specifier: "%.2f")")
                    .foregroundColor(Color.gray)
                    .font(.title3)


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
                            povName = "shipCameraNode"
                        }
                        if self.cameraSwitch == true {
                            povName = "distantCameraNode"
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
        .statusBar(hidden: true)
    }
}

struct SwiftUISceneKitUsingStateObjectVarsContentView_Previews: PreviewProvider {
    static var previews: some View {
        SwiftUISceneKitUsingStateObjectVarsContentView()
    }
}
