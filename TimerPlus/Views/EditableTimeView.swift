//
//  EditableTimeView.swift
//  TimerPlus
//
//  Created by Alexey Primechaev on 1/20/20.
//  Copyright © 2020 Alexey Primechaev. All rights reserved.
//

import SwiftUI

struct EditableTimeView: View {
    
    @Binding var time: NSNumber?
    
    @State var title = String()
    
    @State var value = ""
    
    @State var isFirstResponder = false
    
    var update: () -> ()
    
    
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            HStack(alignment: .bottom, spacing: 5) {
                Text(value.count == 0 ? "00:00": value.stringToTime())
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .animation(nil)
                    .onAppear() {
                        self.value = ((self.time?.doubleValue ?? 0) as TimeInterval).stringFromNumber()
                        print("value:\(self.value)")

                }
                Text(title)
                .font(.headline)
                .fontWeight(.semibold)
                .padding(.bottom, 5)
                .opacity(0.5)
                .animation(nil)
            }
            
            TextField("00:00", text: $value, onEditingChanged: { _ in
              print(self.$value)
            }) {
                if(self.value == "") {
                    self.value = ((self.time?.doubleValue ?? 0) as TimeInterval).stringFromNumber()
                }
                self.time = self.value.calculateTime() as NSNumber
                self.value = ((self.time?.doubleValue ?? 0) as TimeInterval).stringFromNumber()
                self.update()
            }
            .introspectTextField { textField in
                textField.font = UIFont(name: "AppleColorEmoji", size: 34)
                textField.font = .systemFont(ofSize: 34, weight: .bold)
                textField.addTarget(self, action: #selector(TitleTextHelper.textFieldDidChange(_:)), for: UIControl.Event.editingChanged)
                if (self.isFirstResponder) {
                    textField.becomeFirstResponder()
                }

            }
            .font(.system(size: 34, weight: .bold))
            .opacity(1)
            .foregroundColor(Color.clear)
            .accentColor(Color.clear)
            
        }.padding(7)
    }
}
