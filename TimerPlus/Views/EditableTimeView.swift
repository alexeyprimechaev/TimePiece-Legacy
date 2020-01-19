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
    
    var update: () -> ()
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            HStack(alignment: .bottom, spacing: 5) {
                Text(value.calculateTime().stringFromTimeInterval(precisionSetting: "Off"))
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .animation(nil)
                    .onAppear() {
//                        print("appear")
//                        print(self.time?.intValue)
                        self.value = ((self.time?.doubleValue ?? 0) as TimeInterval).stringFromNumber()
                        print("value:\(self.value)")
//                        print(self.value)
//                        print(self.value.calculateTime())
//                        print(self.value.calculateTime().stringFromTimeInterval(precisionSetting: "Off"))
                }
                Text(title)
                .font(.headline)
                .fontWeight(.semibold)
                .padding(.bottom, 5)
                .opacity(0.5)
                .animation(nil)
            }
            
            TextField("", text: $value, onEditingChanged: { (editing) in
                if editing {
                    self.$value.wrappedValue = ""
                    self.opacity(0.5)
                }
            }) {
                print("enter")
                print(self.value.calculateTime())
                self.time = self.value.calculateTime() as NSNumber
                self.update()
            }
            .introspectTextField { textField in
                textField.font = UIFont(name: "AppleColorEmoji", size: 34)
                textField.font = .systemFont(ofSize: 34, weight: .bold)
                textField.addTarget(self, action: #selector(TitleTextHelper.textFieldDidChange(_:)), for: UIControl.Event.editingChanged)

            }
            .font(.system(size: 34, weight: .bold))
            .opacity(1)
            .foregroundColor(Color.clear)
            .accentColor(Color.clear)
            
        }.padding(7)
    }
}
