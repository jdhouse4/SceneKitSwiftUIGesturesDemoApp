//
//  SwiftUISceneViewSimpleContentView.swift
//  SceneKitSwiftUIGesturesDemoApp
//
//  Created by James Hillhouse IV on 8/12/20.
//

import SwiftUI
import SceneKit




struct SwiftUISceneViewSimpleContentView: View {
    @StateObject var scene:SCNScene = SCNScene(named: "art.scnassets/ship.scn")!
    
    var body: some View {
        ZStack {
            Color.black.edgesIgnoringSafeArea(.all)

            SceneView (
                scene: SCNScene(named: "art.scnassets/ship.scn")//,
            )
            .background(Color.black)

            VStack() {
                Text("Hello, SceneKit!").multilineTextAlignment(.leading).padding()
                    .foregroundColor(Color.gray)
                    .font(.largeTitle)

                Spacer(minLength: 300)
            }
        }
        .statusBar(hidden: true)
    }
}

struct SwiftUISceneViewSimpleContentView_Previews: PreviewProvider {
    static var previews: some View {
        SwiftUISceneViewSimpleContentView()
    }
}
