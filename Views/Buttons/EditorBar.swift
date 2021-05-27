//
//  EditorBar.swift
//  TimePiece (iOS)
//
//  Created by Alexey Primechaev on 9/19/20.
//  Copyright © 2020 Alexey Primechaev. All rights reserved.
//

import SwiftUI


struct EditorBar<Content:View>: View {
    
    
    
    
    init(titleField: Binding<UITextField>, timeField: Binding<UITextField>, titleFocused: Binding<Bool>, timeFocused: Binding<Bool>, showSwitcher: Binding<Bool>, @ViewBuilder button: @escaping () -> Content) {
        self._titleField = titleField
        self._timeField = timeField
        self._titleFocused = titleFocused
        self._timeFocused = timeFocused
        self._showSwitcher = showSwitcher
        self.button = button()
    }
    
    @Binding var titleField: UITextField
    @Binding var timeField: UITextField
    
    @Binding var titleFocused: Bool
    @Binding var timeFocused: Bool
    
    @Binding var showSwitcher: Bool
    
    let button: Content
    
    
    var body: some View {
        VStack(spacing: 0) {
            Divider()
            HStack {
                if !showSwitcher {
                    Button {
                        if timeFocused {
                            titleField.becomeFirstResponder()
                        } else {
                            timeField.becomeFirstResponder()
                        }
                        
                    } label: {
                        Label {
                            Text(timeFocused ? "Edit Title" : "Edit Time").fontSize(.smallTitle)
                        } icon: {
                            Image(systemName: timeFocused ? "chevron.up" : "chevron.down").font(.headline)
                        }.padding(14)
                    }
                    Spacer()
                } else {
                    
                }
                
                
                
                
                button
            }.padding(.horizontal, 14).foregroundColor(.primary)
        }
        
    }
}

