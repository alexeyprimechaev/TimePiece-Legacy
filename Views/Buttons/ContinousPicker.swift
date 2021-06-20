//
//  SliderButton.swift
//  TimePiece (iOS)
//
//  Created by Alexey Primechaev on 1/3/21.
//  Copyright © 2021 Alexey Primechaev. All rights reserved.
//

import SwiftUI

struct ContinousPicker: View {
    
    @State var value: Float
    @State private var startValue: Float = 0.20
    
    @State private var index = Int()
    
    
    @State var presetValues: [Float]
        
    @State var isContinous = false
    
    @State var width: CGFloat = 30
    
    @State var increment: Float = 0
    
    @State var stoppedInteracting = false
    
    @State var delay = 2
    
    let timer = Timer.publish(every: 1.0, on: .main, in: .common).autoconnect()
    
    var body: some View {
        
        Button {
            
            stoppedInteracting = true
            delay = 3
            
            if isContinous {
                
                var smallestDist: Float = 1
                var index: Int = 1
                
                for i in 0...presetValues.count-1 {
                    if abs(presetValues[i] - self.value) < smallestDist {
                        smallestDist = abs(presetValues[i] - self.value)
                        index = i
                    }
                }
                
                self.index = index
                self.value = presetValues[self.index]
                startValue = self.value
                

                
                isContinous = false
                
                if self.index < presetValues.count - 1 {
                    self.index += 1
                    value = presetValues[self.index]
                    value = presetValues[self.index]
                } else {
                    self.index = 0
                    value = presetValues[self.index]
                    startValue = presetValues[self.index]
                }
                
            } else {
                if index < presetValues.count - 1 {
                    index += 1
                    value = presetValues[index]
                    startValue = presetValues[index]
                } else {
                    index = 0
                    value = presetValues[index]
                    startValue = presetValues[index]
                }
            }
            
        } label: {
            
            HStack(alignment: .bottom, spacing: 7) {
                    HStack(spacing: 0) {
                        Rectangle().foregroundColor(.primary).frame(width: width*CGFloat(value), height: 40).opacity(delay > 0 && stoppedInteracting == true ? 1 : 0.5)
                        Rectangle().foregroundColor(.primary).frame(width: width*CGFloat(1-value), height: 40).opacity(0.5)
                    }.mask(
                        Text("Tap Me Every")
                            .fontSize(.title)
                            .fixedSize()
                            
                            .overlay(
                                GeometryReader { geometry in
                                    Spacer()
                                        .onAppear {
                                            width = geometry.size.width
                                        }
                                    
                                }
                            )
                    )
                    
                    Label {
                        Text("\(Int(value*120))m").fontSize(.smallTitle).padding(.bottom, 5).animation(nil)
                    } icon: {
                        Image(systemName: "rays").font(.headline).rotationEffect(Angle(degrees: Double(value*360)))
                    }
                    
                    
                
            }
            .padding(7)
            .gesture(DragGesture(minimumDistance: 1, coordinateSpace: .local)
                        .onChanged { newValue in
                            stoppedInteracting = true
                            delay = 3
                            isContinous = true
                            let delta = Float(newValue.translation.width/width)
                            value = min(max(0, startValue + delta), 1)
                        }
                        
                        .onEnded { endValue in
                            stoppedInteracting = true
                            delay = 3
                            startValue = value
                        }
            )
            
            .onChange(of: value) { _ in
                
                //lightHaptic()
                increment = (value*120) - (value*120).truncatingRemainder(dividingBy: 10)
                
                for i in 0...presetValues.count-1 {
                    if (value*120) == (presetValues[i]*120) {
                        hardHaptic()
                    }
                    
                }
            }
            
            .onChange(of: increment) { _ in
                print(increment)
                if 8 < increment && increment < 118 {
                    lightHaptic()
                }
                
            }
            
            .onReceive(timer) { _ in
                if stoppedInteracting {
                    if delay > 0 {
                        delay -= 1
                    }
                    
                } else {
                    
                }
            }
            
            .onAppear {
                startValue = value
            }
            
            
            
        }
        
        
        
        .buttonStyle(TitleButtonStyle())
        
        
        
        
        
        
        
        
        
    }
}
