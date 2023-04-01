//
//  SpacecraftCameraButtonsView.swift
//  SceneKitSwiftUIGesturesDemoApp
//
//  Created by James Hillhouse IV on 12/01/22.
//

import SwiftUI




struct SpacecraftCameraButtonsView: View {
    
    @Environment(\.horizontalSizeClass) var sizeClass
    
    /// @EnvironmentObject is a property wrapper type for an observable object that is
    /// instantiated by @StateObject supplied by a parent or ancestor view.
    @EnvironmentObject var spacecraft: SpacecraftSceneKitScene
    @EnvironmentObject var spacecraftDelegate: SpacecraftSceneRendererDelegate
    @EnvironmentObject var spacecraftCameraButton: SpacecraftCameraButton

    @State private var spacecraftExteriorCamera = true
    @State private var spacecraftInteriorCamera = false

    
    var body: some View {

        HStack (spacing: 5) {
            
            ZStack {
                
                Button(action: {
                    withAnimation(.ripple(buttonIndex: 2)) {
                        
                        self.spacecraftCameraButton.showCameraButtons.toggle()
                        
                    }
                }) {
                    
                    Image(systemName: spacecraftCameraButton.showCameraButtons ? "camera.fill" : "camera")
                        .imageScale(.large)
                        .accessibility(label: Text("Cameras"))
                    
                }
                .zIndex(3)
                .frame(
                    width: sizeClass == .compact ? CircleButtonSize.diameterCompact.rawValue : CircleButtonSize.diameter.rawValue,
                    height: sizeClass == .compact ? CircleButtonSize.diameterCompact.rawValue : CircleButtonSize.diameter.rawValue)
                .background(self.spacecraftCameraButton.showCameraButtons ? CircleButtonColor.onWithBackground.rawValue : CircleButtonColor.offWithBackground.rawValue)
                .clipShape(Circle())
                .background(Circle().stroke(Color.blue, lineWidth: 1))
                
                
                if spacecraftCameraButton.showCameraButtons {
                    
                    Group {
                        
                        //
                        // Button for toggling distant camera.
                        //
                        Button( action: {
                            
                            withAnimation {
                                
                                self.spacecraftExteriorCamera  = true
                                self.spacecraftInteriorCamera   = false
                                self.spacecraftCameraButton.spacecraftExteriorCameraButtonPressed.toggle()
                                
                            }
                            
                            self.changePOV(cameraString: self.spacecraft.spacecraftChase360CameraString)
                            
                        }) {
                            
                            Image(systemName: "airplane")
                                .imageScale(.large)
                                .opacity(self.spacecraftExteriorCamera == true ? 1.0 : 0.4)
                                .accessibility(label: Text("Show Exterior Camera"))
                                .padding()
                            
                        }
                        .zIndex(2)
                        .frame(width: sizeClass == .compact ? CircleButtonSize.diameterCompact.rawValue : CircleButtonSize.diameter.rawValue,
                               height: sizeClass == .compact ? CircleButtonSize.diameterCompact.rawValue : CircleButtonSize.diameter.rawValue)
                        .background(spacecraftExteriorCamera ? CircleButtonColor.onWithBackground.rawValue : CircleButtonColor.offWithBackground.rawValue)
                        .clipShape(Circle())
                        .background(Circle().stroke(Color.blue, lineWidth: 1))
                        .transition(moveAndFadeRight(buttonIndex: 1))
                        .offset(
                            x: sizeClass == .compact ? CircleButtonSize.diameterWithRadialSpacingCompact.rawValue : CircleButtonSize.diameterWithRadialSpacing.rawValue,
                            y: 0)
                        
                        
                        
                        //
                        // Button for toggling interior camera.
                        //
                        Button( action: {
                            
                            withAnimation {
                                
                                self.spacecraftInteriorCamera   = true
                                self.spacecraftExteriorCamera   = false
                                self.spacecraftCameraButton.spacecraftInteriorCameraButtonPressed.toggle()
                                
                            }
                            
                            self.changePOV(cameraString: self.spacecraft.spacecraftCommanderCameraString)
                            
                        }) {
                            
                            Image(systemName: "person.fill")
                                .imageScale(.large)
                                .opacity(spacecraftInteriorCamera == true ? 1.0 : 0.4)
                                .accessibility(label: Text("Interior Camera"))
                                .padding()
                            
                        }
                        .zIndex(2)
                        .frame(
                            width: sizeClass == .compact ? CircleButtonSize.diameterCompact.rawValue : CircleButtonSize.diameter.rawValue,
                            height: sizeClass == .compact ? CircleButtonSize.diameterCompact.rawValue : CircleButtonSize.diameter.rawValue)
                        .background(spacecraftInteriorCamera ? CircleButtonColor.onWithBackground.rawValue : CircleButtonColor.offWithBackground.rawValue)
                        .clipShape(Circle())
                        .background(Circle().stroke(Color.blue, lineWidth: 1))
                        .transition(moveAndFadeRight(buttonIndex: 2))
                        .offset(
                            x: sizeClass == .compact ? CircleButtonSize.diameterWithRadialSpacingCompact.rawValue * 2 : CircleButtonSize.diameterWithRadialSpacing.rawValue * 2,
                            y: 0)
                        
                    }
                    
                }
                
            }
            //.frame(width: 200, height: 70, alignment: .center)
            .padding(.init(top: 5, leading: 5, bottom: 5, trailing: 5))
            
        }
        
    }



    private func changePOV(cameraString: String) -> Void {
        print("\nContentView changePOV")
        
        
        print("cameraString: \(cameraString)")
        
        if cameraString == spacecraft.spacecraftChase360CameraString {
            
            self.spacecraft.spacecraftCurrentCamera = self.spacecraft.spacecraftChase360Camera
            self.spacecraft.spacecraftCurrentCamera.camera?.fieldOfView = 45.0
            self.spacecraftDelegate.setCurrentCameraName(name: spacecraft.spacecraftChase360CameraString)
            self.spacecraftDelegate.setCurrentCameraNode(node: spacecraft.spacecraftChase360CameraNode)
            
        }
        
        
        if cameraString == spacecraft.spacecraftCommanderCameraString {
            
            self.spacecraft.spacecraftCurrentCamera = self.spacecraft.spacecraftCommanderCamera
            self.spacecraft.spacecraftCurrentCamera.camera?.fieldOfView = 30.0
            self.spacecraftDelegate.setCurrentCameraName(name: spacecraft.spacecraftCommanderCameraString)
            self.spacecraftDelegate.setCurrentCameraNode(node: spacecraft.spacecraftCommanderCameraNode)
            
        }
        
    }



    /*
     Note:

     I chose not to remove these functions from the camera buttons view since they are only called here in this
     function. Were there calls to these functions elsewhere in the code, I wuold have moved these two functions
     to something like SpacecraftHelpers.swift
     */
    func moveAndFadeRight(buttonIndex: Int) -> AnyTransition {
        
        let insertion   = AnyTransition.offset(
            
            x: sizeClass == .compact ? ( -CircleButtonSize.diameterCompact.rawValue * CGFloat(buttonIndex) ) : ( -CircleButtonSize.diameter.rawValue * CGFloat(buttonIndex) ),
            y: 0)
        //.combined(with: .opacity)
        
        let removal     = AnyTransition.offset(
            
            x: sizeClass == .compact ? ( -CircleButtonSize.diameterCompact.rawValue * CGFloat(buttonIndex) ) : ( -CircleButtonSize.diameter.rawValue * CGFloat(buttonIndex) ),
            y: 0)
            .combined(with: .opacity)
        
        return AnyTransition.asymmetric(insertion: insertion, removal: removal)
        
    }



    func moveAndFadeLeft(buttonIndex: Int) -> AnyTransition {
        
        let insertion   = AnyTransition.offset(
            
            x: sizeClass == .compact ? CircleButtonSize.diameterCompact.rawValue * CGFloat(buttonIndex) : CircleButtonSize.diameter.rawValue * CGFloat(buttonIndex),
            y: 0)
        //.combined(with: .opacity)
        
        let removal     = AnyTransition.offset(
            
            x: sizeClass == .compact ? CircleButtonSize.diameterCompact.rawValue * CGFloat(buttonIndex) : CircleButtonSize.diameter.rawValue * CGFloat(buttonIndex),
            y: 0)
            .combined(with: .opacity)
        
        return AnyTransition.asymmetric(insertion: insertion, removal: removal)
        
    }
}




struct AircraftCameraButtons_Previews: PreviewProvider {
    
    static var previews: some View {
        
        SpacecraftCameraButtonsView().environmentObject(SpacecraftCameraButton())
        
    }
    
}
