//
//  TimerPlusDetailView.swift
//  TimerPlus
//
//  Created by Alexey Primechaev on 1/6/20.
//  Copyright © 2020 Alexey Primechaev. All rights reserved.
//

import SwiftUI
import Introspect
import AVFoundation
import CoreData

struct TimeItemSheet: View {
    
    
    @ObservedObject var timeItem = TimeItem()
    
    @EnvironmentObject var settings: Settings
    
        
    @State var picking: String = "Off"
    
    @State var addingComment = false
    @State var showSettings = false
    
    @State var titleField = UITextField()
    @State var timeField = UITextField()
    
    
    
    @State var titleFocused = false
    @State var timeFocused = false
    
    @State var showLogSheet = false
    
    @State var timeFieldDummy = UITextField()
    @State var timeFocusedDummy = false
    
    @State var showingMakeReusableAlert = false
    
    @State var showingConvertAlert = false
    
    @State var addedTime: TimeInterval = 0
    
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    
    var discard: () -> Void
    
    var delete: () -> Void
    
    var body: some View {
        
        
        VStack(spacing:0) {
            
            HeaderBar {
                RegularButton(title: Strings.dismiss, icon: "chevron.down") {
                    discard()
                }
            } trailingItems: {
                RegularButton(title: Strings.delete, icon: "trash", isDestructive: true) {
                    delete()
                }
            }
            
            //
            //            HeaderBar(leadingAction: discard,
            //                      leadingTitle: Strings.dismiss,
            //                      leadingIcon: horizontalSizeClass == .compact ? "chevron.down" : "chevron.left",
            //                      leadingIsDestructive: false,
            //                      trailingAction: {delete()}, trailingTitle: "Delete")
            TitledScrollView {
                
                VStack(alignment: .leading, spacing: 14) {
                    SheetEditorss(timeItem: timeItem, titleField: $titleField, timeField: $timeField, titleFocused: $titleFocused, timeFocused: $timeFocused)
                    SheetPickers(timeItem: timeItem)
                    SheetActions(timeItem: timeItem)
                }
                .padding(.top, 14)
                
                
                
            }
            .animation(.default)
            
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
                                    delete()
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
                                    delete()
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
    
    
    
    
    
}



struct TimerDetailView_Previews: PreviewProvider {
    static var previews: some View {
        TimeItemSheet(discard: {}, delete: {})
    }
}
