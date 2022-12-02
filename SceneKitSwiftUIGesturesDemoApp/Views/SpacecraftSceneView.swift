//
//  SpacecraftSceneView.swift
//  SwiftUISceneKitCoreMotionDemo
//
//  Created by James Hillhouse IV on 3/30/21.
//

import SwiftUI
import SceneKit




/*
 This view contains all of the code for the SceneView() for the primary scene.
 */
struct SpacecraftSceneView: View {
    @State private var isDragging = false

    @EnvironmentObject var aircraft: SpacecraftSceneKitScene
    @EnvironmentObject var aircraftCameraState: SpacecraftCameraState

    
    /// This contains the function
    /// `renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval)`
    /// that is used to animate the model.
    @EnvironmentObject var aircraftDelegate: SpacecraftSceneRendererDelegate


    // SceneView.Options for affecting the SceneView.
    // Uncomment if you would like to have Apple do all of the camera control
    //private var sceneViewCameraOptions      = SceneView.Options.allowsCameraControl
    //private var sceneViewRenderContinuously = SceneView.Options.rendersContinuously


    // Don't forget to comment that you are using .allowsCameraControl
    var drag: some Gesture {
        DragGesture()
            .onChanged { value in
                self.isDragging = true
                                    
                if aircraftDelegate.spacecraftCurrentCamera == SpacecraftCamera.distantCamera.rawValue {
                    aircraftCameraState.changeCameraOrientation(of: aircraft.spacecraftCurrentCameraNode, with: value.translation)
                }
            }
            .onEnded { value in
                
                self.isDragging = false
                
                    if aircraftDelegate.spacecraftCurrentCamera == SpacecraftCamera.distantCamera.rawValue {
                        aircraftCameraState.updateCameraOrientation(of: aircraft.spacecraftCurrentCameraNode)
                    }
            }
    }


    var body: some View {
        ZStack {
            SceneView (
                scene: aircraft.spacecraftScene,
                pointOfView: aircraft.spacecraftCurrentCamera,
                delegate: aircraftDelegate
            )
            .gesture(drag)
            .onTapGesture(count: 2, perform: {
                
                if aircraftDelegate.spacecraftCurrentCamera == SpacecraftCamera.distantCamera.rawValue {
                    aircraftCameraState.resetCameraOrientation(of: aircraft.spacecraftCurrentCameraNode)
                }
                
            })

        }
        .onAppear {
            
            aircraftDelegate.spacecraftCurrentCameraNode = aircraft.spacecraftDistantCameraNode
            
        }
    }
}




struct AircraftSceneView_Previews: PreviewProvider {
    static var previews: some View {
        SpacecraftSceneView()
    }
}

