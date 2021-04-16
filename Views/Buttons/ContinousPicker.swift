//
//  SliderButton.swift
//  TimePiece (iOS)
//
//  Created by Alexey Primechaev on 1/3/21.
//  Copyright © 2021 Alexey Primechaev. All rights reserved.
//

import SwiftUI

struct ContinousPicker: View {
    
    @State private var floatValue: Float = 0.20
    @State private var startFloatValue: Float = 0.35
    
    @State private var index = Int()
    
    
    @State var values = [String]()
    @Binding var controlledValue: String
    @State private var floatValues = [Float]()
    
    @State var selectedValue = 3
    
    @State var isContinous = false
    
    @State var width: CGFloat = 30
    
    
    var body: some View {
        
        Button {
            
            if isContinous {
                
                print("here")
                var smallestDist: Float = 1
                var index: Int = 1
                
                for i in 0...values.count-1 {
                    if abs(floatValues[i] - self.floatValue) < smallestDist {
                        smallestDist = abs(floatValues[i] - self.floatValue)
                        index = i
                    }
                }
                
                self.index = index
                self.floatValue = floatValues[self.index]
                startFloatValue = self.floatValue
                
                print(self.index)
                print(self.floatValue)
                
                isContinous = false
                
                if self.index < values.count - 1 {
                    self.index += 1
                    floatValue = floatValues[self.index]
                    floatValue = floatValues[self.index]
                } else {
                    self.index = 0
                    floatValue = floatValues[self.index]
                    startFloatValue = floatValues[self.index]
                }
                
            } else {
                print("there")
                if index < values.count - 1 {
                    index += 1
                    floatValue = floatValues[index]
                    startFloatValue = floatValues[index]
                } else {
                    index = 0
                    floatValue = floatValues[index]
                    startFloatValue = floatValues[index]
                }
            }
            
        } label: {
            
            HStack(alignment: .bottom, spacing: 7) {
                    HStack(spacing: 0) {
                        Rectangle().foregroundColor(.primary).frame(width: width*CGFloat(floatValue), height: 40).opacity(0.5)
                        Rectangle().foregroundColor(.primary).frame(width: width*CGFloat(1-floatValue), height: 40).opacity(0.35)
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
                        Text(controlledValue).fontSize(.smallTitle).padding(.bottom, 5).animation(nil)
                    } icon: {
                        Image(systemName: "rays").font(.headline)
                    }
                    
                    
                
            }
            .padding(7)
            .gesture(DragGesture(minimumDistance: 1, coordinateSpace: .local)
                        .onChanged { newValue in
                            isContinous = true
                            let delta = Float(newValue.translation.width/width)
                            floatValue = min(max(0, startFloatValue + delta), 1)
                        }
                        
                        .onEnded { endValue in
                            startFloatValue = floatValue
                        }
            )
            
            .onChange(of: floatValue) { newValue in
                for i in 0...floatValues.count-1 {
                    if newValue == floatValues[i] {
                        regularHaptic()
                    }
                    if newValue >= floatValues[i] {
                        controlledValue = values[i]
                    }
                }
            }
            
            
            
        }
        
        
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
            print("values.count")
            print(values.count)
            let increment = Float(1.0/Float(values.count))
            print(increment)
            print(values.count)
            
            for i in 0...values.count-1 {
                floatValues.append(Float(i)*increment)
                print("bebeb")
                print(floatValues)
            }
            
            floatValue = floatValues[index]
        }
        .buttonStyle(TitleButtonStyle())
        
        
        
        
        
        
        
        
        
    }
}
