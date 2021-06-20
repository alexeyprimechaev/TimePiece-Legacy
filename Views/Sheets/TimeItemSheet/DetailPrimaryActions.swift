//
//  BottomActions.swift
//  TimePiece (iOS)
//
//  Created by Alexey Primechaev on 6/20/21.
//  Copyright © 2021 Alexey Primechaev. All rights reserved.
//

import SwiftUI

struct DetailPrimaryActions: View {
    
    @EnvironmentObject var settings: Settings
    
    @ObservedObject var timeItem: TimeItem
    
    @Binding var titleField: UITextField
    @Binding var timeField: UITextField
    
    @Binding var titleFocused: Bool
    @Binding var timeFocused: Bool
    
    @State var showingMakeReusableAlert = false
    
    var body: some View {
        if titleFocused || timeFocused {
            EditorBar(titleField: $titleField, timeField: $timeField, titleFocused: $titleFocused, timeFocused: $timeFocused, showSwitcher: $timeItem.isStopwatch) {
                if timeItem.isStopwatch {
                    Spacer()
                }
                Button {
                    titleField.resignFirstResponder()
                    timeField.resignFirstResponder()
                } label: {
                    Label {
                        Text("Done").fontSize(.smallTitle)
                    } icon: {
                        
                    }.padding(.horizontal, 14).padding(.vertical, 7).background(RoundedRectangle(cornerRadius: 8, style: .continuous)
                                                                                    .foregroundColor(Color("button.gray"))).padding(.vertical, 7)
                }
            }
        } else {
            HStack(spacing: 0) {
                Spacer().frame(width:28)
                if timeItem.isRunning {
                    if timeItem.isReusable {
                        PauseButton(color: Color.red, isPaused: $timeItem.isRunning, offTitle: timeItem.remainingTime == 0 ? Strings.reset : Strings.reset, onTitle: Strings.reset, offIcon: "stop.fill", onIcon: "stop.fill",
                                    onTap: {
                            timeItem.reset()
                        },
                                    offTap: {
                            timeItem.reset()
                        }
                        )
                            .disabled(timeItem.isRunning ? false : true)
                    } else {
                        PauseButton(color: Color.red, isPaused: $timeItem.isRunning, offTitle: timeItem.remainingTime == 0 ? Strings.reset : Strings.reset, onTitle: Strings.reset, offIcon: "stop.fill", onIcon: "stop.fill",
                                    onTap: {
                            showingMakeReusableAlert = true
                        },
                                    offTap: {
                            showingMakeReusableAlert = true
                        }
                        )
                            .disabled(timeItem.isRunning ? false : true)
                            .alert(isPresented: $showingMakeReusableAlert) {
                                Alert(title: Text("You can only reset Reusable Timers"), primaryButton: .default(Text("Make Reusable")) {
                                    
                                    withAnimation {
                                        
                                        if settings.isSubscribed {
                                            timeItem.makeReusable()
                                        } else {
                                            settings.showingSubscription = true
                                        }
                                    }
                                    
                                }, secondaryButton: .cancel())
                            }
                        
                            .fullScreenCover(isPresented: $settings.showingSubscription) {
                                SubscriptionSheet {
                                    settings.showingSubscription = false
                                }.environmentObject(settings)
                            }
                    }
                    Spacer().frame(width:14)
                }
                
                PauseButton(color: Color.primary, isPaused: $timeItem.isPaused, offTitle: timeItem.isRunning ? "Start" : timeItem.isStopwatch ? "Start Stopwatch" : "Start Timer", onTitle: Strings.pause, offIcon: "play.fill", onIcon: "pause.fill", onTap: {
                    if timeItem.isStopwatch {
                        self.timeItem.togglePause()
                    } else {
                        if self.timeItem.remainingTime == 0 {
                            if self.timeItem.isReusable {
                                self.timeItem.reset()
                            } else {
                            }
                        } else {
                            self.timeItem.togglePause()
                        }
                    }
                    
                }, offTap: {
                    if timeItem.isStopwatch {
                        self.timeItem.togglePause()
                    } else {
                        if self.timeItem.remainingTime == 0 {
                            if self.timeItem.isReusable {
                                self.timeItem.reset()
                            } else {
                            }
                        } else {
                            self.timeItem.togglePause()
                        }
                    }
                })
                Spacer().frame(width:28)
                
            }.padding(.vertical, 7).padding(.bottom, 7).animation(.default, value: timeItem.isRunning)
        }
    }
}
