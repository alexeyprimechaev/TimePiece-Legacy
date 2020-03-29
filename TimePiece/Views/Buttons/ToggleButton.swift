//
//  ToggleButton.swift
//  TimerPlus
//
//  Created by Alexey Primechaev on 2/23/20.
//  Copyright © 2020 Alexey Primechaev. All rights reserved.
//

import SwiftUI

struct ToggleButton: View {
        
    //MARK: - Properties
    @State var title = String()
    @State var trueTitle = String()
    @State var falseTitle = String()
    
    @Binding var value: Bool
        
    //MARK: - View
    var body: some View {
            
            Button(action:
            //MARK: Action
            {
                self.value.toggle()
            })
                
        
            //MARK: Layout
            {
                HStack(alignment: .bottom, spacing: 7) {
                    Text(title)
                        .title()
                        .opacity(trueTitle == "" && falseTitle == "" && value ? 1 : 0.5)
                    Text(trueTitle)
                        .padding(.bottom, 5)
                        .opacity(value ? 1 : 0.5)
                        .smallTitle()
                    Text(falseTitle)
                        .padding(.bottom, 5)
                        .opacity(value ? 0.5 : 1)
                        .smallTitle()
                    
                }
            }
                
                
            //MARK: Styling
            .buttonStyle(RegularButtonStyle())
            .padding(7)
        }
    }


