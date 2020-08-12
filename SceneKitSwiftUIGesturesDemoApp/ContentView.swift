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
                    Image(systemName: "trash.fill")
                    Text("Just vars")
                }

            SwiftUISceneKitUsingVarsContentView()
                .tabItem {
                    Image(systemName: "hand.raised.fill")
                    Text("Vars with copy")
                }

            SwiftUISceneKitUsingStateVarsContentView()
                .tabItem {
                    Image(systemName: "hand.thumb.fill")
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

