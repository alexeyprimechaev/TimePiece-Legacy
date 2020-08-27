//
//  TimeView.swift
//  TimePiece (iOS)
//
//  Created by Alexey Primechaev on 8/27/20.
//  Copyright © 2020 Alexey Primechaev. All rights reserved.
//

import SwiftUI

struct TimeView: View {
    
    //@Binding var time: TimeInterval
    
    @Binding var timeString: String
    
    @State var keyboardMode: Int = 0
    
    @State var textField = UITextField()
    
    @State var string = ""
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            HStack(spacing: 0) {
                Text(timeString.count > 4 ? timeString.count > 5 ? timeString.prefix(2) : timeString.prefix(1) : "")
                    .frame(width:46, alignment: .topTrailing)
                    .opacity(keyboardMode == 1 ? 1 : 0.5)

                Dots()
                Text(timeString.count > 2 ? timeString.count > 3 ? timeString.suffix(4).prefix(2) : timeString.suffix(3).prefix(1) : "")
                    .frame(width:46, alignment: .topTrailing)
                    .opacity(keyboardMode == 2 ? 1 : 0.5)
                Dots()
                Text(timeString.count > 1 ? timeString.suffix(2) : timeString.suffix(1))
                    .frame(width:46, alignment: .topTrailing)
                    .opacity(keyboardMode == 3 ? 1 : 0.5)
            }.title()
            .overlay(
                TextField("", text: $string) {
                    while timeString.count < 6 {
                        timeString = "0" + timeString
                    }
                }
                    .introspectTextField { textField in
                        self.textField = textField

                    }
                    .title()
                    .accentColor(.clear)
                    .foregroundColor(.clear)
                    .onTapGesture {
                        timeString = ""
                    }
                    .onChange(of: string) { newValue in
                        
                        switch keyboardMode {
                        case 1:
                            if newValue.count > 2 {
                                string = String(newValue.suffix(2))
                                timeString = String(newValue.suffix(6))
                            } else {
                                timeString = newValue + timeString.suffix(4)
                            }
                        case 2:
                            if newValue.count > 2 {
                                string = String(newValue.suffix(2))
                                timeString = timeString.prefix(2) + newValue + timeString.suffix(2)
                            } else {
                                timeString = timeString.prefix(2) + newValue + timeString.suffix(2)
                            }
                        case 3:
                            if newValue.count > 2 {
                                string = String(newValue.suffix(2))
                                timeString = timeString.prefix(4) + newValue
                            } else {
                                timeString = timeString.prefix(4) + newValue
                            }
                        default:
                            if newValue.count > 6 {
                                timeString = String(newValue.suffix(6))
                            } else {
                                timeString = newValue
                            }
                        }
                        
                        
                        
                        print(string)
                        print(timeString)
                    }
                    .keyboardType(.numberPad)
                    
            )
//            .background(HStack(spacing: 0) {
//                Text("00")
//                    .frame(width:46, alignment: .topTrailing)
//                Dots().opacity(0)
//                Text("00")
//                    .frame(width:46, alignment: .topTrailing)
//                Dots().opacity(0)
//                Text("00")
//            }.opacity(timeString.count == 0 ? 0.5 : 0).title())
            HStack(spacing: 0) {
                Button(action: {
                    keyboardMode = 1
                    print(keyboardMode)
                    textField.becomeFirstResponder()
                }) {
                    Rectangle().frame(width: 50, height: 36).opacity(0)
                }
                Button(action: {
                    keyboardMode = 2
                    print(keyboardMode)
                    textField.becomeFirstResponder()
                }) {
                    Rectangle().frame(width: 50, height: 36).opacity(0)
                }
                Button(action: {
                    keyboardMode = 3
                    print(keyboardMode)
                    textField.becomeFirstResponder()
                }) {
                    Rectangle().frame(width: 50, height: 36).opacity(0)
                }
            }
        }
        
        
        
    }
    
}

fileprivate struct TimeSegment: View {
    
    
    var body: some View {
        VStack(spacing: 6) {
            Circle().frame(width: 5, height: 5)
            Circle().frame(width: 5, height: 5)
        }.padding(.vertical, 4).padding(.horizontal, 1)
    }
}


fileprivate struct Dots: View {
    var body: some View {
        VStack(spacing: 4) {
            Circle().frame(width: 5, height: 5)
            Circle().frame(width: 5, height: 5)
        }.padding(.vertical, 8).padding(.horizontal, 1)
    }
}
