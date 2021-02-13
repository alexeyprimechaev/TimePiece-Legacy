//
//  TimeView.swift
//  TimePiece (iOS)
//
//  Created by Alexey Primechaev on 8/27/20.
//  Copyright © 2020 Alexey Primechaev. All rights reserved.
//

import SwiftUI

struct TimeEditor: View {
    
    //@Binding var time: TimeInterval
    
    @EnvironmentObject var settings: Settings
    
    @Binding var timeString: String
    @State var becomeFirstResponder = false
    @State var label = "Edit Time"
    
    @State private var keyboardMode: Int = 0
    
    @Binding var textField: UITextField
    
    @State private var string = ""
    
    @State private var isProtected = false
    
    @ScaledMetric(relativeTo: .largeTitle) var fieldWidth: CGFloat = 46
    @ScaledMetric(relativeTo: .largeTitle) var fieldWidthBold: CGFloat = 50
    @ScaledMetric var buttonWidth: CGFloat = 54
    
   
    @Binding var isFocused: Bool
    
    
    @State private var seconds = ""
    @State private var minutes = ""
    @State private var hours = ""
    
    var body: some View {
        
            ZStack(alignment: .topLeading) {
                Text("88").fontSize(.title).padding(7).opacity(0)
                HStack(alignment: .bottom, spacing: 7) {
                    HStack(spacing: 0) {
                        Text(hours)
                            .frame(width: isFocused ? settings.isBoldTextEnabled ? fieldWidthBold : fieldWidth : nil, alignment: .topTrailing)
                            .opacity(keyboardMode == 1 || keyboardMode == 0 ? 1 : 0.5)
                        Dots()
                        Text(minutes)
                            .frame(width: isFocused ? settings.isBoldTextEnabled ? fieldWidthBold : fieldWidth : nil, alignment: .topTrailing)
                            .opacity(keyboardMode == 2 || keyboardMode == 0 ? 1 : 0.5)
                        Dots()
                        Text(seconds)
                            .frame(width: isFocused ? settings.isBoldTextEnabled ? fieldWidthBold : fieldWidth : nil, alignment: .topTrailing)
                            .opacity(keyboardMode == 3 || keyboardMode == 0 ? 1 : 0.5)
                    }.fontSize(.title).frame(minHeight: 43).padding(7).fixedSize(horizontal: true, vertical: true)
                    .animation(.default, value: isFocused)
                    .overlay(
                        TextField("", text: $string) { editingChanged in
                            if editingChanged {
                                isFocused = true
                            } else {
                                isFocused = false
                                fixNumbers()
                            }
                        } onCommit: {
                            fixNumbers()
                        }
                            .introspectTextField { field in
                                textField = field
                                if becomeFirstResponder {
                                    textField.becomeFirstResponder()
                                    becomeFirstResponder = false
                                }

                            }
                            .scaleEffect(0.01)
                            .frame(width: 1, height: 1)
                            .accentColor(.clear)
                            .foregroundColor(.clear)
                            .opacity(0)
                            .onTapGesture {
                                keyboardMode = 0
                            }
                            .onChange(of: textField.isEditing) { newValue in
                                fixNumbers()
                                if newValue == false {
                                    keyboardMode = 0
                                }
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
                    .background(
                        RoundedRectangle(cornerRadius: 12, style: .continuous)
                            .foregroundColor(Color("button.gray")).overlay(
                                RoundedRectangle(cornerRadius: 12, style: .continuous)
                                    .stroke(Color.primary, lineWidth: 2)
                                    .foregroundColor(Color("button.gray"))
                                    .opacity(textField.isFirstResponder || isFocused ? 1 : 0))
                            )
                    Text(label).fontSize(.smallTitle).padding(.bottom, 13).opacity(isFocused ? 1 : 0.5)
                }.animation(.default, value: isFocused)
    //            .background(HStack(spacing: 0) {
    //                Text("00")
    //                    .frame(width:46, alignment: .topTrailing)
    //                Dots().opacity(0)
    //                Text("00")
    //                    .frame(width:46, alignment: .topTrailing)
    //                Dots().opacity(0)
    //                Text("00")
    //            }.opacity(timeString.count == 0 ? 0.5 : 0).fontSize(.title))
                HStack(spacing: 0) {
                    Button {
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
                    } label: {
                        Rectangle().frame(width: buttonWidth, height: 52).opacity(0)
                    }
                    Button {
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
                    } label: {
                        Rectangle().frame(width: buttonWidth, height: 52).opacity(0)
                    }
                    Button {
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
                    } label: {
                        Rectangle().frame(width: buttonWidth, height: 52).opacity(0)
                    }
                }
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
        print(fieldWidth)
    }
    
    
}

struct Dots: View {
    
    @State var isMilliseconds = false
    
    var body: some View {
        VStack(spacing: 6) {
            Circle().frame(width: 5, height: 5).opacity(isMilliseconds ? 0 : 1)
            Circle().frame(width: 5, height: 5).padding(.top, isMilliseconds ? 8 : 0)
        }.padding(.vertical, 8).padding(.horizontal, 1).transition(.opacity)
    }
}
