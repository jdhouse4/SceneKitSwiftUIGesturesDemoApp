//
//  SceneKitWithSCNSceneViewContentView.swift
//  SceneKitSwiftUIGesturesDemoApp
//
//  Created by James Hillhouse IV on 7/30/20.
//

import SwiftUI

struct SceneKitWithSCNSceneViewContentView: View {
    //@State var lightSwitch: Bool            = false
    @State var sunlightSwitch: Bool          = false
    //@State var bodyCameraSwitch: Bool       = false


    var body: some View {
        VStack(alignment: .center, spacing: 10) {
            Spacer()

            Text("Buzz In SwiftUI")
                .fixedSize()
                .font(.headline)

            Spacer()

            SceneKitView(sunlightSwitch: $sunlightSwitch)
                .scaleEffect(1.0, anchor: .top)

            /*
            SceneKitView(lightSwitch: $lightSwitch,
                         sunlightSwitch: $sunlightSwitch,
                         bodyCameraSwitch: $bodyCameraSwitch)
                .scaleEffect(1.0, anchor: .top)
            */
            Spacer()

            ControlsView(sunlightSwitch: $sunlightSwitch)

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
 
