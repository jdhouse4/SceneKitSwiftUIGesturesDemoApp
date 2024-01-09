//
//  SpacecraftCameraButton.swift
//  SceneKitSwiftUIGesturesDemoApp
//
//  Created by James Hillhouse IV on 12/01/22.
//
import SwiftUI




class SpacecraftCameraButton: ObservableObject {
    
    @Published var cameraButtonSwitch: Bool = false
    
    @Published var showCameraButtons: Bool  = false
    
    @Published var spacecraftExteriorCameraButtonPressed: Bool  = false
    
    @Published var spacecraftInteriorCameraButtonPressed: Bool  = false
    
}


