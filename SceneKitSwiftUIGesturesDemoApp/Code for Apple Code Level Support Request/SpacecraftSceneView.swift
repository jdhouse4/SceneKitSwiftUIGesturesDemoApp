//
//  SpacecraftSceneView.swift
//  ScenKitSwiftUIGestureDemoApp
//
//  Created by James Hillhouse IV on 12/01/22.
//

import SwiftUI
import SceneKit




/*
 This view contains all of the code for the SceneView() for the primary scene.
 */
struct SpacecraftSceneView: View {
    
    // This is needed for the camera zoom and fieldOfView
    @Environment(\.horizontalSizeClass) var sizeClass
    
    @State private var isDragging = false
    
    @EnvironmentObject var spacecraft: SpacecraftSceneKitScene
    @EnvironmentObject var spacecraftCameraState: SpacecraftCameraState
    
    
    /// This contains the function
    /// `renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval)`
    /// that is used to animate the model.
    @EnvironmentObject var spacecraftDelegate: SpacecraftSceneRendererDelegate
    
    
    // MARK: SceneView.Options for affecting the SceneView.
    // Uncomment if you would like to have Apple do all of the camera control
    //private var sceneViewCameraOptions      = SceneView.Options.allowsCameraControl
    //private var sceneViewRenderContinuously = SceneView.Options.rendersContinuously
    
    
    // Need a @State Bool to allow toggling when .allowsCameraControl is an option.
    var drag: some Gesture {
        DragGesture()
            .onChanged { value in
                self.isDragging = true
                
                //let dragValue = value.startLocation
                
                if spacecraftDelegate.spacecraftCurrentCamera.name == SpacecraftCamera.spacecraftChase360Camera.rawValue {
                    
                    // This uses the spacecraft camera's node to change orientation, which is located at the point of the spacecraft.
                    // In this way, we pivot, or reorient, around the spacecraft. Otherwise, as with the code below, the orientation would
                    // be about the camera's node, which is the action we get for the interior camera.
                    spacecraftCameraState.changeExteriorCameraOrientation(of: spacecraft.spacecraftCurrentCameraNode, with: value)
                    
                }
                
                if spacecraftDelegate.spacecraftCurrentCamera.name == SpacecraftCamera.spacecraftCommanderCamera.rawValue {
                    
                    spacecraftCameraState.changeInteriorCameraOrientation(of: spacecraft.spacecraftCurrentCamera, with: value)
                    
                }
                    
            }
            .onEnded { value in
                
                self.isDragging = false
                
                
                if spacecraftDelegate.spacecraftCurrentCamera.name == SpacecraftCamera.spacecraftChase360Camera.rawValue {
                    
                    // This sets Chase360Camera's euler angles to SpacecraftCameraState's @Published var to totalChase360CameraEulerAngles.
                    spacecraftCameraState.updateCameraOrientation(of: spacecraft.spacecraftCurrentCameraNode, with: value)
                    
                    // This tests whether the DragGesture was enough to cause inertia, and if so, sets chase360CameraEulersInertiallyDampen: Bool = true.
                    spacecraftCameraState.chase360CameraInertia(of: spacecraft.spacecraftCurrentCamera, with: value)
                    
                }
                
                if spacecraftDelegate.spacecraftCurrentCamera.name == SpacecraftCamera.spacecraftCommanderCamera.rawValue {
                    
                    spacecraftCameraState.updateCameraOrientation(of: spacecraft.spacecraftCurrentCamera, with: value)
                    
                }
                
            }
    }

    
    // Need a @State Bool to allow toggling when .allowsCameraControl is an option.
    var magnify: some Gesture {
        MagnificationGesture()
            .onChanged{ (distanceValue) in
                
                //
                // Only zoom in/out in the external cameras, at least for now.
                //
                if spacecraftDelegate.spacecraftCurrentCamera.name == SpacecraftCamera.spacecraftChase360Camera.rawValue {
                    
                    print("\(#function) distanceValue: \(distanceValue)")
                    
                    // This function tests the above value and, if out of bounds, sets it within, otherwise adjusting the value.
                    spacecraftCameraState.changeCurrentCameraDistance(of: spacecraft.spacecraftCurrentCamera, value: Float(distanceValue))

                }
            }
            .onEnded{ distanceValue in
                
                //print("Ended pinch with value \(magnificationValue)\n")
                
            }
    }
    
    
    // Don't forget to comment this is you are using .allowsCameraControl
    var exclusiveGesture: some Gesture {
        ExclusiveGesture(drag, magnify)
    }
    
    
    var body: some View {

        SceneView (
            scene: spacecraft.spacecraftScene,
            pointOfView: spacecraft.spacecraftCurrentCamera,
            delegate: spacecraftDelegate
        )
        .gesture(exclusiveGesture)
        .onTapGesture(count: 2, perform: {
            
            spacecraftCameraState.resetCurrentCameraDistance(of: spacecraft.spacecraftCurrentCamera, screenWdith: sizeClass!)

            if spacecraftDelegate.spacecraftCurrentCamera.name == SpacecraftCamera.spacecraftChase360Camera.rawValue {
                
                spacecraftCameraState.resetCameraOrientation(of: spacecraft.spacecraftCurrentCameraNode)
                
            }
            
            if spacecraftDelegate.spacecraftCurrentCamera.name == SpacecraftCamera.spacecraftCommanderCamera.rawValue {
                
                spacecraftCameraState.resetCameraOrientation(of: spacecraft.spacecraftCurrentCamera)
                
            }
            
        })
        
        .onAppear {
            spacecraftDelegate.spacecraftCurrentCameraNode = spacecraft.spacecraftChase360CameraNode
            spacecraftCameraState.resetCurrentCameraDistance(of: spacecraft.spacecraftCurrentCamera, screenWdith: sizeClass!)
        }
    }
}




struct SpacecraftSceneView_Previews: PreviewProvider {
    static var previews: some View {
        SpacecraftSceneView()
    }
}

