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
    
    
    @State var seconds = ""
    @State var minutes = ""
    @State var hours = ""
    
    var body: some View {
        VStack() {
            ZStack(alignment: .topLeading) {
                HStack(spacing: 0) {
                    Text(hours)
                        .frame(width:46, alignment: .topTrailing)
                        .opacity(keyboardMode == 1 ? 1 : 0.5)

                    Dots()
                    Text(minutes)
                        .frame(width:46, alignment: .topTrailing)
                        .opacity(keyboardMode == 2 ? 1 : 0.5)
                    Dots()
                    Text(seconds)
                        .frame(width:46, alignment: .topTrailing)
                        .opacity(keyboardMode == 3 ? 1 : 0.5)
                }.title()
                .overlay(
                    TextField("", text: $string) {
                        fixNumbers()
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
                                    hours = string
                                } else {
                                    hours = newValue
                                }
                                timeString = hours + minutes + seconds
                            case 2:
                                if newValue.count > 2 {
                                    string = String(newValue.suffix(2))
                                    minutes = string
                                } else {
                                    minutes = newValue
                                }
                                timeString = hours + minutes + seconds
                            case 3:
                                if newValue.count > 2 {
                                    string = String(newValue.suffix(2))
                                    seconds = string
                                } else {
                                    seconds = newValue
                                }
                                timeString = hours + minutes + seconds
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
                    .onAppear {
                        hours = String(timeString.prefix(2))
                        minutes = String(timeString.prefix(4).suffix(2))
                        seconds = String(timeString.suffix(2))
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
                        if textField.isEditing {
                            keyboardMode = 1
                            print(keyboardMode)
                            fixNumbers()
                            string = ""
                        } else {
                            keyboardMode = 0
                        }
                        textField.becomeFirstResponder()
                        
                    }) {
                        Rectangle().frame(width: 50, height: 36).opacity(0)
                    }
                    Button(action: {
                        if textField.isEditing {
                            keyboardMode = 2
                            fixNumbers()
                            print(keyboardMode)
                            string = ""
                        } else {
                            keyboardMode = 0
                        }
                        textField.becomeFirstResponder()
                    }) {
                        Rectangle().frame(width: 50, height: 36).opacity(0)
                    }
                    Button(action: {
                        if textField.isEditing {
                            keyboardMode = 3
                            fixNumbers()
                            print(keyboardMode)
                            string = ""
                        } else {
                            keyboardMode = 0
                        }
                        
                        textField.becomeFirstResponder()
                    }) {
                        Rectangle().frame(width: 50, height: 36).opacity(0)
                    }
                }
            }
            
            Text("timeString: \(timeString)")
            Text("hours: \(hours)")
            Text("minutes: \(minutes)")
            Text("seconds: \(seconds)")
            Text("string: \(string)")
            Text("keyboardMode: \(keyboardMode)")
            
        }
        
        
        
        
    }
    
    func fixNumbers() {
        while hours.count < 2 {
            hours = "0" + hours
        }
        while minutes.count < 2 {
            minutes = "0" + minutes
        }
        while seconds.count < 2 {
            seconds = "0" + seconds
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
