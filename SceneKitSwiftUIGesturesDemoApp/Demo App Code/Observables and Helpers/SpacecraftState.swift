//
//  SpacecraftState.swift
//  SceneKitSwiftUIGesturesDemoApp
//
//  Created by James Hillhouse IV on 12/01/22.
//

import Foundation
import SceneKit
import simd


@MainActor
class SpacecraftState: ObservableObject {
    
    static let shared = SpacecraftState()
    
    @Published var spacecraftLoaded: Bool   = false
    
    ///
    /// The scene for the spacecraft scn
    //@Published var spacecraftScene: SCNScene         = SpacecraftSceneKitScene.shared
    
    ///
    /// Spacecraft Orientation
    @Published var spacecraftOrientation: simd_quatf  // Do this as a computed property
    
    var spacecraftRollAngle: Float = 0.0
    
    private init() {
        print("SpacecraftState \(#function)")
        self.spacecraftOrientation        = simd_quatf(ix: 0.0, iy: 0.0, iz: 0.0, r: 1.0)

    }
    
}
