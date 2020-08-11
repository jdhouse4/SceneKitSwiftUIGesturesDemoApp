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
            SwiftUISceneKitUsingVarsContentView()
                .tabItem {
                    Image(systemName: "hand.thumbsdown.fill")
                    Text("Just Vars")
                }

            //SwiftUISceneKitUsingVarsAndStateVarsContentView()

            SwiftUISceneKitUsingStateVarsContentView()
                .tabItem {
                    Image(systemName: "hand.thumbsup.fill")
                    Text("State Vars")
                }

            SceneKitWithSCNSceneViewContentView()
                .tabItem {
                    Image(systemName: "airplane")
                    Text("UIViewRep.")
                }
        }
    }
}



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

