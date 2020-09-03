//
//  SwiftUISceneKitUsingGesturesContentView.swift
//  SceneKitSwiftUIGesturesDemoApp
//
//  Created by James Hillhouse IV on 8/28/20.
//

import SwiftUI
import SceneKit




struct SwiftUISceneKitUsingGesturesContentView: View {

    /*
    enum ExclusiveState {
            case inactive
            case dragging(translation: CGSize)
            case magnifying(zoom: CGFloat)

            var translation: CGSize {
                switch self {
                case .dragging(let translation):
                    return translation
                default:
                    return CGSize.zero
                }
            }

            var zoom: CGFloat {
                switch self {
                    case .magnifying(let zoom):
                        return zoom
                    default:
                        return CGFloat(1.0)
                }
            }
        }
    */


    @State private var sunlightSwitch       = true
    @State private var cameraSwitch         = true
    @State private var povName              = "distantCamera"
    @State private var magnification        = CGFloat(1.0)
    @State private var isDragging           = false
    @State private var totalChangePivot     = SCNMatrix4Identity

    private var aircraftScene               = SCNScene(named: "art.scnassets/ship.scn")!
    //@GestureState var exclusiveState        = ExclusiveState.inactive

    // SceneView.Options for affecting the SceneView.
    //private var sceneViewCameraOption       = SceneView.Options.allowsCameraControl

    var drag: some Gesture {
        DragGesture()
            .onChanged { value in
                self.isDragging = true
                print("Dragging...")
                print("drag velocity = \(value)")

                let translation: CGSize = value.translation

                let x = Float(translation.width)
                let y = Float(-translation.height)

                let anglePan = sqrt(pow(x,2)+pow(y,2)) * (Float)(Double.pi) / 180.0

                var rotationVector = aircraftScene.rootNode.childNode(withName: "shipNode", recursively: true)!.rotation // SCNVector4()
                rotationVector.x = -y
                rotationVector.y = x
                rotationVector.z = 0
                rotationVector.w = anglePan

                aircraftScene.rootNode.childNode(withName: "shipNode", recursively: true)!.rotation = rotationVector
            }
            .onEnded { value in
                self.isDragging = false

                let currentPivot = aircraftScene.rootNode.childNode(withName: "shipNode", recursively: true)!.pivot
                let changePivot = SCNMatrix4Invert( aircraftScene.rootNode.childNode(withName: "shipNode", recursively: true)!.transform)

                totalChangePivot = SCNMatrix4Mult(changePivot, currentPivot)

                aircraftScene.rootNode.childNode(withName: "shipNode", recursively: true)!.pivot = SCNMatrix4Mult(changePivot, currentPivot)

                aircraftScene.rootNode.childNode(withName: "shipNode", recursively: true)!.transform = SCNMatrix4Identity
            }
    }



    var tap: some Gesture {
        TapGesture()
    }


    var magnify: some Gesture {
        MagnificationGesture()
            .onChanged{ (value) in
                print("magnify = \(self.magnification)")
                self.magnification = value

                if self.magnification >= 1.025 {
                    self.magnification = 1.025
                }
                if self.magnification <= 0.97 {
                    self.magnification = 0.97
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


    var exclusiveGesture: some Gesture {
        ExclusiveGesture(drag, magnify)
            /*.onChanged{ (value) in
                switch value {
                    case .first(let dragValue):
                        print("dragging")
                    case .second(let magnifyValue):
                        print("magnifyValue = \(magnifyValue)")
                }
            }
            .onEnded{ value in
                switch value {
                    case .first(let dragValue):
                        print("dragValue = \(dragValue)")
                    case .second(let magnifyValue):
                        print("magnifyValue = \(magnifyValue)")
                }
            }*/
    }


    var body: some View {
        ZStack {
            Color.black.edgesIgnoringSafeArea(.all)

            SceneView (
                scene: aircraftScene,
                pointOfView: aircraftScene.rootNode.childNode(withName: povName, recursively: true)
            )
            .gesture(exclusiveGesture)
            .onTapGesture(count: 2, perform: {
                /*
                let currentPivot    = aircraftScene.rootNode.childNode(withName: "shipNode", recursively: true)!.pivot
                print("currentPivot: \(currentPivot)")

                let changePivot     = SCNMatrix4Invert( totalChangePivot )
                print("changePivot = \(changePivot)")

                aircraftScene.rootNode.childNode(withName: "shipNode", recursively: true)!.pivot      = SCNMatrix4Mult(changePivot, currentPivot)

                totalChangePivot    = SCNMatrix4Identity
                */
                resetOrientation()
            })

            VStack() {
                Text("Hello, SceneKit!").multilineTextAlignment(.leading).padding()
                    .foregroundColor(Color.gray)

                    .font(.largeTitle)

                Text("With Gestures Too")
                    .foregroundColor(Color.gray)
                    .font(.title)

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


    private func resetOrientation() {
        let shipNode = aircraftScene.rootNode.childNode(withName: "shipNode", recursively: true)

        let currentPivot    = shipNode!.pivot

        //let currentPivot    = aircraftScene.rootNode.childNode(withName: "shipNode", recursively: true)!.pivot
        //print("currentPivot: \(currentPivot)")

        let changePivot     = SCNMatrix4Invert( totalChangePivot )
        //print("changePivot = \(changePivot)")

        shipNode!.pivot = SCNMatrix4Mult(changePivot, currentPivot)
        aircraftScene.rootNode.childNode(withName: "shipNode", recursively: true)!.pivot = SCNMatrix4Mult(changePivot, currentPivot)

        totalChangePivot    = SCNMatrix4Identity
    }
}

struct SwiftUISceneKitUsingGesturesContentView_Previews: PreviewProvider {
    static var previews: some View {
        SwiftUISceneKitUsingGesturesContentView()
    }
}
