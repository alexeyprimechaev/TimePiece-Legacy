//
//  PickerButton.swift
//  TimerPlus
//
//  Created by Alexey Primechaev on 1/15/20.
//  Copyright © 2020 Alexey Primechaev. All rights reserved.
//

import SwiftUI

struct PickerButton: View {
    
    //MARK: - Properties
    @State var title = String()
    @State var values = [String]()
    @Binding var value: String
    @State var index = Int()
    
    //MARK: - View
    var body: some View {
        
        Button(action:
        //MARK: Action
        {
            if self.index < self.values.count - 1 {
                self.index += 1
                self.value = self.values[self.index]
            } else {
                self.index = 0
                self.value = self.values[self.index]
            }
        })
            
    
        //MARK: Layout
        {
            HStack(alignment: .bottom, spacing: 7) {
                Text(title)
                    .titleStyle()
                    .opacity(0.5)
                ForEach(values, id: \.self) { value in
                    Text(value)
                        .padding(.bottom, 5)
                        .opacity(self.value == value ? 1 : 0.5)
                }.smallTitleStyle()
                
            }
        }
            
            
        //MARK: Styling
        .buttonStyle(RegularButtonStyle())
            
            
        //MARK: On Appear
        .onAppear {
            for i in 0...self.values.count-1 {
                if self.value == self.values[i] {
                    self.index = i
                    break
                }
                if i == self.values.count-1 {
                    self.value = self.values[0]
                }
            }
        }
        .padding(7)
    }
}



