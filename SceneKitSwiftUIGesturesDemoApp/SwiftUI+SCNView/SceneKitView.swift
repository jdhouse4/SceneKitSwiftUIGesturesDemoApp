//
//  SceneKitView.swift
//  BuzzWithSwiftUI
//
//  Created by James Hillhouse IV on 9/2/19.
//  Copyright © 2019 PortableFrontier. All rights reserved.
//

import SwiftUI
import SceneKit
import SpriteKit




struct SceneKitView: UIViewRepresentable {


    func makeCoordinator() -> Coordinator {
        return Coordinator(self, sunlightSwitch: $sunlightSwitch)
    }


    //@Binding var lightSwitch: Bool
    @Binding var sunlightSwitch: Bool
    //@Binding var bodyCameraSwitch: Bool


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
        guard let sunLight = scnView.scene!.rootNode.childNode(withName: "sunlightNode", recursively: true) else { return }

        switch sunlightSwitch {
        case 0:
            sunLight.light?.type = .directional
            lightTextNode.text = sunLight.light?.type.rawValue
        case 1:
            sunLight.light?.type = .spot
            lightTextNode.text = sunLight.light?.type.rawValue
        case 2:
            sunLight.light?.type = .omni
            lightTextNode.text = sunLight.light?.type.rawValue
        case 3:
            sunLight.light?.type = .ambient
            lightTextNode.text = sunLight.light?.type.rawValue
        default:
            sunLight.light?.type = .directional
            lightTextNode.text = sunLight.light?.type.rawValue
        }
    }


    /*
    func toggleBuzzBodyCamera(_ scnView: SCNView) {
        if bodyCameraSwitch == true {
            scnView.pointOfView = scnView.scene?.rootNode.childNode(withName: "BodyCamera", recursively: true)
        } else {
            //scnView.pointOfView = scnView.scene?.rootNode.childNode(withName: "Camera", recursively: true)
            scnView.pointOfView = scnView.scene?.rootNode.childNode(withName: "WorldCamera", recursively: true)
        }
    }
    */



    
    class Coordinator: NSObject {

        //@Binding var lightSwitch: Bool
        @Binding var sunlightSwitch: Int

        var scnView: SceneKitView


        init(_ scnView: SceneKitView, sunlightSwitch: Binding<Int>) {
            self.scnView = scnView
            self._sunlightSwitch = sunlightSwitch
        }

        /*
         init(_ scnView: SceneKitView, lightSwitch: Binding<Bool>, sunlightSwitch: Binding<Int>) {
             self.scnView = scnView
             //self._lightSwitch = lightSwitch
             self._sunlightSwitch = sunlightSwitch
         }
         */


        // Magnification Gesture
        @objc func pinchGesture(gestureReconizer: UIPinchGestureRecognizer) {

            guard let aircraftNode = self.scnView.scene.rootNode.childNode(withName: "ship", recursively: true) else{
                print("There's no Aircraft Node!")
                return
            }

            let scale = gestureReconizer.velocity

            let maximumFOV:CGFloat = 25 //This is what determines the farthest point you can zoom in to
            let minimumFOV:CGFloat = 90 //This is what determines the farthest point you can zoom out to

            switch gestureReconizer.state {
            case .began:
                break
            case .changed:
                aircraftNode.camera?.fieldOfView -= CGFloat(scale)
                if aircraftNode.camera!.fieldOfView <= maximumFOV {
                    aircraftNode.camera!.fieldOfView = maximumFOV
                }
                if aircraftNode.camera!.fieldOfView >= minimumFOV {
                    aircraftNode.camera!.fieldOfView = minimumFOV
                }
                break
            default: break
            }
        }


        /*
        // Double-Tap Action
        @objc func triggerDoubleTapAction(gestureReconizer: UITapGestureRecognizer) {

            guard let buzzNode = self.scnView.scene.rootNode.childNode(withName: "Buzz", recursively: true) else{
                print("There's no Buzz Node!")
                return
            }

            let currentPivot = buzzNode.pivot
            //print("Buzz pivot: \(buzzNode.pivot)")

            let changePivot = SCNMatrix4Invert( totalChangePivot )

            buzzNode.pivot = SCNMatrix4Mult(changePivot, currentPivot)
        }
        */


        /*
        // Pan Action
        var initialCenter = CGPoint()  // The initial center point of the view.

        @objc func panPiece(_ gestureRecognizer : UIPanGestureRecognizer) {
            guard gestureRecognizer.view != nil else {return}

            let piece = gestureRecognizer.view!

            // Get the changes in the X and Y directions relative to the superview's coordinate space.
            let translation = gestureRecognizer.translation(in: piece.superview)

            if gestureRecognizer.state == .began {

                // Save the view's original position.
              self.initialCenter = piece.center
            }

            // Update the position for the .began, .changed, and .ended states
            if gestureRecognizer.state != .cancelled {
              // Add the X and Y translation to the view's original position.
              let newCenter = CGPoint(x: initialCenter.x + translation.x, y: initialCenter.y + translation.y)
              piece.center = newCenter
            }
           else {
              // On cancellation, return the piece to its original location.
              piece.center = initialCenter
           }
        }
        */


        /*
        var totalChangePivot = SCNMatrix4Identity

        @objc func panGesture(_ gestureRecognize: UIPanGestureRecognizer){
            print("SceneKitView Coordinator panGesture")

            let translation = gestureRecognize.translation(in: gestureRecognize.view!)

            let x = Float(translation.x)
            let y = Float(-translation.y)

            let anglePan = sqrt(pow(x,2)+pow(y,2))*(Float)(Double.pi)/180.0

            guard let buzzNode = self.scnView.scene.rootNode.childNode(withName: "Buzz", recursively: true) else{
                print("There's no Buzz Node!")
                return
            }

            var rotationVector = buzzNode.rotation // SCNVector4()
            rotationVector.x = -y
            rotationVector.y = x
            rotationVector.z = 0
            rotationVector.w = anglePan

            buzzNode.rotation = rotationVector

            if(gestureRecognize.state == UIGestureRecognizer.State.ended) {

                let currentPivot = buzzNode.pivot
                let changePivot = SCNMatrix4Invert( buzzNode.transform)

                totalChangePivot = SCNMatrix4Mult(changePivot, currentPivot)
                buzzNode.pivot = SCNMatrix4Mult(changePivot, currentPivot)

                buzzNode.transform = SCNMatrix4Identity
            }
        }
        */
    }
}
