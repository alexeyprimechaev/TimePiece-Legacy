//
//  PickerButton.swift
//  TimerPlus
//
//  Created by Alexey Primechaev on 1/15/20.
//  Copyright © 2020 Alexey Primechaev. All rights reserved.
//

import SwiftUI

struct ToggleButton: View {
    
    @State var title = String()
    
    @State var values = [String]()
    
    @Binding var value: String?
    
    @State var index = Int()
            
    var body: some View {
        Button(action: {
            if(self.index < self.values.count - 1) {
                self.index += 1
                self.value = self.values[self.index]
            } else {
                self.index = 0
                self.value = self.values[self.index]
            }
        
        }) {
            HStack(alignment: .bottom, spacing: 7) {
                Text(title)
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .opacity(0.5)
                ForEach(values, id: \.self) { value in
                    Text(value)
                        .font(.headline)
                        .fontWeight(.semibold)
                        .padding(.bottom, 5)
                        .opacity(self.value == value ? 1 : 0.5)
                }
                
            }
        }
        .buttonStyle(DeepButtonStyle())
        .onAppear {
            for i in 0...self.values.count-1 {
                print(i)
                print(self.values.count)
                if (self.value == self.values[i]) {
                    self.index = i
                    break
                }
                if (i == self.values.count-1) {
                    self.value = self.values[0]
                }
            }
        }
        .padding(7)
    }
}

struct DeepButtonStyle: ButtonStyle {

    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.96 : 1.0)
            .opacity(configuration.isPressed ? 0.8 : 1.0)
    }

}

