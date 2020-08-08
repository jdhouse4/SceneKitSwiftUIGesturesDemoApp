//
//  SunLightButton.swift
//  BuzzWithSwiftUI
//
//  Created by James Hillhouse IV on 9/29/19.
//  Copyright © 2019 PortableFrontier. All rights reserved.
//

import SwiftUI

struct SunLightButton: View {
        @Binding var sunlightSwitch: Bool


        var body: some View {
            Button( action: {
                withAnimation{ self.sunlightSwitch.toggle() }
                print("SunLightButton hit")
            }) {
                Image(systemName: sunlightSwitch ? "lightbulb.fill" : "lightbulb")
                    .imageScale(.large)
                    .accessibility(label: Text("Light Switch"))
                    .padding()
            }
        }
    }

/*
struct SunLightButton_Previews: PreviewProvider {
    static var previews: some View {
        SunLightButton()
    }
}
 */
