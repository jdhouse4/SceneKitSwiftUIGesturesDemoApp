//
//  SpacecraftCameraButton.swift
//  SwiftUISceneKitCoreMotionDemo
//
//  Created by James Hillhouse IV on 5/25/21.
//
import SwiftUI




class SpacecraftCameraButton: ObservableObject {

    @Published var cameraButtonSwitch: Bool         = false
    
    @Published var showCameraButtons: Bool          = false
    
    @Published var distantCameraButtonPressed: Bool = false

}


