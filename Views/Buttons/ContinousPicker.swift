//
//  SliderButton.swift
//  TimePiece (iOS)
//
//  Created by Alexey Primechaev on 1/3/21.
//  Copyright © 2021 Alexey Primechaev. All rights reserved.
//

import SwiftUI

struct ContinousPicker: View {
    
    @State var value: Float = 0
    @State var startValue: Float = 0
    
    @State var values: [Float] = [0.15, 0.35, 0.5, 1]
    @State var valuesLabels: [Float: String] = [0.15:"5m", 0.35:"15m", 0.5:"30m", 1:"1h"]
    
    @State var selectedValue = 0
    
    @State var isContinous = true
    
    @State var width: CGFloat = 30
    
    var body: some View {
        
        Button {
//            isContinous = false
//            if selectedValue < values.count-1 {
//                selectedValue+=1
//            } else {
//                selectedValue = 0
//            }
//            value = values[selectedValue]
        } label: {
            
            HStack(alignment: .bottom, spacing: 7) {
                if isContinous {
                    HStack(spacing: 0) {
                        Rectangle().foregroundColor(.primary).frame(width: width*CGFloat(value), height: 40)
                        Rectangle().foregroundColor(.primary).frame(width: width*CGFloat(1-value), height: 40).opacity(0.5)
                    }.mask(
                        Text("Tap Me Every")
                            .fontSize(.title)
                            .fixedSize()
                            
                            .overlay(
                                GeometryReader { geometry in
                                    Spacer()
                                        .onAppear {
                                            print("fucko")
                                            print(geometry.size.width)
                                            width = geometry.size.width
                                        }
                                    
                                }
                            )
                    )
                    
                    Label {
                        if value < 0.15 {
                            Text("Off").fontSize(.smallTitle).padding(.bottom, 5)
                        } else if value < 0.30 {
                            Text("5m").fontSize(.smallTitle).padding(.bottom, 5)
                        } else if value < 0.45 {
                            Text("10m").fontSize(.smallTitle).padding(.bottom, 5)
                        } else if value < 0.60 {
                            Text("15m").fontSize(.smallTitle).padding(.bottom, 5)
                        } else if value < 0.75 {
                            Text("30m").fontSize(.smallTitle).padding(.bottom, 5)
                        } else if value < 0.9 {
                            Text("45m").fontSize(.smallTitle).padding(.bottom, 5)
                        } else {
                            Text("1h").fontSize(.smallTitle).padding(.bottom, 5)
                        }
                        //Text("\(Int(120*value))m").fontSize(.smallTitle).padding(.bottom, 5).fixedSize().animation(nil)
                    } icon: {
                        Image(systemName: "rays").font(.headline)
                    }
                    
                    
                } else {
//                    Text("Tap Me Every")
//                        .fontSize(.title)
//                        .lineLimit(1)
//                        .opacity(0.5)
//                        .padding(0)
//                        .fixedSize()
//                    HStack(spacing: 7) {
//                        ForEach(values, id: \.self) { value in
//                            Text(valuesLabels[value] ?? "Text")
//                                .fixedSize()
//                                .padding(.bottom, 5)
//                                .opacity(self.value == value ? 1 : 0.5)
//                                .lineLimit(1)
//                        }.fontSize(.smallTitle).fixedSize()
//                    }.fixedSize().padding(0)
                }
            }
            .padding(7)
            .gesture(DragGesture(minimumDistance: 1, coordinateSpace: .local)
                        
                        .onChanged { value in
                            isContinous = true
                            
                            let delta = Float(value.translation.width/width)
                            print("delta \(delta)")
                            print("value \(self.value)")
                            print("start value \(startValue)")
                            self.value = min(max(0, (startValue + delta)), 1)
                            print("newValue \(self.value)")
                            
                        }
                        
                        .onEnded { endValue in
                            startValue = min(max(0, Float(endValue.location.x/width)), 1)
                        }
            )
            
            
            
        }
        
        
        .onAppear {
            value = values[selectedValue]
        }
        .buttonStyle(TitleButtonStyle())
        
        
        
        
        
        
        
        
        
    }
}
