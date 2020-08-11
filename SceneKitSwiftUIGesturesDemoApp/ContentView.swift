//
//  ContentView.swift
//  SceneKitSwiftUIGesturesDemoApp
//
//  Created by James Hillhouse IV on 7/30/20.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            SceneKitWithSwiftUIContentView()
                .tabItem {
                    Image(systemName: "hand.thumbsdown.fill")
                    Text("Vars Only")
                }

            //SwiftUISceneKitUsingVarsContentView()

            SwiftUISceneKitUsingStateVarsContentView()
                .tabItem {
                    Image(systemName: "airplane")
                    Text("State Vars")
                }

            SceneKitWithSCNSceneViewContentView()
                .tabItem {
                    Image(systemName: "hand.thumbsup.fill")
                    Text("SCNView")
                }
        }
    }
}



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

