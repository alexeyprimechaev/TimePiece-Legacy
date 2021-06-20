//
//  SheetActions.swift
//  TimePiece (iOS)
//
//  Created by Alexey Primechaev on 6/20/21.
//  Copyright © 2021 Alexey Primechaev. All rights reserved.
//

import SwiftUI

enum ActionsPresentation {
    case normal, compact
}

struct DetailActions: View {
    
    @ObservedObject var timeItem: TimeItem
    
    @State private var showLogSheet = false
    @State private var addingComment = false
    @State private var showingConvertAlert = false
    @State private var addedTime = 0
    
    @State var presentation: ActionsPresentation = .normal
            
    var body: some View {
        VStack(alignment: .leading, spacing: 7) {
            if timeItem.isStopwatch {
                if !timeItem.isReusable {
                    PremiumBadge {
                        RegularButton(title: Strings.makeReusable, icon: "arrow.clockwise") {
                            timeItem.makeReusable()
                        }
                    }
                    PremiumBadge {
                        RegularButton(title: "Convert to Timer", icon: "timer") {
                            if timeItem.isRunning {
                                showingConvertAlert = true
                            } else {
                                timeItem.isStopwatch = false
                            }
                        }
                    }
                    
                } else {
                    PremiumBadge {
                        RegularButton(title: "Convert to Timer", icon: "timer") {
                            if timeItem.isRunning {
                                showingConvertAlert = true
                            } else {
                                timeItem.isStopwatch = false
                            }
                        }
                    }
                    PremiumBadge {
                        RegularButton(title: "Show in Log", icon: "gobackward") {
                            showLogSheet = true
                        }
                    }
                    
                    if timeItem.comment.count == 0 {
                        PremiumBadge {
                            RegularButton(title: "Add Comment", icon: "plus.bubble") {
                                addingComment = true
                            }
                        }
                    }
                    
                    
                    
                }
                
            
        } else {
            if timeItem.isReusable {
                PremiumBadge {
                    RegularButton(title: "Convert to Stopwatch", icon: "stopwatch") {
                        if timeItem.isRunning {
                            showingConvertAlert = true
                        } else {
                            withAnimation {
                                timeItem.convertToStopwatch()
                            }
                        }
                        
                    }
                }
                
                
                PremiumBadge {
                    RegularButton(title: "Show in Log", icon: "gobackward") {
                        showLogSheet = true
                    }
                }
                if timeItem.comment.count == 0 {
                    PremiumBadge {
                        RegularButton(title: "Add Comment", icon: "plus.bubble") {
                            addingComment = true
                        }
                    }
                }
                
                if timeItem.isRunning {
                    
                    PremiumBadge {
                        Menu {
                            RegularButton(title: "1 minute", icon: "") {
                                timeItem.addTime(time: 60)
                            }
                            
                            RegularButton(title: "5 minutes", icon: "") {
                                timeItem.addTime(time: 300)
                            }
                            RegularButton(title: "10 minutes", icon: "") {
                                timeItem.addTime(time: 600)
                            }
                        } label: {
                            RegularButton(title: "Add Time...", icon: "plus.circle") {
                                
                            }
                        }
                    }
                }
                
            } else {
                
                    PremiumBadge {
                        RegularButton(title: Strings.makeReusable, icon: "arrow.clockwise") {
                            timeItem.makeReusable()
                        }
                    }
                    
                    PremiumBadge {
                        RegularButton(title: "Convert to Stopwatch", icon: "stopwatch") {
                            if timeItem.isRunning {
                                showingConvertAlert = true
                            } else {
                                withAnimation {
                                    timeItem.convertToStopwatch()
                                }
                            }
                            
                        }
                    }
                
                
                    
                    
                    if timeItem.isRunning {
                        
                        PremiumBadge {
                            Menu {
                                RegularButton(title: "1 minute", icon: "") {
                                    addedTime += 60
                                    timeItem.addTime(time: 60)
                                }
                                
                                RegularButton(title: "5 minutes", icon: "") {
                                    addedTime += 300
                                    timeItem.addTime(time: 300)
                                }
                                RegularButton(title: "10 minutes", icon: "") {
                                    addedTime += 60
                                    timeItem.addTime(time: 600)
                                }
                            } label: {
                                RegularButton(title: "Add Time...", icon: "plus.circle") {
                                    
                                }
                            }
                        }
                    }
                
                
            }
        }
            
        }
        .animation(.default, value: timeItem.isRunning)
        .sheet(isPresented: $showLogSheet) {
            LogSheet(title: timeItem.title, discard: {showLogSheet = false})
        }
        .sheet(isPresented: $addingComment) {
            CommentSheet(comment: $timeItem.comment)
        }
        .alert(isPresented: $showingConvertAlert) {
            if timeItem.isStopwatch {
                return Alert(title: Text("Convert to Timer?"), message: Text("Converting will reset the Stopwatch"), primaryButton: .default(Text("Convert"), action:  {
                    timeItem.reset()
                    timeItem.isStopwatch = false
                }), secondaryButton: .cancel())
            } else {
                return Alert(title: Text("Convert to Stopwatch?"), message: Text("Converting will reset the Timer"), primaryButton: .default(Text("Convert"), action:  {
                    timeItem.reset()
                    timeItem.convertToStopwatch()
                }), secondaryButton: .cancel())
            }
        }
    }
}
