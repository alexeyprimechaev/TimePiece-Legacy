//
//  PickerButton.swift
//  TimerPlus
//
//  Created by Alexey Primechaev on 1/15/20.
//  Copyright © 2020 Alexey Primechaev. All rights reserved.
//

import SwiftUI
import ASCollectionView

struct PickerButton: View {
    
    //MARK: - Properties
    @State var title = LocalizedStringKey("")
    @State var values = [String]()
    @Binding var controlledValue: String
    @State var index = Int()
    
    //MARK: - View
    var body: some View {
        
        if values.count > 3 {
            Menu {
                ForEach(values, id: \.self) { value in
                    Button(NSLocalizedString(value, comment: "value")) {
                        controlledValue = value
                    }
                }
            } label: {
                HStack(alignment: .bottom, spacing: 7) {
                    Text(title)
                        .fontSize(.title)
                        .lineLimit(1)
                        .opacity(0.5)
                        .padding(0)
                        .fixedSize()
                    Label {
                        Text(NSLocalizedString(controlledValue, comment: "value")).fontSize(.smallTitle)
                    } icon: {
                        Image(systemName: "ellipsis.circle").font(.headline)
                    }
                    
                    .padding(.bottom, 5)
                    
                }
            }.foregroundColor(.primary).padding(7)
        } else {
            Button {
                lightHaptic()
                if index < values.count - 1 {
                    index += 1
                    controlledValue = values[index]
                } else {
                    index = 0
                    controlledValue = values[index]
                }
            } label: {
                HStack(alignment: .bottom, spacing: 7) {
                    Text(title)
                        .fontSize(.title)
                        .lineLimit(1)
                        .opacity(0.5)
                        .padding(0)
                        .fixedSize()
                    HStack(spacing: 7) {
                        ForEach(values, id: \.self) { value in
                            Text(NSLocalizedString(controlledValue, comment: "value"))
                                .fixedSize()
                                .padding(.bottom, 5)
                                .opacity(controlledValue == value ? 1 : 0.5)
                                .lineLimit(1)
                        }.fontSize(.smallTitle).fixedSize()
                    }.fixedSize().padding(0)
                }
                .padding(7)
                .background(Color(.systemBackground))
            }

                
                
            //MARK: Styling
            .buttonStyle(RegularButtonStyle())
            
                
                
            //MARK: On Appear
            .onAppear {
                for i in 0...values.count-1 {
                    if controlledValue == values[i] {
                        index = i
                        break
                    }
                    if i == values.count-1 {
                        controlledValue = values[0]
                    }
                }
            }
        }
        
        
    }
}



