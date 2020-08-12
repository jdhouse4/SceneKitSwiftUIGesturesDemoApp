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
            /*
            SwiftUISceneViewSimpleContentView()
                .tabItem {
                    Image(systemName: "trash")
                    Text("No vars")
                }


            SwiftUISceneKitUsingVarsContentView()
                .tabItem {
                    Image(systemName: "trash.fill")
                    Text("Just vars")
                }
            */
            SwiftUISceneKitUsingVarsWithCopyContentView()
                .tabItem {
                    Image(systemName: "hand.raised.fill")
                    Text("Vars with copy")
                }

            SwiftUISceneKitUsingStateObjectVarsContentView()
                .tabItem { 
                    Image(systemName: "tortoise.fill")
                    Text("StateObject vars")
                }
            /*
            SwiftUISceneKitUsingStateVarsContentView()
                .tabItem {
                    Image(systemName: "hand.thumbsdown.fill")
                    Text("State Vars")
                }
            */
            SceneKitWithSCNSceneViewContentView()
                .tabItem {
                    Image(systemName: "hare.fill")
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

