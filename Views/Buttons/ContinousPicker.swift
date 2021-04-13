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
    
    @State var index = 0
    
    @State var values: [Float] = [0.0, 0.20, 0.35, 0.50, 0.65, 0.8, 1]
    @State var valuesLabels: [Float: String] = [0.15:"5m", 0.35:"15m", 0.5:"30m", 1:"1h"]
    
    @State var selectedValue = 0
    
    @State var isContinous = false
    
    @State var width: CGFloat = 30
    
    
    var body: some View {
        
        Button {
            
            if isContinous {
                
                print("here")
                var smallestDist: Float = 1
                var index: Int = 1
                
                for i in 0...values.count-1 {
                    if abs(values[i] - self.value) < smallestDist {
                        smallestDist = abs(values[i] - self.value)
                        index = i
                    }
                }
                
                self.index = index
                self.value = values[self.index]
                startValue = self.value
                
                print(self.index)
                print(self.value)
                
                isContinous = false
                
                if self.index < values.count - 1 {
                    self.index += 1
                    value = values[self.index]
                    startValue = values[self.index]
                } else {
                    self.index = 0
                    value = values[self.index]
                    startValue = values[self.index]
                }
                
            } else {
                print("there")
                if index < values.count - 1 {
                    index += 1
                    value = values[index]
                    startValue = values[index]
                } else {
                    index = 0
                    value = values[index]
                    startValue = values[index]
                }
            }
            
        } label: {
            
            HStack(alignment: .bottom, spacing: 7) {
                    HStack(spacing: 0) {
                        Rectangle().foregroundColor(.primary).frame(width: width*CGFloat(value), height: 40).opacity(0.5)
                        Rectangle().foregroundColor(.primary).frame(width: width*CGFloat(1-value), height: 40).opacity(0.35)
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
                    
                    
                
            }
            .padding(7)
            .gesture(DragGesture(minimumDistance: 1, coordinateSpace: .local)
                        
                        .onChanged { newValue in
                            isContinous = true
                            let delta = Float(newValue.translation.width/width)
                            value = min(max(0, startValue + delta), 1)
                        }
                        
                        .onEnded { endValue in
                            startValue = value
                        }
            )
            
            
            
        }
        
        
        .onAppear {
            value = values[selectedValue]
        }
        .buttonStyle(TitleButtonStyle())
        
        
        
        
        
        
        
        
        
    }
}
