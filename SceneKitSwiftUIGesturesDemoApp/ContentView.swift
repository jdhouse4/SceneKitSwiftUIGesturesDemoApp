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
                    Image(systemName: "1.square.fill")
                    Text("SwiftUI Only")
                }

            SceneKitWithSCNSceneViewContentView()
                .tabItem {
                    Image(systemName: "2.square.fill")
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

