//
//  SpacecraftSceneRendererDelegate.swift
//  SceneKitSwiftUIGesturesDemoApp
//
//  Created by James Hillhouse IV on 12/01/22.
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
    
    
    var spacecraftSceneNode: SCNNode            = SCNNode()
    var spacecraftSceneNodeString: String       = "Orion_CSM_Scene_Node"
    
    @Published var spacecraftNode: SCNNode      = SCNNode()
    @Published var spacecraftNodeString: String = "Orion_CSM_Node"
    
    
    //
    // For switching cameras in the scene.
    //
    @Published var spacecraftCurrentCamera: String        = SpacecraftCamera.spacecraftChase360Camera.rawValue
    @Published var spacecraftCurrentCameraNode: SCNNode   = SCNNode()
    
    
    // TODO: Prepare to DELETE
    //@Published var nearPoint: SCNVector3    = SCNVector3()
    //@Published var farPoint: SCNVector3     = SCNVector3()
    
    
    var changeCamera: Bool      = false
    
    var showsStatistics: Bool   = false
    
    
    //
    // Time, oh time...
    var _previousUpdateTime: TimeInterval   = 0.0
    var _deltaTime: TimeInterval            = 0.0
    var inertialElapsedTime: TimeInterval   = 0.0

    
    
    override init() {
        print("SpacecraftSceneRendererDelegate override initialized")
        
        self.spacecraftSceneNode    = SpacecraftSceneKitScene.shared.spacecraftSceneNode
        
        super.init()
        
        ///
        /// Just making sure here that the spacecraftScene and spacecraftNode are what I want them to be.
        ///
        print("SpacecraftSceneRendererDelegate \(#function) spacecraftScene: \(spacecraftScene)")
        print("SpacecraftSceneRendererDelegate \(#function) spacecraftSceneNode: \(String(describing: spacecraftSceneNode.name))")
        print("SpacecraftSceneRendererDelegate \(#function) spacecraftNode: \(String(describing: spacecraftNode.name))")
        
    }
    
    
    @MainActor
    func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval)
    {
        renderer.showsStatistics = showsStatistics
        
        
        // This is to ensure that the time is initialized properly for the simulator.
        if _previousUpdateTime == 0.0
        {
            _previousUpdateTime     = time
            
        }
        
        _deltaTime          = time - _previousUpdateTime
        //print("\(#function) _deltaTime: \(_deltaTime)")
        
        
        if _deltaTime > 0.2 {
            
            //print("\(#function) _deltaTime: \(_deltaTime)")
            
            _previousUpdateTime         = time
            //print("_previousTime: \(_previousUpdateTime)")

        }
        
        //print("\(#function) chase360CameraEulersInertiallyDampen = \(SpacecraftCameraState.shared.chase360CameraEulersInertiallyDampen)")
        if SpacecraftCameraState.shared.chase360CameraEulersInertiallyDampen == true {
            
            print("\(#function) Need to add inertia to camera.")
            
            inertialCameraRotation()
            
        } else {
            
            inertialElapsedTime = 0.0
            
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
    
    
    
    func inertialCameraRotation() {
        print("\(#function) Inertially dampening camera motion")
        
        Task {
            
            
            await MainActor.run {
                
                
                inertialElapsedTime += 1.0/60.0
                

                if abs(SpacecraftCameraState.shared.cameraInertialEulerX) > 0.01 || abs(SpacecraftCameraState.shared.cameraInertialEulerY) > 0.01 {
                    
                    //
                    // Dampen Chase360Camera's euler angle change.
                    //
                    
                    var updatedCameraInertialEulerX = SpacecraftCameraState.shared.cameraInertialEulerX
                    var updatedCameraInertialEulerY = SpacecraftCameraState.shared.cameraInertialEulerY
                    print("\(#function) Dampening updatedCameraInertialEulerX from cameraInertialEulerX = \(updatedCameraInertialEulerX)")
                    
                    if updatedCameraInertialEulerX > 0.0 {
                        //
                        // For updatedCameraInertialEulerX, swiping left is positive.
                        //
                        print("\(#function) updatedCameraInertialEulerX is > 0.0")
                        
                        updatedCameraInertialEulerX     = updatedCameraInertialEulerX - updatedCameraInertialEulerX * 0.05
                        //print("\(#function) decreasing updatedCameraInertialEulerX \(updatedCameraInertialEulerX) by \(updatedCameraInertialEulerX - updatedCameraInertialEulerX * 0.05)")
                        
                        if updatedCameraInertialEulerX > 0.0 && updatedCameraInertialEulerX < 0.025 {
                            
                            updatedCameraInertialEulerX     = updatedCameraInertialEulerX - 0.009
                            //print("\(#function) decreasing updatedCameraInertialEulerX \(updatedCameraInertialEulerX) by \(updatedCameraInertialEulerX - 0.009)")
                            
                        }
                        
                    } else {
                        //
                        // For updatedCameraInertialEulerX, swiping right is negative.
                        //
                        //print("\(#function) updatedCameraInertialEulerX is < 0.0")
                        
                        // Never forget that to subtract a negative from a negative, in this case the scaler needs to be...NEGATIVE!
                        updatedCameraInertialEulerX     = updatedCameraInertialEulerX + updatedCameraInertialEulerX * -0.05
                        //print("\(#function) decreasing updatedCameraInertialEulerX \(updatedCameraInertialEulerX) by \(updatedCameraInertialEulerX + updatedCameraInertialEulerX * 0.05)")
                        
                        if updatedCameraInertialEulerX > -0.025 && updatedCameraInertialEulerX < 0.0 {
                            
                            updatedCameraInertialEulerX     = updatedCameraInertialEulerX + 0.009
                            //print("\(#function) decreasing updatedCameraInertialEulerX \(updatedCameraInertialEulerX) by \(updatedCameraInertialEulerX + 0.009)")
                            
                        }
                                                
                    }
                    
                    if updatedCameraInertialEulerY > 0.0 {
                        
                        print("\(#function) updatedCameraInertialEulerY is > 0.0")
                        
                        updatedCameraInertialEulerY     = updatedCameraInertialEulerY - updatedCameraInertialEulerY * 0.075
                        //print("\(#function) decreasing updatedCameraInertialEulerY \(updatedCameraInertialEulerY) by \(updatedCameraInertialEulerY - updatedCameraInertialEulerY * 0.025)")
                        
                        if updatedCameraInertialEulerY > 0.0 && updatedCameraInertialEulerY < 0.001 {
                            
                            updatedCameraInertialEulerY     = updatedCameraInertialEulerY - 0.0005
                            //print("\(#function) decreasing updatedCameraInertialEulerY \(updatedCameraInertialEulerY) by \(updatedCameraInertialEulerY - 0.005)")
                            
                        }
                        
                        
                    } else {
                        
                        print("\(#function) updatedCameraInertialEulerY is < 0.0")
                        
                        // Never forget that to subtract a negative from a negative, in this case the scaler needs to be...NEGATIVE!
                        updatedCameraInertialEulerY     = updatedCameraInertialEulerY + updatedCameraInertialEulerY * -0.075
                        //print("\(#function) decreasing updatedCameraInertialEulerY \(updatedCameraInertialEulerY) by \(updatedCameraInertialEulerY + updatedCameraInertialEulerY * 0.025)")
                        
                        if updatedCameraInertialEulerY > -0.001 && updatedCameraInertialEulerY < 0.0 {
                            
                            updatedCameraInertialEulerY     = updatedCameraInertialEulerY + 0.0005
                            //print("\(#function) decreasing updatedCameraInertialEulerY \(updatedCameraInertialEulerY) by \(updatedCameraInertialEulerY + 0.005)")
                            
                        }
                                                
                    }
                    
                    print("\(#function) updatedCameraInertialEulerX = \(updatedCameraInertialEulerX)")
                    print("\(#function) updatedCameraInertialEulerY = \(updatedCameraInertialEulerY)")
                    
                    SpacecraftCameraState.shared.cameraInertialEulerX   = updatedCameraInertialEulerX
                    SpacecraftCameraState.shared.cameraInertialEulerY   = updatedCameraInertialEulerY
                    
                    
                    SpacecraftCameraState.shared.updateChase360CameraForInertia(of: self.spacecraftCurrentCameraNode,
                                                                                with: updatedCameraInertialEulerX,
                                                                                and: updatedCameraInertialEulerY)
                    
                } else {
                    
                    //
                    // Chase360Camera euler angle change has been damped-out enough, so toggle
                    // chase360CameraEulersInteriallyDampen to cease these operations.
                    //
                    SpacecraftCameraState.shared.chase360CameraEulersInertiallyDampen.toggle()
                    print("\(#function) SpacecraftCameraState.shared.chase360CameraInertia = \(SpacecraftCameraState.shared.chase360CameraEulersInertiallyDampen)")
                    
                }
                
                print("\(#function) inertialElapsedTime: \(inertialElapsedTime)")
                
            }
            
        }
    }
      
}
