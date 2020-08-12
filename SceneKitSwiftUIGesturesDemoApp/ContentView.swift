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

