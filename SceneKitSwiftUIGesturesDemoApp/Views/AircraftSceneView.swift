//
//  AircraftSceneView.swift
//  SwiftUISceneKitCoreMotionDemo
//
//  Created by James Hillhouse IV on 3/30/21.
//

import SwiftUI
import SceneKit




/*
 This view contains all of the code for the SceneView() for the primary scene.
 */
struct AircraftSceneView: View {
    @State private var isDragging = false

    @EnvironmentObject var aircraft: AircraftSceneKitScene
    @EnvironmentObject var aircraftCameraState: AircraftCameraState

    
    /// This contains the function
    /// `renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval)`
    /// that is used to animate the model.
    @EnvironmentObject var aircraftDelegate: AircraftSceneRendererDelegate


    // SceneView.Options for affecting the SceneView.
    // Uncomment if you would like to have Apple do all of the camera control
    //private var sceneViewCameraOptions      = SceneView.Options.allowsCameraControl
    //private var sceneViewRenderContinuously = SceneView.Options.rendersContinuously


    // Don't forget to comment that you are using .allowsCameraControl
    var drag: some Gesture {
        DragGesture()
            .onChanged { value in
                self.isDragging = true
                                    
                if aircraftDelegate.aircraftCurrentCamera == AircraftCamera.distantCamera.rawValue {
                    aircraftCameraState.changeCameraOrientation(of: aircraft.aircraftCurrentCameraNode, with: value.translation)
                }
            }
            .onEnded { value in
                
                self.isDragging = false
                
                    if aircraftDelegate.aircraftCurrentCamera == AircraftCamera.distantCamera.rawValue {
                        aircraftCameraState.updateCameraOrientation(of: aircraft.aircraftCurrentCameraNode)
                    }
            }
    }


    var body: some View {
        ZStack {
            SceneView (
                scene: aircraft.aircraftScene,
                pointOfView: aircraft.aircraftCurrentCamera,
                delegate: aircraftDelegate
            )
            .gesture(drag)
            .onTapGesture(count: 2, perform: {
                
                if aircraftDelegate.aircraftCurrentCamera == AircraftCamera.distantCamera.rawValue {
                    aircraftCameraState.resetCameraOrientation(of: aircraft.aircraftCurrentCameraNode)
                }
                
            })

        }
        .onAppear {
            
            aircraftDelegate.aircraftCurrentCameraNode = aircraft.aircraftDistantCameraNode
            
        }
    }
}




struct AircraftSceneView_Previews: PreviewProvider {
    static var previews: some View {
        AircraftSceneView()
    }
}

