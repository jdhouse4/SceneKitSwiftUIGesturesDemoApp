//
//  AircraftCameraButtonsView.swift
//  SwiftUISceneKitCoreMotionDemo
//
//  Created by James Hillhouse IV on 5/25/21.
//

import SwiftUI




struct AircraftCameraButtonsView: View {
    @Environment(\.horizontalSizeClass) var sizeClass
    
    /// @EnvironmentObject is a property wrapper type for an observable object that is
    /// instantiated by @StateObject supplied by a parent or ancestor view.
    @EnvironmentObject var aircraft: AircraftSceneKitScene
    @EnvironmentObject var aircraftDelegate: AircraftSceneRendererDelegate
    @EnvironmentObject var aircraftCameraButton: AircraftCameraButton

    @State private var distantCamera    = true
    @State private var shipCamera       = false

    
    var body: some View {

        HStack (spacing: 5) {

            ZStack {
                
                Button(action: {
                    withAnimation(.ripple(buttonIndex: 2)) {

                        self.aircraftCameraButton.showCameraButtons.toggle()
                    }
                }) {
                    Image(systemName: aircraftCameraButton.showCameraButtons ? "camera.fill" : "camera")
                        .imageScale(.large)
                        .accessibility(label: Text("Cameras"))
                }
                .zIndex(3)
                .frame(
                    width: sizeClass == .compact ? CircleButtonSize.diameterCompact.rawValue : CircleButtonSize.diameter.rawValue,
                    height: sizeClass == .compact ? CircleButtonSize.diameterCompact.rawValue : CircleButtonSize.diameter.rawValue)
                .background(self.aircraftCameraButton.showCameraButtons ? CircleButtonColor.onWithBackground.rawValue : CircleButtonColor.offWithBackground.rawValue)
                .clipShape(Circle())
                .background(Circle().stroke(Color.blue, lineWidth: 1))


                if aircraftCameraButton.showCameraButtons {
                    
                    Group {

                        //
                        // Button for toggling distant camera.
                        //
                        Button( action: {
                            withAnimation {
                                self.distantCamera  = true
                                self.aircraftCameraButton.distantCameraButtonPressed.toggle()
                            }
                            
                            self.changePOV(cameraString: self.aircraft.aircraftDistantCameraString)
                            
                        }) {
                            Image(systemName: "airplane")
                                .imageScale(.large)
                                .opacity(self.distantCamera == true ? 1.0 : 0.4)
                                .accessibility(label: Text("Show Distant Camera"))
                                .padding()
                        }
                        .zIndex(2)
                        .frame(width: sizeClass == .compact ? CircleButtonSize.diameterCompact.rawValue : CircleButtonSize.diameter.rawValue,
                               height: sizeClass == .compact ? CircleButtonSize.diameterCompact.rawValue : CircleButtonSize.diameter.rawValue)
                        .background(distantCamera ? CircleButtonColor.onWithBackground.rawValue : CircleButtonColor.offWithBackground.rawValue)
                        .clipShape(Circle())
                        .background(Circle().stroke(Color.blue, lineWidth: 1))
                        .transition(moveAndFadeRight(buttonIndex: 1))
                        .offset(
                            x: sizeClass == .compact ? CircleButtonSize.diameterWithRadialSpacingCompact.rawValue : CircleButtonSize.diameterWithRadialSpacing.rawValue,
                            y: 0)
                        
                    }
                }
            }
            //.frame(width: 200, height: 70, alignment: .center)
            .padding(.init(top: 5, leading: 5, bottom: 5, trailing: 5))
        }
    }


    //
    // Escaping closure to push change from the AircraftScene function cycleCameras()
    //
    // Because of the way SwiftUI works, the call to the AircraftSceneRendererDelegate function cycleCamera()
    // wasn't being 'seen'.
    //
    func modifyPOV(closure: @escaping () -> Void) {
        closure()
    }



    private func changePOV(cameraString: String) -> Void {
        print("\nContentView changePOV")

        modifyPOV { [self] in

            print("cameraString: \(cameraString)")

            if cameraString == aircraft.aircraftDistantCameraString {
                self.aircraft.aircraftCurrentCamera = self.aircraft.aircraftDistantCamera
                self.aircraftDelegate.setCameraName(name: aircraft.aircraftDistantCameraString)
                self.aircraftDelegate.setCameraNode(node: aircraft.aircraftDistantCameraNode)
            }
        }
    }



    /*
     Note:

     I chose not to remove these functions from the camera buttons view since they are only called here in this
     function. Were there calls to these functions elsewhere in the code, I wuold have moved these two functions
     to AircraftHelpers.swift
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
        AircraftCameraButtonsView().environmentObject(AircraftCameraButton())
    }
}
