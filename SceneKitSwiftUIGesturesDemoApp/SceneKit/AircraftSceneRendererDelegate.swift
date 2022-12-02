//
//  AircraftSceneRendererDelegate.swift
//  SceneKitSwiftUIGesturesDemoApp
//
//  Created by James Hillhouse IV on 10/17/20.
//
import SceneKit




/**
 This is the delegate class for AircraftSceneKitScene model.
 
 It's purpose is to do some of the grunt work for an SCNScene. One important role is the function,
 
 `renderer(_:updateAtTime:)`
 
 that allows for changes of the Scene to be rendereed on a reglar time interval. For our purposes, this will allow for the physics-based motion
 say due to firing of the aircraft's RCS, to be displayed. Another would be to update the position after Runge-Kutta45 integration the state vector.
 */
class AircraftSceneRendererDelegate: NSObject, SCNSceneRendererDelegate, ObservableObject {
    
    var aircraftScene: SCNScene                     = AircraftSceneKitScene.shared
    var aircraftState                               = AircraftState.shared
    
    @Published var aircraftNode: SCNNode            = SCNNode()
    @Published var aircraftNodeString: String       = "shipNode"
    //@Published var otherNode: SCNNode
    
    //
    // Orientation properties
    //
    //var sceneQuaternion: simd_quatf?
    @Published var aircraftDeltaQuaternion: simd_quatf  = simd_quatf()
    @Published var aircraftOrientation: simd_quatf      = simd_quatf()
    @Published var aircraftEulerAngles: SIMD3<Float>    = simd_float3()
    var aircraftPreviousEulerAngles: SIMD3<Float>       = simd_float3()
    var aircraftCurrentEulerAngles: SIMD3<Float>        = simd_float3()
    @Published var deltaRollRate:Float                  = 0.0
    
    //
    // For switching cameras in the scene.
    //
    @Published var aircraftCurrentCamera: String        = AircraftCamera.distantCamera.rawValue
    @Published var aircraftCurrentCameraNode: SCNNode   = SCNNode()
    @Published var aircraftEngineNode: SCNNode          = SCNNode()
    
    // TODO: Prepare to DELETE
    @Published var nearPoint: SCNVector3    = SCNVector3()
    @Published var farPoint: SCNVector3     = SCNVector3()
    
    
    var changeCamera: Bool      = false
        
    var showsStatistics: Bool   = false
    
    
    //
    // Time, oh time...
    var _previousUpdateTime: TimeInterval   = 0.0
    var _deltaTime: TimeInterval            = 0.0
    
    
    
    override init() {
        print("AircraftSceneRendererDelegate override initialized")
        
        //
        // This call has been moved to the App protocol, SwiftUISceneKitCoreMotionDemoApp.swift.
        //
        //self.motionManager.setupDeviceMotion()
        
        //self.sceneQuaternion    = self.motionManager.motionQuaternion
        
        //self.aircraftScene      = AircraftSceneKitScene.shared
        
        self.aircraftNode       = AircraftSceneKitScene.shared.aircraftNode
        
        super.init()
        
        ///
        /// Just making sure here that the aircraftScene and aircraftNode are what I want them to be.
        ///
        
        print("AircraftSceneRendererDelegate \(#function) aircraftScene: \(aircraftScene)")
        print("AircraftSceneRendererDelegate \(#function) aircraftNode: \(String(describing: aircraftNode.name))")
    }
    
    
    
    func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval)
    {
        renderer.showsStatistics = showsStatistics
        
        
        // This is to ensure that the time is initialized properly for the simulator.
        if _previousUpdateTime == 0.0
        {
            _previousUpdateTime     = time
            
        }
        
        //print("\(time)")
        
        /*
         self.aircraftPreviousEulerAngles = self.aircraftEulerAngles
         print("\(#function) prevEuler.z: \(self.aircraftPreviousEulerAngles)")
         */
        
        
        if _deltaTime > 0.2 {
            //print("\nTime to calculate eulers and roll rates.")
            
            _previousUpdateTime         = time
            //print("_previousTime: \(_previousUpdateTime)")
                        
            
            _deltaTime  = 0.0
            //print("_deltaTime: \(_deltaTime)")
            
        } else {
            
            _deltaTime                  = time - _previousUpdateTime
            //print("_deltaTime: \(_deltaTime)")
            
        }
        
    }
    
    
    
    func setCameraName(name: String) {
        aircraftCurrentCamera = name
    }
    
    
    
    func setCameraNode(node: SCNNode) {
        aircraftCurrentCameraNode = node
    }
    
    
    
    func setAircraftNode(node: SCNNode) {
        aircraftNode = node
    }
    
    
    
    func updateOrientation() -> Void {
        self.aircraftNode.simdOrientation   = simd_mul(aircraftNode.simdOrientation, aircraftDeltaQuaternion).normalized
    }
    
    
    func radians2Degrees(_ number: Float) -> Float {
        return number * 180.0 / .pi
    }
    
}
