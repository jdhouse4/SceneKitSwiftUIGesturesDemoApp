//
//  SceneKitWithSCNSceneViewContentView.swift
//  SceneKitSwiftUIGesturesDemoApp
//
//  Created by James Hillhouse IV on 7/30/20.
//

import SwiftUI

struct SceneKitWithSCNSceneViewContentView: View {
    @State var lightSwitch: Bool            = false
    @State var sunlightSwitch: Int          = 0
    @State var bodyCameraSwitch: Bool       = false


    var body: some View {
        VStack(alignment: .center, spacing: 10) {
            Spacer()

            Text("Buzz In SwiftUI")
                .fixedSize()
                .font(.headline)

            Spacer()

            SceneKitView(lightSwitch: $lightSwitch,
                         sunlightSwitch: $sunlightSwitch,
                         bodyCameraSwitch: $bodyCameraSwitch)
                .scaleEffect(1.0, anchor: .top)

            Spacer()

            ControlsView(lightSwitch: $lightSwitch, sunlightSwitch: $sunlightSwitch, bodyCameraSwitch: $bodyCameraSwitch)

            Spacer(minLength: 50)
        }
    .padding()
    }
}


struct SceneKitWithSCNSceneViewContentView_Previews: PreviewProvider {
    static var previews: some View {
        SceneKitWithSCNSceneViewContentView()
    }
}
 
