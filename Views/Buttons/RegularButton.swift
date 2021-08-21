//
//  RegularButton.swift
//  TimerPlus
//
//  Created by Alexey Primechaev on 2/23/20.
//  Copyright © 2020 Alexey Primechaev. All rights reserved.
//

import SwiftUI


struct LoadingRegularButton: View {
    
    @State var title = LocalizedStringKey("")
    @State var icon = "arrow.clockwise"
    
    @State var isDestructive = false
    @State var isFlipped = false
    
    @State var supportsLoading = false
    @Binding var hasFinishedLoading: Bool
    
    var action: () -> Void
    
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
                if isFlipped {
                    Label {
                        
                        Image(systemName: icon).font(.headline)
                    } icon: {
                        Text(title).fontSize(.smallTitle)
                    }
                    .padding(.vertical, 14)
                    .padding(.horizontal, 7)
                } else {
                Label {
                    Text(title).fontSize(.smallTitle)
                } icon: {
                    Image(systemName: icon).font(.headline)
                }
                .padding(.vertical, 14)
                .padding(.horizontal, 7)
                }
                
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

struct RegularButton: View {
    
    @State var title = LocalizedStringKey("")
    @State var icon = "arrow.clockwise"
    
    @State var isDestructive = false
    @State var isFlipped = false
    
    @State var supportsLoading = false
    
    @EnvironmentObject var settings: Settings
    
    var action: () -> Void
    
    
    init(title: LocalizedStringKey, icon: String, isDestructive: Bool = false, action: @escaping () -> Void) {
        self.title = title
        self.icon = icon
        self.isDestructive = isDestructive
        self.supportsLoading = false
        self.action = action
    }
    
    init(title: LocalizedStringKey, icon: String, isDestructive: Bool = false, isFlipped: Bool, action: @escaping () -> Void) {
        self.title = title
        self.icon = icon
        self.isDestructive = isDestructive
        self.supportsLoading = false
        self.isFlipped = isFlipped
        self.action = action
    }
    
    
    var body: some View {
        
        
        Button {
            self.action()
        } label: {
                if isFlipped {
                    Label {
                        
                        Image(systemName: icon).font(.headline)
                    } icon: {
                        Text(title).fontSize(.smallTitle)
                    }
                    .padding(.vertical, 14)
                    .padding(.horizontal, 7)
                } else {
                Label {
                    Text(title).fontSize(.smallTitle)
                } icon: {
                    Image(systemName: icon).font(.headline)
                }
                .padding(.vertical, 14)
                .padding(.horizontal, 7)
                }
        }
        .foregroundColor(isDestructive ? .red : nil)
        .buttonStyle(RegularButtonStyle())
        .saturation(settings.isMonochrome ? 0 : 1)
    }
}



