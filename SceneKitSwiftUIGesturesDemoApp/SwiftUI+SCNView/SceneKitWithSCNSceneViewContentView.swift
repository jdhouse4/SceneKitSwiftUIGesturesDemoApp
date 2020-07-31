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

            VStack {
                Text("Hello, SceneKit!")
                    .foregroundColor(Color.gray)
                    .font(.largeTitle)

                Text("(in UIViewRepresentable)")
                    .foregroundColor(Color.gray)
                    .font(.body)
                    .padding()

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
 
