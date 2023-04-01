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
    
    /*
    /// This is a place where the position, velocity, orientation, delta-orientation, and translation data is stored and managed.
    let deltaOrientationAngle: Float    = 0.00415 * .pi / 180.0 // This results in a 0.25°/s attitude change.
    
    
    // MARK: These orientation impulse UInt counters keep track of the number of impulses.
    // -X is an impulse in the negative direction and +X is in the positive.
    var yawImpulseCounter: Int      = 0
    var rollImpulseCounter: Int     = 0
    var pitchImpulseCounter: Int    = 0
    */
    
    ///
    /// The scene for the spacecraft scn
    //@Published var spacecraftScene: SCNScene         = SpacecraftSceneKitScene.shared
    
    ///
    /// The scene node for the spacecraft itself
    //@Published var spacecraftNode: SCNNode
    
    
    /// Spacecraft Position
    ///
    /// Spacecraft Velocity
    ///
    /// Spacecraft Orientation
    @Published var spacecraftOrientation: simd_quatf  // Do this as a computed property
    
    //@Published var spacecraftDeltaQuaternion: simd_quatf
    
    //@Published var spacecraftEulerAngles: SIMD3<Float>
    
    var spacecraftRollAngle: Float = 0.0
    
    private init() {
        print("SpacecraftState \(#function)")
        self.spacecraftOrientation        = simd_quatf(ix: 0.0, iy: 0.0, iz: 0.0, r: 1.0)
        
        //self.spacecraftDeltaQuaternion    = simd_quatf(ix: 0.0, iy: 0.0, iz: 0.0, r: 1.0)
        
        //self.spacecraftNode               = SpacecraftSceneKitScene.shared.spacecraftNode
        
        //self.spacecraftEulerAngles        = simd_float3(x: 0.0, y: 0.0, z: 0.0)
    }
    
    
    
    func degrees2Radians(_ number: Float) -> Float {
        return number * .pi / 180.0
    }
    
    
    
    func radians2Degrees(_ number: Float) -> Float {
        return number * 180.0 / .pi
    }
    
    
    
    func resetOrientation() -> simd_quatf {
        return simd_quatf(angle: 0, axis: simd_float3(x: 0.0, y: 0.0, z: 0.0))
    }
}
