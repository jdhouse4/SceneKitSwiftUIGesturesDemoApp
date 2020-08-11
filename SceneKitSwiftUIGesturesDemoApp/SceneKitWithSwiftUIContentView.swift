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
    @State private var updating         = true
    @State private var magnify          = CGFloat(1.0)
    @State private var doneMagnifying   = false
    @State private var aircraftScene    = SCNScene(named: "art.scnassets/ship.scn")
    @State private var pointOfViewNode  = (SCNScene(named: "art.scnassets/ship.scn")?.rootNode.childNode(withName: "distantCameraNode", recursively: true))!

    @GestureState private var magnifyBy = CGFloat(1.0)

    var camera: SCNNode {
        //let node = self.pointOfViewNode
        let node = (SCNScene(named: "art.scnassets/ship.scn")?.rootNode.childNode(withName: "distantCameraNode", recursively: true))!

        let maximumFOV: CGFloat = 25 // This is what determines the farthest point into which to zoom.
        let minimumFOV: CGFloat = 90 // This is what determines the farthest point from which to zoom.

        node.camera?.fieldOfView /= magnifyBy

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
                pointOfView: aircraftScene?.rootNode.childNode(withName: "distantCameraNode", recursively: true),
                options: []
            )
            .background(Color.black)
            .gesture(MagnificationGesture()
                        .updating($magnifyBy) { (currentState, gestureState, transaction) in
                            gestureState = currentState

                            let maximumFOV: CGFloat = 25 // This is what determines the farthest point into which to zoom.
                            let minimumFOV: CGFloat = 90 // This is what determines the farthest point from which to zoom.


                            //self.pointOfViewNode.camera?.fieldOfView /= magnifyBy
                            self.aircraftScene!.rootNode.childNode(withName: "distantCameraNode", recursively: true)?.camera?.fieldOfView /= magnifyBy


                            /*
                            if self.pointOfViewNode.camera!.fieldOfView <= maximumFOV {
                                self.pointOfViewNode.camera!.fieldOfView = maximumFOV
                            }
                            if self.pointOfViewNode.camera!.fieldOfView >= minimumFOV {
                                self.pointOfViewNode.camera!.fieldOfView = minimumFOV
                            }
                            */

                            if (self.aircraftScene!.rootNode.childNode(withName: "distantCameraNode", recursively: true)?.camera!.fieldOfView)! <= maximumFOV {
                                self.aircraftScene!.rootNode.childNode(withName: "distantCameraNode", recursively: true)?.camera?.fieldOfView = maximumFOV
                            }
                            if (self.aircraftScene!.rootNode.childNode(withName: "distantCameraNode", recursively: true)?.camera!.fieldOfView)! >= minimumFOV {
                                self.aircraftScene!.rootNode.childNode(withName: "distantCameraNode", recursively: true)?.camera?.fieldOfView = minimumFOV
                            }

                            print("While .updating, magnifyBy = \(magnifyBy))")
                        }
                        .onChanged{ (value) in
                            print("magnify = \(self.magnify)")
                            self.magnify = value
                            /*
                            let maximumFOV: CGFloat = 25 // This is what determines the farthest point into which to zoom.
                            let minimumFOV: CGFloat = 90 // This is what determines the farthest point from which to zoom.

                            var fOV: CGFloat = self.pointOfViewNode.camera!.fieldOfView
                            fOV /= self.magnify

                            if fOV <= maximumFOV {
                                fOV = maximumFOV
                            }
                            if fOV >= minimumFOV {
                                fOV = minimumFOV
                            }
                            print("fieldOFView: \(String(describing: fOV))")

                            //self.pointOfViewNode.camera?.fieldOfView = fOV
                            */
                        }
                        .onEnded({ (_) in
                            self.aircraftScene!.rootNode.childNode(withName: "sunlightNode", recursively: true)?.light?.intensity = 0.0
                            self.aircraftScene!.rootNode.childNode(withName: "distantCameraNode", recursively: true)?.camera?.fieldOfView /= magnify
                            /*
                             Changing property of SCNNode does not change the node.
                             */
                            //self.pointOfViewNode.position = SCNVector3(20.0, 20.0, 20.0)
                            //self.pointOfViewNode = (SCNScene(named: "art.scnassets/ship.scn")?.rootNode.childNode(withName: "frontCameraNode", recursively: true))!
                        })
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



    func zoom(magnification: CGFloat) {
        let maximumFOV: CGFloat = 25 // This is what determines the farthest point into which to zoom.
        let minimumFOV: CGFloat = 90 // This is what determines the farthest point from which to zoom.

        pointOfViewNode.camera?.fieldOfView /= magnification

        if pointOfViewNode.camera!.fieldOfView <= maximumFOV {
            pointOfViewNode.camera!.fieldOfView = maximumFOV
        }
        if pointOfViewNode.camera!.fieldOfView >= minimumFOV {
            pointOfViewNode.camera!.fieldOfView = minimumFOV
        }
    }
}


struct SceneKitWithSwiftUIContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            SceneKitWithSwiftUIContentView()
        }
    }
}
