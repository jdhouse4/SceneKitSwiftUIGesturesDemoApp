//
//  ControlsView.swift
//  BuzzWithSwiftUI
//
//  Created by James Hillhouse IV on 12/16/19.
//  Copyright © 2019 PortableFrontier. All rights reserved.
//

import SwiftUI

struct ControlsView: View {

    @Binding var sunlightSwitch: Bool



    var body: some View {
        VStack {
            HStack {
                SunLightButton(sunlightSwitch: $sunlightSwitch)
            }
        }
    }
}




/*
struct ControlsView_Previews: PreviewProvider {
    static var previews: some View {
        ControlsView(lightSwitch: lightSwitch, sunlightSwitch: sunlightSwitch, bodyCameraSwitch: buzzBodyCamera)
    }
}
*/
