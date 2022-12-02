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
    @StateObject var aircraft                   = AircraftSceneKitScene.shared
    @StateObject var aircraftDelegate           = AircraftSceneRendererDelegate()
    @StateObject var aircraftCameraButton       = AircraftCameraButton()
    @StateObject var aircraftCameraState        = AircraftCameraState()
    @StateObject var aircraftAnalyticsButton    = AircraftAnalyticsButton()
    
    
    var body: some View {
        
        ZStack {
            
            AircraftSceneView()            
            
            VStack {
                
                HStack {
                    
                    AircraftCameraButtonsView()
                    
                    Spacer()
                    
                }
                
                Spacer()
                
                HStack {
                    
                    AircraftAnalyticsButtonView()
                    
                }
                .padding(.bottom, aircraftAnalyticsButton.analyticsSwitch ? 140 : 5)
                
            }
            //.background(Color.white.opacity(0.75))
            
                            
            
            Spacer()
                
            
            //.background(Color.blue)
            
        }
        .background(Color.black)
        .statusBar(hidden: true)
        
        .environmentObject(aircraft)
        .environmentObject(aircraftDelegate)
        .environmentObject(aircraftCameraButton)
        .environmentObject(aircraftCameraState)
        .environmentObject(aircraftAnalyticsButton)
    }
}



/*
 struct ContentView_Previews: PreviewProvider {
 static var previews: some View {
 ContentView()
 }
 }
 */
