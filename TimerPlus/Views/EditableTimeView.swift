//
//  EditableTimeView.swift
//  TimerPlus
//
//  Created by Alexey Primechaev on 1/20/20.
//  Copyright © 2020 Alexey Primechaev. All rights reserved.
//

import SwiftUI

struct EditableTimeView: View {
    
    @Binding var time: TimeInterval
    
    @State var title = String()
    
    @State var value = ""
    
    @State var isFirstResponder = false
    
    @State var firstAppear = true
    
    var update: () -> ()
    
    
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            HStack(alignment: .bottom, spacing: 5) {
                Text(value.count == 0 ? "00:00": value.stringToTime())
                    .titleStyle()
                    .onAppear() {
                        self.value = self.time.stringFromNumber()
                    }
                .opacity(value.count == 0 ? 0.5: 1)
                Text(title)
                    .smallTitleStyle()
                    .opacity(value.count == 0 ? 1 : 0.5)
                    .padding(.bottom, 5)
                    .padding(.leading, 5)
            }
            
            TextField("00:00", text: $value, onEditingChanged: { _ in
                print("hello")
                self.time = self.value.calculateTime()
                self.update()
            }) {
                if self.value == "" {
                    self.value = self.time.stringFromNumber()
                }
                self.time = self.value.calculateTime()
                self.value = self.time.stringFromNumber()
                self.update()
            }
            .introspectTextField { textField in
                textField.font = UIFont(name: "AppleColorEmoji", size: 34)
                textField.font = .systemFont(ofSize: 34, weight: .bold)
                textField.addTarget(self, action: #selector(TitleTextHelper.textFieldDidChange(_:)), for: UIControl.Event.editingChanged)
                if self.isFirstResponder {
                    
                    if self.firstAppear {
                        self.value = ""
                        textField.becomeFirstResponder()
                        self.firstAppear = false
                    }
                    
                }

            }
            .keyboardType(.numberPad)
            .titleStyle()
            .foregroundColor(Color.clear)
            .accentColor(Color.clear)
            
        }.padding(7)
    }
}
