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
    @Binding var value: String
    @State var index = Int()
    
    //MARK: - View
    var body: some View {
        
        if values.count > 3 {
            Menu {
                ForEach(values, id: \.self) { value in
                    Button(NSLocalizedString(value, comment: "value")) {
                        self.value = value
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
                        Text(NSLocalizedString(value, comment: "value")).fontSize(.smallTitle)
                    } icon: {
                        Image(systemName: "ellipsis.circle").font(.headline)
                    }
                    
                    .padding(.bottom, 5)
                    
                }
            }.foregroundColor(.primary).padding(7)
        } else {
            Button {
                lightHaptic()
                if self.index < self.values.count - 1 {
                    self.index += 1
                    self.value = self.values[self.index]
                } else {
                    self.index = 0
                    self.value = self.values[self.index]
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
                            Text(NSLocalizedString(value, comment: "value"))
                                .fixedSize()
                                .padding(.bottom, 5)
                                .opacity(self.value == value ? 1 : 0.5)
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
                for i in 0...self.values.count-1 {
                    if self.value == self.values[i] {
                        self.index = i
                        break
                    }
                    if i == self.values.count-1 {
                        self.value = self.values[0]
                    }
                }
            }
        }
        
        
    }
}



