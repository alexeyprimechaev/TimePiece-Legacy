//
//  ToggleButton.swift
//  TimerPlus
//
//  Created by Alexey Primechaev on 1/12/20.
//  Copyright © 2020 Alexey Primechaev. All rights reserved.
//

import SwiftUI

struct ToggleButton: View {
        
    @State var title = String()
    
    @Binding var isOn: NSNumber?
    
    var body: some View {
        
        Button(action: {
            if(self.isOn?.boolValue ?? false) {
                self.isOn = false
            } else {
                self.isOn = true
            }
            
        }) {
            HStack(alignment: .bottom, spacing: 7) {
                Text(title)
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .opacity(0.5)
                Text("Off")
                    .font(.headline)
                    .fontWeight(.semibold)
                    .padding(.bottom, 4)
                    .opacity(isOn?.boolValue ?? true ? 0.5 : 1)
                Text("On")
                    .font(.headline)
                    .fontWeight(.semibold)
                    .padding(.bottom, 4)
                    .opacity(isOn?.boolValue ?? true ? 1 : 0.5)
            }
        }
        .foregroundColor(Color.primary)
    .buttonStyle(MyButtonStyle())
            
    }
}

struct MyButtonStyle: ButtonStyle {

    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
    }

}

