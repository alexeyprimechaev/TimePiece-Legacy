//
//  RegularButton.swift
//  TimerPlus
//
//  Created by Alexey Primechaev on 2/23/20.
//  Copyright © 2020 Alexey Primechaev. All rights reserved.
//

import SwiftUI

struct RegularButton: View {
    
    @State var title = LocalizedStringKey("")
    @State var icon = "arrow.clockwise"
    
    @State var isDestructive = false
    
    @State var supportsLoading = false
    @Binding var hasFinishedLoading: Bool
    
    var action: () -> Void
    
    
    init(title: LocalizedStringKey, icon: String, isDestructive: Bool = false, action: @escaping () -> Void) {
        self.title = title
        self.icon = icon
        self.isDestructive = isDestructive
        self.supportsLoading = false
        self._hasFinishedLoading = Binding.constant(true)
        self.action = action
    }
    
    init(title: LocalizedStringKey, icon: String, isDestructive: Bool = false, hasFinishedLoading: Binding<Bool>, action: @escaping () -> Void) {
        self.title = title
        self.icon = icon
        self.isDestructive = isDestructive
        self.supportsLoading = true
        self._hasFinishedLoading = hasFinishedLoading
        self.action = action
    }
    
    var body: some View {
        
        Button {
            self.action()
        } label: {
            if hasFinishedLoading {
                Label {
                    Text(title).fontSize(.smallTitle)
                } icon: {
                    Image(systemName: icon).font(.headline)
                }
                .padding(.vertical, 14)
                .padding(.horizontal, 7)
            } else {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle())
                    .padding(.horizontal, 7)
            }
        }
        .foregroundColor(isDestructive ? .red : .primary)
        .buttonStyle(RegularButtonStyle())
    }
}

