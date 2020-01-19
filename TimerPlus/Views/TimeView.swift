//
//  TimeView.swift
//  TimerPlus
//
//  Created by Alexey Primechaev on 1/19/20.
//  Copyright © 2020 Alexey Primechaev. All rights reserved.
//

import SwiftUI

struct TimeView: View {
    
    @Binding var time: NSNumber?
    
    @Binding var precisionSetting: String?
    
    @State var title = String()
    
    @State var value = String()
    
    var update: () -> ()?
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            HStack(alignment: .bottom, spacing: 5) {
                ZStack(alignment: .bottomLeading) {
                    Text("\((time as! TimeInterval).stringFromTimeInterval(precisionSetting: precisionSetting ?? "Off"))")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .animation(nil)
                    if ((time as! TimeInterval).stringFromTimeInterval(precisionSetting: precisionSetting ?? "Off").count == 8) {
                        Text("88:88:88")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(Color.primary)
                        .opacity(0)
                    } else if ((time as! TimeInterval).stringFromTimeInterval(precisionSetting: precisionSetting ?? "Off").count == 5) {
                        Text("88:88")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(Color.primary)
                        .opacity(0)
                    } else {
                        Text("88:88:88.88")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(Color.primary)
                        .opacity(0)
                    }
                    
                }
                Text(title)
                .font(.headline)
                .fontWeight(.semibold)
                .padding(.bottom, 5)
                .opacity(0.5)
                .animation(nil)
            }
            if(title == "Total") {
                    TextField("", text: $value) {
                        self.time = self.value.stringToNSNumber()
                        self.update()
                    }
                    .introspectTextField { textField in
                        textField.font = UIFont(name: "AppleColorEmoji", size: 34)
                        textField.font = .systemFont(ofSize: 34, weight: .bold)
                        textField.addTarget(self, action: #selector(TextViewHelper.textFieldDidChange(_:)), for: UIControl.Event.editingChanged)
                    }
                    .keyboardType(.numbersAndPunctuation)
                    .font(.system(size: 34, weight: .bold))
                    .opacity(1)
                    .accentColor(Color.secondary)
                    .foregroundColor(Color.red)
            }
            
        }.padding(7)
    }
}
