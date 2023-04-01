//
//  ContentView.swift
//  SceneKitSwiftUIGesturesDemoApp
//
//  Created by James Hillhouse IV on 12/01/2022.
//

import SwiftUI
import SceneKit




struct ContentView: View {
    
    
    //
    // @StateObject is a property wrapper type that instantiates an object conforming to ObservableObject.
    //
    @StateObject var spacecraft                 = SpacecraftSceneKitScene.shared
    @StateObject var spacecraftDelegate         = SpacecraftSceneRendererDelegate()
    @StateObject var spacecraftState            = SpacecraftState.shared
    @StateObject var spacecraftCameraState      = SpacecraftCameraState.shared
    @StateObject var spacecraftCameraButton     = SpacecraftCameraButton()
    @StateObject var spacecraftAnalyticsButton  = SpacecraftAnalyticsButton()
    
    
    var body: some View {
        
        ZStack {
            
            SpacecraftSceneView()            
            
            VStack {
                
                HStack {
                    
                    SpacecraftCameraButtonsView()
                    
                    Spacer()
                    
                }
                
                Spacer()
                
                HStack {
                    
                    SpacecraftAnalyticsButtonView()
                    
                }
                .padding(.bottom, spacecraftAnalyticsButton.analyticsSwitch ? 140 : 5)
                
            }
                        
            Spacer()
                
        }
        .background(Color.black)
        .statusBar(hidden: true)
        
        
        .environmentObject(spacecraft)
        .environmentObject(spacecraftDelegate)
        .environmentObject(spacecraftState)
        .environmentObject(spacecraftCameraState)
        .environmentObject(spacecraftCameraButton)
        .environmentObject(spacecraftAnalyticsButton)
    }
}



/*
 struct ContentView_Previews: PreviewProvider {
 static var previews: some View {
 ContentView()
 }
 }
 */
