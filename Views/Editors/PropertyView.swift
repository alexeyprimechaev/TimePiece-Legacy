//
//  TitleEditor.swift
//  TimerPlus
//
//  Created by Alexey Primechaev on 1/16/20.
//  Copyright © 2020 Alexey Primechaev. All rights reserved.
//

import SwiftUI
import Introspect

struct TitleEditor: View {
    
    @State var title = LocalizedStringKey("")
    
    @State var value = String()
    
    @State var becomeFirstResponder = false
    
    @ObservedObject var timeItem = TimeItem()
    
    @Binding var textField: UITextField
    
    @Binding var isFocused: Bool
    
    var body: some View {
        ZStack(alignment: .bottomLeading) {
            HStack(alignment: .bottom, spacing: 7) {
                if title == Strings.title {
                    Text(timeItem.title.isEmpty ? timeItem.isStopwatch ? "Stopwatch ⏱" : Strings.timer : LocalizedStringKey(timeItem.title))
                        .fontSize(.title)
                        .opacity(timeItem.title.count == 0 ? 0.5 : 1)
                    
                } else if title == Strings.left {
                    Text(timeItem.timeFinished.timeIntervalSince(timeItem.timeStarted).stringFromTimeInterval(precisionSetting: timeItem.precisionSetting))
                        .fontSize(.title)
                } else {
                    Text((timeItem.totalTime).stringFromTimeInterval(precisionSetting: timeItem.precisionSetting))
                        .fontSize(.title)
                }
                Text(title)
                    .fontSize(.smallTitle)
                    .padding(.bottom, 5)
                    .opacity(timeItem.title.count == 0 && title == Strings.title ? 1 : 0.5)
            }
            if title == Strings.title {
                TextField("", text: $timeItem.title) { (editingChanged) in
                    if editingChanged {
                        isFocused = true
                    } else {
                        isFocused = false
                    }
                }
                .introspectTextField { field in
                    if becomeFirstResponder {
                        field.becomeFirstResponder()
                    }
                    textField = field
                    textField.font = UIFont(name: "AppleColorEmoji", size: 34)
                    textField.font = .systemFont(ofSize: 34, weight: .bold)
                    textField.addTarget(self, action: #selector(TitleTextHelper.textFieldDidChange(_:)), for: UIControl.Event.editingChanged)
                    
                }
                .onChange(of: timeItem.title) { newValue in
                    try? timeItem.managedObjectContext?.save()
                }
                .fontSize(.title)
                .foregroundColor(Color.clear)
                .accentColor(Color.primary)
            }
            
            
        }
        .padding(7)
        .animation(nil)
        
    }
}

class TitleTextHelper {
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        textField.font = UIFont(name: "AppleColorEmoji", size: 34)
        textField.font = .systemFont(ofSize: 34, weight: .bold)
    }
    
}


