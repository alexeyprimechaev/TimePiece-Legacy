//
//  PropertyView.swift
//  TimerPlus
//
//  Created by Alexey Primechaev on 1/16/20.
//  Copyright © 2020 Alexey Primechaev. All rights reserved.
//

import SwiftUI
import Introspect

struct PropertyView: View {
    
    @State var title = String()
    
    @State var value = String()
        
    @ObservedObject var timer = TimerPlus()
        
    var body: some View {
        ZStack(alignment: .bottomLeading) {
            HStack(alignment: .bottom, spacing: 7) {
                if(title == "Title") {
                    Text(value)
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .opacity(1)
                    
                } else if (title == "Created at") {
                    Text(TimerPlus.dateFormatter.string(from: timer.createdAt ?? Date()))
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .opacity(1)
                } else if (title == "Left"){
                    Text("\((self.timer.timeFinished ?? Date()).timeIntervalSince(timer.timeStarted ?? Date()).stringFromTimeInterval(precisionSetting: self.timer.precisionSetting ?? "Off"))")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .opacity(1)
                } else {
                    Text("\((self.timer.totalTime as! TimeInterval).stringFromTimeInterval(precisionSetting: self.timer.precisionSetting ?? "Off"))")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .opacity(1)
                }
                Text(title)
                    .font(.headline)
                    .fontWeight(.semibold)
                    .padding(.bottom, 5)
                    .opacity(0.5)
            }
            if(title == "Title") {
                    TextField("", text: $value) {
                        self.timer.title = self.value
                    }
                    .onAppear() {
                        self.value = self.timer.title ?? "Nil"
                    }
                    .introspectTextField { textField in
                        textField.font = UIFont(name: "AppleColorEmoji", size: 34)
                        textField.font = .systemFont(ofSize: 34, weight: .bold)
                        textField.addTarget(self, action: #selector(TextViewHelper.textFieldDidChange(_:)), for: UIControl.Event.editingChanged)

                    }
                    .font(.system(size: 34, weight: .bold))
                    .opacity(1)
                    .foregroundColor(Color.clear)
                    .accentColor(Color.secondary)
            }
            
            
        }
    .padding(7)
    
    }
}

class TextViewHelper {
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        textField.font = UIFont(name: "AppleColorEmoji", size: 34)
        textField.font = .systemFont(ofSize: 34, weight: .bold)
    }
}

