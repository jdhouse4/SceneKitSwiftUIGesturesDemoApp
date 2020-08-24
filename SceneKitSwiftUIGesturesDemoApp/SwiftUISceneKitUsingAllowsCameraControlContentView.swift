//
//  SwiftUISceneKitUsingAllowsCameraControlContentView.swift
//  SceneKitSwiftUIGesturesDemoApp
//
//  Created by James Hillhouse IV on 8/19/20.
//

import SwiftUI
import SceneKit




struct SwiftUISceneKitUsingAllowsCameraControlContentView: View {
    @State private var sunlightSwitch       = true
    @State private var cameraSwitch         = true
    @State private var povName              = "distantCamera"

    private var aircraftScene               = SCNScene(named: "art.scnassets/ship.scn")!

    // SceneView.Options for affecting the SceneView.
    private var sceneViewCameraOption       = SceneView.Options.allowsCameraControl


    var body: some View {
        ZStack {
            Color.black.edgesIgnoringSafeArea(.all)

            SceneView (
                scene: aircraftScene,
                pointOfView: aircraftScene.rootNode.childNode(withName: povName, recursively: true)!,
                options: [sceneViewCameraOption]
            )
            .background(Color.black)


            VStack() {
                Text("Hello, SceneKit!").multilineTextAlignment(.leading).padding()
                    .foregroundColor(Color.gray)
                    .font(.largeTitle)

                Text("Using Allows Camera Control")
                    .foregroundColor(Color.gray)
                    .font(.title3)

                /*
                Text("Magnification: \(magnify, specifier: "%.2f")")
                    .foregroundColor(Color.gray)
                    .font(.title3)
                    .padding()

                Text("FOV: \((aircraftScene.rootNode.childNode(withName: povName, recursively: true)?.camera!.fieldOfView)!, specifier: "%.2f")")
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
        .statusBar(hidden: true)
    }
}

struct SwiftUISceneKitUsingAllowsCameraControlContentView_Previews: PreviewProvider {
    static var previews: some View {
        SwiftUISceneKitUsingAllowsCameraControlContentView()
    }
}
