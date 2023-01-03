//
//  SpacecraftFDAISceneView.swift
//  SceneKitSwiftUIGesturesDemoApp
//
//  Created by James Hillhouse IV on 1/2/23.
//

import SwiftUI

struct SpacecraftFDAISceneView: View {
    @EnvironmentObject var spacecraft: SpacecraftFDAISceneKitScene
    
    
    /// This contains the function
    /// `renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval)`
    /// that is used to animate the model.
    @EnvironmentObject var spacecraftDelegate: SpacecraftFDAISceneRendererDelegate
    
    
    
    var body: some View {
        //ZStack {
        SceneView (
            scene: spacecraft.spacecraftScene,
            pointOfView: spacecraft.spacecraftCurrentCamera,
            /*options: [sceneViewCameraOptions],*/
            delegate: spacecraftDelegate
        )
        .onAppear {
            
            spacecraftDelegate.spacecraftCurrentCameraNode = spacecraft.spacecraftDistantCameraNode
            
        }
    }}




struct SpacecraftFDAISceneView_Previews: PreviewProvider {
    static var previews: some View {
        SpacecraftFDAISceneView()
    }
}
