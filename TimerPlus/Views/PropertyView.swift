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
                if title == "Title" {
                    Text(timer.title)
                        .titleStyle()
                    
                } else if title == "Created at" {
                    Text(TimerPlus.dateFormatter.string(from: timer.createdAt))
                        .titleStyle()
                } else if title == "Left" {
                    Text(timer.timeFinished.timeIntervalSince(timer.timeStarted).stringFromTimeInterval(precisionSetting: timer.precisionSetting))
                        .titleStyle()
                } else {
                    Text((timer.totalTime).stringFromTimeInterval(precisionSetting: timer.precisionSetting))
                        .titleStyle()
                }
                Text(title)
                    .smallTitleStyle()
                    .padding(.bottom, 5)
                    .opacity(0.5)
            }
            if title == "Title" {
                TextField("", text: $timer.title)
                    .introspectTextField { textField in
                        textField.font = UIFont(name: "AppleColorEmoji", size: 34)
                        textField.font = .systemFont(ofSize: 34, weight: .bold)
                        textField.addTarget(self, action: #selector(TitleTextHelper.textFieldDidChange(_:)), for: UIControl.Event.editingChanged)

                    }
                    .titleStyle()
                    .foregroundColor(Color.clear)
                    .accentColor(Color.primary)
            }
            
            
        }
    .padding(7)
    
    }
}

class TitleTextHelper {
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        textField.font = UIFont(name: "AppleColorEmoji", size: 34)
        textField.font = .systemFont(ofSize: 34, weight: .bold)
    }
    
}


