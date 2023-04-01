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
                
                    if spacecraftDelegate.spacecraftCurrentCamera == SpacecraftCamera.spacecraftChase360Camera.rawValue {
                        
                        spacecraftCameraState.changeExteriorCameraOrientation(of: spacecraft.spacecraftCurrentCameraNode, with: value)
                        
                    }
                    
                    if spacecraftDelegate.spacecraftCurrentCamera == SpacecraftCamera.spacecraftCommanderCamera.rawValue {
                        
                        spacecraftCameraState.changeInteriorCameraOrientation(of: spacecraft.spacecraftCurrentCamera, with: value)
                        
                    }
                    
            }
            .onEnded { value in
                
                self.isDragging = false
                    
                    if spacecraftDelegate.spacecraftCurrentCamera == SpacecraftCamera.spacecraftChase360Camera.rawValue {
                        
                        // This sets Chase360Camera's euler angles to SpacecraftCameraState's @Published var to totalChase360CameraEulerAngles.
                        spacecraftCameraState.updateCameraOrientation(of: spacecraft.spacecraftCurrentCameraNode, with: value)
                        
                        // This tests whether the DragGesture was enough to cause inertia, and if so, sets chase360CameraEulersInertiallyDampen: Bool = true.
                        spacecraftCameraState.chase360CameraInertia(of: spacecraft.spacecraftCurrentCameraNode, with: value)
                        
                    }
                    
                    if spacecraftDelegate.spacecraftCurrentCamera == SpacecraftCamera.spacecraftCommanderCamera.rawValue {
                        
                        spacecraftCameraState.updateCameraOrientation(of: spacecraft.spacecraftCurrentCamera, with: value)
                        
                    }
                    
            }
    }
    
    
    // Need a @State Bool to allow toggling when .allowsCameraControl is an option.
    var magnify: some Gesture {
        MagnificationGesture()
            .onChanged{ (magnificationValue) in
                
                //
                // Only zoom in/out in the external cameras, at least for now.
                //
                if spacecraftDelegate.spacecraftCurrentCamera == SpacecraftCamera.spacecraftChase360Camera.rawValue {
                    
                    spacecraftCameraState.currentCameraMagnification = magnificationValue
                    //print("magnify = \(spacecraftCameraState.currentCameraMagnification)")
                    
                    spacecraftCameraState.changeCurrentCameraFOV(of: spacecraft.spacecraftCurrentCamera.camera!, value: spacecraftCameraState.currentCameraMagnification)
                    
                }
            }
            .onEnded{ magnificationValue in
                
                //print("Ended pinch with value \(magnificationValue)\n")
                
            }
    }
    
    
    // Don't forget to comment this is you are using .allowsCameraControl
    var exclusiveGesture: some Gesture {
        ExclusiveGesture(drag, magnify)
    }
    
    
    var body: some View {
        //ZStack {
        SceneView (
            scene: spacecraft.spacecraftScene,
            pointOfView: spacecraft.spacecraftCurrentCamera,
            delegate: spacecraftDelegate
        )
        .gesture(exclusiveGesture)
        .onTapGesture(count: 2, perform: {
            
            spacecraftCameraState.resetCurrentCameraFOV(of: spacecraft.spacecraftCurrentCamera.camera!, screenWdith: sizeClass!)
            
            if spacecraftDelegate.spacecraftCurrentCamera == SpacecraftCamera.spacecraftChase360Camera.rawValue {
                
                spacecraftCameraState.resetCameraOrientation(of: spacecraft.spacecraftCurrentCameraNode)
                
            }
            
            if spacecraftDelegate.spacecraftCurrentCamera == SpacecraftCamera.spacecraftCommanderCamera.rawValue {
                
                spacecraftCameraState.resetCameraOrientation(of: spacecraft.spacecraftCurrentCamera)
                
            }
            
        })
        
        //}
        .onAppear {
            spacecraftDelegate.spacecraftCurrentCameraNode = spacecraft.spacecraftChase360CameraNode
            spacecraftCameraState.resetCurrentCameraFOV(of: spacecraft.spacecraftCurrentCamera.camera!, screenWdith: sizeClass!)
        }
    }
}




struct SpacecraftSceneView_Previews: PreviewProvider {
    static var previews: some View {
        SpacecraftSceneView()
    }
}

