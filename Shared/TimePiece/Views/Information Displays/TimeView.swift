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
    
    @State var isProtected = false
    
    
    @State var seconds = ""
    @State var minutes = ""
    @State var hours = ""
    
    var body: some View {
        VStack() {
            ZStack(alignment: .topLeading) {
                HStack(spacing: 0) {
                    Text(hours)
                        .frame(width:46, alignment: .topTrailing)
                        .opacity(keyboardMode == 1 || keyboardMode == 0 ? 1 : 0.5)

                    Dots()
                    Text(minutes)
                        .frame(width:46, alignment: .topTrailing)
                        .opacity(keyboardMode == 2 || keyboardMode == 0 ? 1 : 0.5)
                    Dots()
                    Text(seconds)
                        .frame(width:46, alignment: .topTrailing)
                        .opacity(keyboardMode == 3 || keyboardMode == 0 ? 1 : 0.5)
                }.title().padding(7)
                .overlay(
                    TextField("", text: $string) {
                        fixNumbers()
                    }
                        .introspectTextField { textField in
                            self.textField = textField

                        }
                        .scaleEffect(0.01)
                        .frame(width: 1, height: 1)
                        .accentColor(.clear)
                        .foregroundColor(.clear)
                        .opacity(0)
                        .onTapGesture {
                            keyboardMode = 0
                        }
                        .onChange(of: string) { newValue in
                            switch keyboardMode {
                            case 1:
                                if string.count > 2 {
                                    if isProtected {
                                        string = String(newValue.suffix(1))
                                        hours = string
                                        isProtected = false
                                    } else {
                                        string = String(newValue.suffix(2))
                                        hours = string
                                    }
                                } else {
                                    hours = string
                                }
                                timeString = hours + minutes + seconds
                            case 2:
                                if string.count > 2 {
                                    if isProtected {
                                        string = String(newValue.suffix(1))
                                        minutes = string
                                        isProtected = false
                                    } else {
                                        string = String(newValue.suffix(2))
                                        minutes = string
                                    }
                                } else {
                                    minutes = string
                                }
                                timeString = hours + minutes + seconds
                            case 3:
                                if string.count > 2 {
                                    if isProtected {
                                        string = String(newValue.suffix(1))
                                        seconds = string
                                        isProtected = false
                                    } else {
                                        string = String(newValue.suffix(2))
                                        seconds = string
                                    }
                                } else {
                                    seconds = string
                                }
                                timeString = hours + minutes + seconds
                            default:
                                if newValue.count > 6 {
                                    if isProtected {
                                        string = String(newValue.suffix(1))
                                        isProtected = false
                                    } else {
                                        string = String(string.suffix(6))
                                    }
                                    timeString = string
                                } else {
                                    timeString = string
                                }
                                switch string.count {
                                case 1,2:
                                    seconds = string
                                    minutes = ""
                                    hours = ""
                                case 3:
                                    seconds = String(string.suffix(2))
                                    minutes = String(string.prefix(1))
                                    hours = ""
                                case 4:
                                    seconds = String(string.suffix(2))
                                    minutes = String(string.prefix(2))
                                    hours = ""
                                case 5:
                                    seconds = String(string.suffix(2))
                                    minutes = String(string.prefix(3).suffix(2))
                                    hours = String(string.prefix(1))
                                
                                default:
                                    seconds = String(string.suffix(2))
                                    minutes = String(string.prefix(4).suffix(2))
                                    hours = String(string.prefix(2))
                                }
                            }
                            
                            
                            
                            
                            

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
                        if keyboardMode == 1 {
                            fixNumbers()
                            string = timeString
                            keyboardMode = 0
                        } else {
                            string = hours
                            if textField.isEditing {
                                keyboardMode = 1
                                fixNumbers()
                            } else {
                                fixNumbers()
                                string = timeString
                                keyboardMode = 0
                            }
                        }
                        
                        isProtected = true
                        textField.becomeFirstResponder()
                        
                    }) {
                        Rectangle().frame(width: 54, height: 46).opacity(0)
                    }
                    Button(action: {
                        if keyboardMode == 2 {
                            fixNumbers()
                            string = timeString
                            keyboardMode = 0
                        } else {
                            string = minutes
                            if textField.isEditing {
                                keyboardMode = 2
                                fixNumbers()
                            } else {
                                fixNumbers()
                                string = timeString
                                keyboardMode = 0
                            }
                        }
                        
                        isProtected = true
                        textField.becomeFirstResponder()
                    }) {
                        Rectangle().frame(width: 54, height: 46).opacity(0)
                    }
                    Button(action: {
                        if keyboardMode == 3 {
                            fixNumbers()
                            string = timeString
                            keyboardMode = 0
                        } else {
                            string = seconds
                            if textField.isEditing {
                                keyboardMode = 3
                                fixNumbers()
                            } else {
                                fixNumbers()
                                string = timeString
                                keyboardMode = 0
                            }
                        }
                        isProtected = true
                        textField.becomeFirstResponder()
                    }) {
                        Rectangle().frame(width: 54, height: 46).opacity(0)
                    }
                }
            }
            
            Text("timeString: \(timeString)")
            Text("hours: \(hours)")
            Text("minutes: \(minutes)")
            Text("seconds: \(seconds)")
            Text("string: \(string)")
            Text("keyboardMode: \(keyboardMode)")
            Text("isProtected: \(isProtected.description)")
            
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
        timeString = hours + minutes + seconds
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
