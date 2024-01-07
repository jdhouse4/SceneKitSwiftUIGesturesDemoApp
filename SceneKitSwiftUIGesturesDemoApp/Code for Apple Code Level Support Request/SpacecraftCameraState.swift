//
//  SpacecraftCameraState.swift
//  MissionOrion2
//
//  Created by James Hillhouse IV on 8/7/22.
//

import Foundation
import SceneKit
import SwiftUI
import simd




@MainActor
class SpacecraftCameraState: ObservableObject {
    
    // Needed to expose the camera state to the rest of the code base.
    static var shared                                           = SpacecraftCameraState()
    
    private let screenWidth                                     = UIScreen.main.bounds.width
        
    // The current camera
    @Published var currentCamera: SCNNode                       = SCNNode()
    

    //
    // These published properties have to do with the camera's orientation.
    //
    @Published var cameraInertialEulerX: Float                  = Float()
    @Published var cameraInertialEulerY: Float                  = Float()
    @Published var totalCommanderCameraEulerAngles: simd_float3 = simd_float3()
    @Published var totalChase360CameraEulerAngles: simd_float3  = simd_float3()
    
    
    // A published property for determining whether the camera's motion should be dampened.
    @Published var chase360CameraEulersInertiallyDampen: Bool   = false

    
    @Published var currentCameraDistance: Float                 = 14.0


    
    //
    // These parameters are for the camera distance.
    //
    let maximumCurrentCameraDistance: Float                     = 40.0
    let minimumCurrentCameraDistance: Float                     = 2.0

    
    
    let decelerationRate: Float                                 = 1.0
    var endLocationX: Float                                     = Float()
    var endLocationY: Float                                     = Float()
    var predictedEndTranslation: simd_float2                    = simd_float2()
    var predictedEndTranslationLength: Float                    = 0.0
    var deltaTranslation: simd_float2                           = simd_float2()
    var deltaTranslationLength: Float                           = 0.0
    var decelerationTimeSteps: Float                            = 0.0
    
    

    private init() { }
    
    
    // MARK: -Change The Exterior Camera Orientation
    func changeExteriorCameraOrientation(of currentCameraNode: SCNNode, with value: DragGesture.Value) {
        
        print("\n\(#function) currentCameraNode: \(currentCameraNode)")
        

        //
        // The translation on the screen for the drag gesture.
        //
        let translationX = Float( value.translation.width )
        let translationY = Float( value.translation.height )
        //print("\(#function) translationX: \(translationX)")
        //print("\(#function) translationY: \(translationY)")
        
        
        //
        // The ratio of the drag distance to the x and y width parameters of the screen.
        //
        let translationWidthRatio   = translationX / Float(UIScreen.main.bounds.width)
        let translationHeightRatio  = translationY / (Float(UIScreen.main.bounds.height) * 2.0 ) // This is to slow-down pitch, which can be a pain when also yawing.
        //print("\(#function) translationWidthRatio: \(translationWidthRatio)")
        //print("\(#function) translationHeightRatio: \(translationHeightRatio)")
        
        
        //
        // The Euler angle change in the x and y components of the screen from the resulting drag gesture.
        //
        let cameraEulerX    = Float(-2 * Double.pi) * translationWidthRatio
        let cameraEulerY    = Float(Double.pi) * translationHeightRatio
        //print("\(#function) cameraEulerX: \(cameraEulerX)")
        //print("\(#function) cameraEulerY: \(cameraEulerY)")
        
        
        //
        // There is a mapping that the user needs to be aware of. The x-axis drag gesture corresponds to a rotation
        // about the y-axis of the camera node in SceneKit.
        //
        currentCameraNode.eulerAngles.y = cameraEulerX + totalChase360CameraEulerAngles.y
        //print("\(#function) \(currentCameraNode) euler.y: \(currentCameraNode.eulerAngles.y)")
        
        
        //
        // The y-axis drag gesture corresponds to a rotation about the z-axis of the camera node in SceneKit.
        //
        if abs(cameraEulerY + totalChase360CameraEulerAngles.z) > abs(Float(Double.pi / 2.0)) {
            
            //print("\(#function) Ooopsie! Angle too high.")
            
            if cameraEulerY + totalChase360CameraEulerAngles.z > 0 {
                
                currentCameraNode.eulerAngles.z = Float(Double.pi / 2.0)
                
            } else {
                
                currentCameraNode.eulerAngles.z = -Float(Double.pi / 2.0)
                
            }
            
        } else {
            
            currentCameraNode.eulerAngles.z = cameraEulerY + totalChase360CameraEulerAngles.z
            
        }

        print("\(#function) End of DragGesture .onChanged of \(currentCameraNode.name!) Total simdEulerAngles: \(totalChase360CameraEulerAngles)")
        
    }
    
    
    
    // MARK: -Change The Interior Camera Orientation
    //
    // This function is for changing the orientation of the interior camera that is inside the spacecraft.
    //
    func changeInteriorCameraOrientation(of currentCameraNode: SCNNode, with value: DragGesture.Value) {
        
        //print("\n")
        
        
        let translationX = Float(value.translation.width)
        let translationY = Float(-value.translation.height)
        
        let translationWidthRatio   = translationX / Float(UIScreen.main.bounds.width)
        let translationHeightRatio  = translationY / Float(UIScreen.main.bounds.height)
        
        let cameraEulerX    = Float(-2 * Double.pi) * translationWidthRatio
        let cameraEulerY    = Float(-Double.pi) * translationHeightRatio
        
        currentCameraNode.eulerAngles.y =    cameraEulerX + totalCommanderCameraEulerAngles.y
        currentCameraNode.eulerAngles.x = -( cameraEulerY + -( totalCommanderCameraEulerAngles.x ) )
        
        //print("\(#function) End of DragGesture .onChanged simdEulerAngles: \(currentCameraNode.simdEulerAngles)")
        //print("\(#function) End of DragGesture .onChanged of \(currentCameraNode.name!) Total simdEulerAngles: \(totalCommanderCameraEulerAngles)")
        
    }
    
    
    
    // MARK: Calculate delta between actual and predicted translation from touch
    // Determines the distance between the end of the drag gesture and the predicted end of the drag gesture
    // when the user lifts their finger.
    //
    fileprivate func calculatePredictedAndEndTranslationDelta(_ value: DragGesture.Value) {
        //
        // Record the DragGesture.Value parameters at the end of the swipe.
        //
        endLocationX                = Float( value.location.x)
        endLocationY                = Float( value.location.y)
        //print("\(#function) endLocationX: \(value.location.x)")
        //print("\(#function) endLocationY: \(value.location.y)")
        //print("\(#function) Translation: \((simd_float2(x: Float(value.translation.width), y: Float(value.translation.height))))")
        
        predictedEndTranslation     = simd_float2(x: Float(value.predictedEndTranslation.width),
                                                  y: Float(value.predictedEndTranslation.height))
        //print("\(#function) predictedEndLocationX: \((value.predictedEndLocation.x))")
        //print("\(#function) predictedEndLocationY: \((value.predictedEndLocation.y))")
        //print("\(#function) predictedEndTranslation: \((predictedEndTranslation))")
        
        
        deltaTranslation            = simd_float2(x: Float(value.predictedEndTranslation.width), y: Float(value.predictedEndTranslation.height)) - simd_float2(x: Float(value.translation.width), y: Float(value.translation.height))
        //print("\(#function) deltaTranslation: \(deltaTranslation)")
        
        deltaTranslationLength      = simd_length(deltaTranslation)
        //print("\(#function) deltaTranslationLength: \(deltaTranslationLength)")
        
    }
    
    
    
    //
    // MARK: Determine if a DragGesture was of sufficient velocity to enable inertia
    // This fuction determines if a DragGesture was of sufficient velocity to enable inertia, and if so
    // then calculates other things needed for inertia.
    //
    func chase360CameraInertia(of currentCameraNode: SCNNode, with value: DragGesture.Value) {
        
        //print("\n\(#function) currentCameraNode: \(currentCameraNode)")
        
        //print("\(#function) deltaTranslationLength: \(deltaTranslationLength)")
                
        
        //
        // If deltaTranslationLength is above a certain amount, then there needs to be inertial dampening of the
        // Chase360Camera euler angles x and y over a period of time. This simulates that the camera can be whipped-around.
        //
        if deltaTranslationLength > 50 {
            
            //
            // This calculates the values for cameraInertialEulerX and cameraInertialEulerY, which will be used 
            // in the SCNRendererDelegate to affect an inertially dampening of the change of the camera's
            // euler angles.
            //
            calculateCameraEulerAngles()
            
            //
            // Now that the preliminary work is done calculating cameraInertialEulerX and cameraInertialEulerY, setting
            //
            // chase360CameraEulersInertiallyDampen = true
            //
            // will trigger SCNRendererDelegate to call updateChase360CameraForInertia until cameraInertialEulerX
            // and cameraInertialEulerY are small enough to zero-out and cease Chase360Camera's euler angle changes.
            //
            chase360CameraEulersInertiallyDampen    = true
            //print("\(#function) chase360CameraEulersInertiallyDampen = \(chase360CameraEulersInertiallyDampen)")
            
        }
        
    }
    
    
    
    // MARK: Calculate current camera euler angles
    // This will be needed in determining the dampening.
    fileprivate func calculateCameraEulerAngles() {
        //print("\(#function) Calculating the Chase360CameraInertia.")
        
        
        //
        // Currently fixed deceleration time steps are used since it was easiest to use. Perhaps someday, when I'm smarter, I'll create
        // a more exotic second or third order function for deceleration.
        //
        let deltaTranslationXStep   = Float( deltaTranslation.x) / 25.0 //decelerationTimeSteps
        let deltaTranslationYStep   = Float( deltaTranslation.y) / 25.0 //decelerationTimeSteps
        //print("\(#function) deltaTranslationXStep: \(deltaTranslationXStep)")
        //print("\(#function) deltaTranslationYStep: \(deltaTranslationYStep)")
        
        let calculatedX             = deltaTranslationXStep
        let calculatedY             = deltaTranslationYStep
        //print("\(#function) calculatedX: \(calculatedX)")
        //print("\(#function) calculatedY: \(calculatedY)")
        
        let translationWidthRatio   = Float( calculatedX ) /        Float(UIScreen.main.bounds.width)
        let translationHeightRatio  = Float( calculatedY ) / (2.0 * Float(UIScreen.main.bounds.height)) // This is to slow-down pitch, which can be a pain when also yawing.
        //print("\(#function) translationWidthRatio: \(translationWidthRatio)")
        //print("\(#function) translationHeightRatio: \(translationHeightRatio)")
        
        cameraInertialEulerX        = Float(-2 * Double.pi) * translationWidthRatio // Yaw
        cameraInertialEulerY        = Float(Double.pi) * translationHeightRatio // Pitch
        //print("\(#function) cameraInertialEulerX: \(cameraInertialEulerX)")
        //print("\(#function) cameraInertialEulerY: \(cameraInertialEulerY)")
        
    }
    
    
    
    // MARK: Update the exterior camera for the euler angles resulting from inertia.
    func updateChase360CameraForInertia(of currentCameraNode: SCNNode, with cameraInertialEulerX: Float, and cameraInertialEulerY: Float) {
        //print("\n\(#function) currentCameraNode: \(currentCameraNode)")
        
        //
        // The node's orientation would be calculated here
        //
        //
        // Assign yaw.
        currentCameraNode.eulerAngles.y = cameraInertialEulerX + self.totalChase360CameraEulerAngles.y
        //print("\(#function) Chase360Camera euler.y: \(currentCameraNode.eulerAngles.y)")
        
        //
        // Deal with pitch exceeding ± 90°
        //
        if abs(cameraInertialEulerY + self.totalChase360CameraEulerAngles.z) > abs(Float(Double.pi / 2.0)) {
            
            //print("\(#function) Ooopsie! Angle too high.")
            
            if cameraInertialEulerY + self.totalChase360CameraEulerAngles.z > 0 {
                
                currentCameraNode.eulerAngles.z = Float(Double.pi / 2.0)
                
            } else {
                
                currentCameraNode.eulerAngles.z = -Float(Double.pi / 2.0)
                
            }
            
        } else {
            
            currentCameraNode.eulerAngles.z = cameraInertialEulerY + self.totalChase360CameraEulerAngles.z
            
        }
        
        totalChase360CameraEulerAngles      = currentCameraNode.simdEulerAngles
        
    }
    
    
    
    // MARK: Update the final camera orientation.
    func updateCameraOrientation(of currentCameraNode: SCNNode, with value: DragGesture.Value) {
        //print("\n")
        
        print("\n\(#function) Current Camer Node: \(currentCameraNode) with drag value: \(value)")
        
        //
        // Using Euler Angles
        //
        //print("\(#function) Current Eulers: \(String(describing: currentCameraNode.simdEulerAngles))")
        //print("\(#function) Total Eulers: \(String(describing: totalCommanderCameraEulerAngles))")
        
        
        //
        // Determine the camera node for which to set the total euler angles.
        //
        if currentCameraNode.name! == SpacecraftCamera.spacecraftCommanderCamera.rawValue {
            
            //print("\(#function) Current Camera Node is: \(currentCameraNode.name!)")
            
            totalCommanderCameraEulerAngles     = currentCameraNode.simdEulerAngles
            
            //print("\(#function) totalCommanderCameraEulerAngles: \(String(describing: totalCommanderCameraEulerAngles))")
            
        }
        if currentCameraNode.name! == SpacecraftCamera.spacecraftChase360Camera.rawValue + "Node" {
            
            print("\(#function) Current Camera Node is: \(currentCameraNode.name!)")
            
            totalChase360CameraEulerAngles      = currentCameraNode.simdEulerAngles
            //print("\(#function) totalChase360CameraEulerAngles: \(totalChase360CameraEulerAngles)")
            
            calculatePredictedAndEndTranslationDelta(value)
            
            print("\(#function) totalChase360CameraEulerAngles: \(String(describing: totalChase360CameraEulerAngles))")
            
        }
        
    }
    
    
    
    // MARK: -Change Camera Distance (for zooming in and out)
    func resetCameraOrientation(of currentCameraNode: SCNNode) {
        //print("\n")
        //
        // This resets the cameras so that resetting the update on one doesn't pollute the other cameras.
        //
        
        currentCameraNode.transform = SCNMatrix4Identity
        
        //print("\(#function) currentCameraNode.name: \(currentCameraNode.name!)")
        
        // This resets the "neck" of the spacecraft's interior commander camera
        if currentCameraNode.name! == SpacecraftCamera.spacecraftCommanderCamera.rawValue {
            
            //print("\(#function) RESET currentCameraNode.name: \(currentCameraNode.name!)")
            //print("\(#function) RESET SpacecraftCamera.spacecraftCommanderCamera.rawValue: \(SpacecraftCamera.spacecraftCommanderCamera.rawValue)")
            
            totalCommanderCameraEulerAngles         *= 0.0
            currentCameraNode.pivot                 = SCNMatrix4Identity
            currentCameraNode.simdEulerAngles       *= 0.0
            currentCameraNode.simdPivot.columns.3.y = -0.09
            
        } else if currentCameraNode.name! == SpacecraftCamera.spacecraftChase360Camera.rawValue + "Node" {
            
            //print("\(#function) RESET currentCameraNode.name: \(currentCameraNode.name!)")
            //print("\(#function) RESET SpacecraftCamera.spacecraftCommanderCamera.rawValue: \(SpacecraftCamera.spacecraftCommanderCamera.rawValue)")
            
            totalChase360CameraEulerAngles          *= 0.0
            currentCameraNode.pivot                 = SCNMatrix4Identity
            currentCameraNode.simdEulerAngles       *= 0.0
        }
        
    }
    
    
    
    func changeCurrentCameraDistance(of camera: SCNNode, value: Float) {
        
        //
        // The value passed-in is the distance. It ranges from 0...up.
        //
        // Pinching-in is < 1.0.
        //
        // Pinching-out is > 1.0
        //
        
        //print("\(#function) currentCamera: \(currentCamera)")
        
        
        //
        // I will at some point create a more improved rate of change for camera distance relative to the object. This could be a first-order
        // linear function for calculating a deltaCameraDistanceRateChange, which would be in place of the pow(blah, blah) I'm currently using.
        //
        if value < 1.0 {
            
            // Moving the camera out
            
            if currentCameraDistance < 10 {
                
                currentCameraDistance += pow(0.025, value)
                
            } else {
                
                currentCameraDistance += pow(0.1, value)
                
            }
            
        } else {
            
            // Moving the camera in
            
            if currentCameraDistance < 8.0 {
                
                // Moving the camera in slowly
                currentCameraDistance -= value / 100.0
                
            } else {
                
                currentCameraDistance -= value / 20.0
                
            }
            
        }
        
        print("\(#function) currentCameraDistance: \(currentCameraDistance)")
        
        
        //
        // Max and min camera distance from the object.
        //
        if currentCameraDistance >= 40.0 {
            
            currentCameraDistance  = 40.0
            
        }
        
        if currentCameraDistance <= 2.0 {
            
            currentCameraDistance  = 2.0
            
        }
        
        
        if camera.simdPosition.z <= maximumCurrentCameraDistance {
            
            camera.simdPosition.z   = currentCameraDistance
            
        }
        
        if camera.simdPosition.z >= minimumCurrentCameraDistance {
            
            camera.simdPosition.z   = currentCameraDistance
            
        }
        
    }
    
    
    
    func resetCurrentCameraDistance(of currentCamera: SCNNode, screenWdith: UserInterfaceSizeClass) {
        print("\n\(#function) currentCamera: \(String(describing: currentCamera)).simdPosition: \(currentCamera.simdPosition.z)\n")
        //print("\(#function) current screenWidth size class: \(screenWidth)")
        
        
        if currentCamera.name == SpacecraftCamera.spacecraftChase360Camera.rawValue {
            
            if screenWdith == .compact {
                
                currentCameraDistance           = 12.5
                
                currentCamera.simdPosition.z    = currentCameraDistance
                
            }
            if screenWdith == .regular {
                
                currentCameraDistance           = 20
                
                currentCamera.simdPosition.z    = currentCameraDistance
                
            }
            
            print("\(currentCamera).simdPosition.z: \(currentCamera.simdPosition.z)")
        }

    }
    
}
