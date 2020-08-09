//
//  SceneKitWithSwiftUIContentView.swift
//  SceneKitSwiftUIGesturesDemoApp
//
//  Created by James Hillhouse IV on 7/30/20.
//


import SwiftUI
//import SceneKit



struct SceneKitWithSwiftUIContentView: View {
    @State private var sunlightSwitch   = true
    @State private var magnify          = CGFloat(1.0)
    @State private var doneMagnifying   = false


    @GestureState private var magnifyBy = CGFloat(1.0)


    var magnification: some Gesture {
        MagnificationGesture()
            .updating($magnifyBy) { (currentState, gestureState, transaction) in
                gestureState = currentState
            }
            .onChanged{ (value) in
                self.magnify = value
            }
            .onEnded { _ in
                self.doneMagnifying = true
            }
    }



    var body: some View {
        ZStack {
            Color.black.edgesIgnoringSafeArea(.all)

            AircraftSceneView(sunlightSwitch: $sunlightSwitch)
            .gesture(magnification)
            .background(Color.black)

            VStack() {
                Text("Hello, SceneKit!").multilineTextAlignment(.leading).padding()
                    .foregroundColor(Color.gray)
                    .font(.largeTitle)

                Text("Pinch to zoom.")
                    .foregroundColor(Color.gray)
                    .font(.title)

                Spacer(minLength: 300)

                ControlsView(sunlightSwitch: $sunlightSwitch)
            }
        }
        .statusBar(hidden: true)
    }
}


struct SceneKitWithSwiftUIContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            SceneKitWithSwiftUIContentView()
        }
    }
}
