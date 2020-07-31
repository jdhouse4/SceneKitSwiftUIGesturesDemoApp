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
                    Image(systemName: "tortoise.fill")
                    Text("SwiftUI Only")
                }

            SceneKitWithSCNSceneViewContentView()
                .tabItem {
                    Image(systemName: "hare.fill")
                    Text("SwiftUI + SCNView")
                }
        }
    }
}



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

