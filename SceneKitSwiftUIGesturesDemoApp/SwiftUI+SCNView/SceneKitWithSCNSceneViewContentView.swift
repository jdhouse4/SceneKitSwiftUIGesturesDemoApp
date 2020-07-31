//
//  SceneKitWithSCNSceneViewContentView.swift
//  SceneKitSwiftUIGesturesDemoApp
//
//  Created by James Hillhouse IV on 7/30/20.
//

import SwiftUI

struct SceneKitWithSCNSceneViewContentView: View {
    @State var sunlightSwitch: Bool          = true


    var body: some View {
        ZStack {
            Color.black.edgesIgnoringSafeArea(.all)

            SceneKitView(sunlightSwitch: $sunlightSwitch)
                .background(Color.black)


            /*
            SceneKitView(lightSwitch: $lightSwitch,
                         sunlightSwitch: $sunlightSwitch,
                         bodyCameraSwitch: $bodyCameraSwitch)
                .scaleEffect(1.0, anchor: .top)
            */

            VStack {
                Text("Hello, SceneKit!").multilineTextAlignment(.leading).padding()
                    .foregroundColor(Color.gray)
                    .font(.largeTitle)


                Text("(in UIViewRepresentable")
                    .foregroundColor(Color.gray)
                    .font(.title3)

                Text("Pinch to zoom.")
                    .foregroundColor(Color.gray)
                    .font(.title)


                Spacer(minLength: 300)

                ControlsView(sunlightSwitch: $sunlightSwitch)
            }
        }
    }
}


struct SceneKitWithSCNSceneViewContentView_Previews: PreviewProvider {
    static var previews: some View {
        SceneKitWithSCNSceneViewContentView()
    }
}
 
