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
        
        Button(action:
        //MARK: Action
        {
            lightHaptic()
            if self.index < self.values.count - 1 {
                self.index += 1
                self.value = self.values[self.index]
            } else {
                self.index = 0
                self.value = self.values[self.index]
            }
        })
            
    
        //MARK: Layout
        {
            ASCollectionView(
            sections:
                [ASCollectionViewSection(id: 0) {
                    Text(title)
                        .title()
                        .lineLimit(1)
                        .opacity(0.5)
                    HStack(spacing: 7) {
                        ForEach(values, id: \.self) { value in
                            Text(NSLocalizedString(value, comment: "value"))
                                .padding(.bottom, 5)
                                .opacity(self.value == value ? 1 : 0.5)
                        }.smallTitle()
                    }
                    }])
            .layout {
                let fl = AlignedCollectionViewFlowLayout()
                fl.horizontalAlignment = .leading
                fl.verticalAlignment = .bottom
                fl.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
                fl.minimumInteritemSpacing = 7
                fl.minimumLineSpacing = 7
                fl.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
                return fl
            }
            .shrinkToContentSize(dimension: .vertical)

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
        .padding(7)
    }
}



