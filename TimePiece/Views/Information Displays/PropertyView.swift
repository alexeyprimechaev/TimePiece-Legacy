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
        
    @ObservedObject var timer = TimerItem()
        
    var body: some View {
        ZStack(alignment: .bottomLeading) {
            HStack(alignment: .bottom, spacing: 7) {
                if title == "Title" {
                    Text(timer.title.count == 0 ? "Timer ⏱": timer.title)
                        .title()
                        .opacity(timer.title.count == 0 ? 0.6 : 1)
                    
                } else if title == "Created at" {
                    Text(TimerItem.createdAtFormatter.string(from: timer.createdAt))
                        .title()
                } else if title == "Left" {
                    Text(timer.timeFinished.timeIntervalSince(timer.timeStarted).stringFromTimeInterval(precisionSetting: timer.precisionSetting))
                        .title()
                } else {
                    Text((timer.totalTime).stringFromTimeInterval(precisionSetting: timer.precisionSetting))
                        .title()
                }
                Text(title)
                    .smallTitle()
                    .padding(.bottom, 5)
                    .opacity(timer.title.count == 0 && title == "Title" ? 1 : 0.5)
            }
            if title == "Title" {
                TextField("", text: $timer.title)
                    .introspectTextField { textField in
                        textField.font = UIFont(name: "AppleColorEmoji", size: 34)
                        textField.font = .systemFont(ofSize: 34, weight: .bold)
                        textField.addTarget(self, action: #selector(TitleTextHelper.textFieldDidChange(_:)), for: UIControl.Event.editingChanged)

                    }
                    .title()
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


