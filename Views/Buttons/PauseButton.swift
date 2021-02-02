//
//  PauseButton.swift
//  TimerPlus
//
//  Created by Alexey Primechaev on 1/13/20.
//  Copyright © 2020 Alexey Primechaev. All rights reserved.
//

import SwiftUI

struct PauseButton: View {
    
//MARK: - Properties
    
    
    
    //MARK: Dynamic Properties
    @State var color: Color
    @Binding var isPaused: Bool
    
    @EnvironmentObject var settings: Settings
    
    //MARK: Static Properties
    var offTitle = LocalizedStringKey("")
    var onTitle = LocalizedStringKey("")
    
    var offIcon = String()
    var onIcon = String()
    
    var onTap: () -> Void
    var offTap: () -> Void
    
//MARK: - View
    var body: some View {
        
        Button {
            if isPaused {
                onTap()
            } else {
                offTap()
            }
        } label: {
            ZStack(alignment: .center) {
                RoundedRectangle(cornerRadius: 8, style: .continuous)
                    .foregroundColor(Color("button.gray"))
                Label {
                    Text(isPaused ? offTitle : onTitle).fontSize(.smallTitle)
                } icon: {
                    Image(systemName: isPaused ? offIcon : onIcon).font(.headline).saturation(settings.isMonochrome ? 0 : 1)
                }
                .foregroundColor(color)
            }.frame(height: 52)
        }
        
        .buttonStyle(PrimaryButtonStyle())
        
    }
}

