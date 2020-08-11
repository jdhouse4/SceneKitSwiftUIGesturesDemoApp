//
//  SceneKitView.swift
//  BuzzWithSwiftUI
//
//  Created by James Hillhouse IV on 9/2/19.
//  Copyright © 2019 PortableFrontier. All rights reserved.
//

import SwiftUI
import SceneKit




struct SceneKitView: UIViewRepresentable {


    func makeCoordinator() -> Coordinator {
        return Coordinator(self, sunlightSwitch: $sunlightSwitch)
    }


    @Binding var sunlightSwitch: Bool


    // SceneKit Properties
    let scene = SCNScene(named: "art.scnassets/ship.scn")!



    func makeUIView(context: Context) -> SCNView {
        print("SceneKitView makeUIView")

        // retrieve the SCNView
        let scnView = SCNView()

        // configure the view
        scnView.backgroundColor = UIColor.black

        // WorldCamera from scn file.
        scnView.pointOfView = scene.rootNode.childNode(withName: "distantCamera", recursively: true)

        // Magnification Gesture to zoom-in and zoom-out.
        let magnificationGestureRecognizer = UIPinchGestureRecognizer(target: context.coordinator, action: #selector(Coordinator.pinchGesture(gestureReconizer:)))
        scnView.addGestureRecognizer(magnificationGestureRecognizer)

        return scnView
    }



    func updateUIView(_ scnView: SCNView, context: Context) {
        print("SceneKitView updateUIView(_:SCNView, Context)")
        
        // set the scene to the view
        scnView.scene = scene

        scnView.backgroundColor = UIColor.black

        scnView.allowsCameraControl = false

        // show statistics such as fps and timing information
        scnView.showsStatistics = false

        toggleSunlight(scnView)
    }


    
    func toggleSunlight(_ scnView: SCNView) {
        guard let sunlightNode = scnView.scene!.rootNode.childNode(withName: "sunlightNode", recursively: true) else { return }

        if self.sunlightSwitch == true {
            sunlightNode.light?.intensity      = 2000.0
        } else {
            sunlightNode.light?.intensity      = 0
        }
    }



    
    class Coordinator: NSObject {

        @Binding var sunlightSwitch: Bool

        var scnView: SceneKitView

        init(_ scnView: SceneKitView, sunlightSwitch: Binding<Bool>) {
            self.scnView = scnView
            self._sunlightSwitch = sunlightSwitch
        }



        // Magnification Gesture
        @objc func pinchGesture(gestureReconizer: UIPinchGestureRecognizer) {

            guard let aircraftNode = self.scnView.scene.rootNode.childNode(withName: "ship", recursively: true) else{
                print("There's no Aircraft Node!")
                return
            }

            let aircraftCameraNode = aircraftNode.childNode(withName: "distantCameraNode", recursively: true)

            let velocity = gestureReconizer.velocity // scale doesn't work
            print("pinch gesture velocity = \(velocity)")

            let maximumFOV:CGFloat = 25 //This is what determines the farthest point you can zoom in to
            let minimumFOV:CGFloat = 90 //This is what determines the farthest point you can zoom out to

            switch gestureReconizer.state {
            case .began:
                break
            case .changed:
                aircraftCameraNode!.camera?.fieldOfView -= CGFloat(velocity)

                if aircraftCameraNode!.camera!.fieldOfView <= maximumFOV {
                    aircraftCameraNode!.camera!.fieldOfView = maximumFOV
                }
                if aircraftCameraNode!.camera!.fieldOfView >= minimumFOV {
                    aircraftCameraNode!.camera!.fieldOfView = minimumFOV
                }
                break
            default: break
            }
        }
    }
}
