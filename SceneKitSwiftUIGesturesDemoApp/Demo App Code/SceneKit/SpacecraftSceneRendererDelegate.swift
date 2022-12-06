//
//  SpacecraftSceneRendererDelegate.swift
//  SceneKitSwiftUIGesturesDemoApp
//
//  Created by James Hillhouse IV on 10/17/20.
//
import SceneKit




/**
 This is the delegate class for SpacecraftSceneKitScene model.
 
 It's purpose is to do some of the grunt work for an SCNScene. One important role is the function,
 
 `renderer(_:updateAtTime:)`
 
 that allows for changes of the Scene to be rendereed on a reglar time interval. For our purposes, this will allow for the physics-based motion
 say due to firing of the spacecraft's RCS, to be displayed. Another would be to update the position after Runge-Kutta45 integration the state vector.
 */
class SpacecraftSceneRendererDelegate: NSObject, SCNSceneRendererDelegate, ObservableObject {
    
    var spacecraftScene: SCNScene               = SpacecraftSceneKitScene.shared
    var spacecraftState                         = SpacecraftState.shared
    
    @Published var spacecraftNode: SCNNode      = SCNNode()
    @Published var spacecraftNodeString: String = "Orion_CSM_Node"
    
    
    //
    // For switching cameras in the scene.
    //
    @Published var spacecraftCurrentCamera: String        = SpacecraftCamera.spacecraftChase360Camera.rawValue
    @Published var spacecraftCurrentCameraNode: SCNNode   = SCNNode()
    
    
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
        print("SpacecraftSceneRendererDelegate override initialized")
        
        self.spacecraftNode       = SpacecraftSceneKitScene.shared.spacecraftNode
        
        super.init()
        
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
    
    
    
    func setCurrentCameraName(name: String) {
        spacecraftCurrentCamera = name
    }
    
    
    
    func setCurrentCameraNode(node: SCNNode) {
        spacecraftCurrentCameraNode = node
    }
    
    
    
    func setSpacecraftNode(node: SCNNode) {
        spacecraftNode = node
    }
    
}
