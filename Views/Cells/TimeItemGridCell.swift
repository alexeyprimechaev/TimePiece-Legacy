//
//  TimeItemGridCell.swift
//  TimePiece (iOS)
//
//  Created by Alexey Primechaev on 2/21/21.
//  Copyright © 2021 Alexey Primechaev. All rights reserved.
//

import SwiftUI

struct TimeItemGridCell: View {
    //MARK: - Properties
    
    //MARK: Dynamic Propertiess
    @ObservedObject var timeItem: TimeItem
    
    //MARK: CoreData
    @Environment(\.managedObjectContext) var context
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    
    @EnvironmentObject var settings: Settings
    @EnvironmentObject var appState: AppState
    
    
    @State private var currentTime: String = "00:00"
    
    @State private var timeFieldDummy = UITextField()
    @State private var timeFocusedDummy = false
    
    var body: some View {
        VStack(alignment: .leading) {
            Button {
                if appState.editingHomeScreen {
                    if appState.selectedTimeItems.contains(timeItem) {
                        appState.selectedTimeItems.removeAll { $0 == timeItem }
                    } else {
                        appState.selectedTimeItems.append(timeItem)
                    }
                    
                } else {
                    if timeItem.isStopwatch {
                        self.timeItem.togglePause()
                    } else {
                        if self.timeItem.remainingTime == 0 {
                            if self.timeItem.isReusable {
                                self.timeItem.reset()
                            } else {
                                self.timeItem.remove(from: self.context)
                            }
                        } else {
                            self.timeItem.togglePause()
                        }
                    }
                }
                
                
                try? self.context.save()
            } label: {
                    Group {
                    if !timeItem.isStopwatch {
                        VStack(alignment: .leading, spacing: 0) {
                            Text(timeItem.title.isEmpty ? Strings.timer : LocalizedStringKey(timeItem.title))
                            ZStack(alignment: .topLeading) {
                                if timeItem.isRunning {
                                    if timeItem.remainingTime == 0 {
                                        Text("Done").opacity(0.5)
                                    } else {
                                        if timeItem.isPaused {
                                            Text(timeItem.remainingTime.stringFromNumber()).opacity(0.5)
                                        } else {
                                            TimeDisplay(isPaused: $timeItem.isPaused, isRunning: $timeItem.isRunning, timeString: $currentTime, updateTime: updateTime, displayStyle: .small, precisionSetting: $timeItem.precisionSetting, textField: $timeFieldDummy, isFocused: $timeFocusedDummy)
                                        }
                                    }
                                    
                                }
                                else {
                                    Text(timeItem.totalTime.stringFromNumber()).opacity(0.5)
                                }
                            }
                            
                            
                            
                            
                        }
                    } else {
                        VStack(alignment: .leading, spacing: 0) {
                            
                            ZStack(alignment: .topLeading) {
                                VStack(alignment: .leading, spacing: 0) {
                                    if timeItem.isRunning {
                                        if timeItem.isPaused {
                                            Text(timeItem.remainingTime.stringFromNumber()).opacity(0.5)
                                        } else {
                                            TimeDisplay(isPaused: $timeItem.isPaused, isRunning: $timeItem.isRunning, timeString: $currentTime, updateTime: updateTime, displayStyle: .small, precisionSetting: $timeItem.precisionSetting, textField: $timeFieldDummy, isFocused: $timeFocusedDummy)
                                        }
                                    }
                                    else {
                                        Text("Start").opacity(0.5)
                                    }
                                }.animation(.default)
                                
                                
                            }
                            Text(timeItem.title.isEmpty ? "Stopwatch ⏱" : LocalizedStringKey(timeItem.title))
                            
                            
                            
                            
                        }
                    }
                }
                
                .onReceive(Timer.publish(every: 0.015, on: .main, in: .common).autoconnect()) { time in
                    self.updateTime()
                }
                .onAppear {
                    currentTime = timeItem.remainingTimeString
                }
                .onChange(of: timeItem.remainingTimeString) { newValue in
                    currentTime = newValue
                }
                .animation(nil)
                .opacity(appState.editingHomeScreen ? 0.5 : 1)
                .padding(14)
                .padding(.vertical, 10)
                
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
                    .background(RoundedRectangle(cornerRadius: 16, style: .continuous).foregroundColor(Color(timeItem.isRunning ? .systemGray5 : .systemGray6)))
                    .overlay(appState.editingHomeScreen ? nil : Button {
                    appState.selectedTimeItem = timeItem
                    appState.activeSheet = 0
                        
                        if horizontalSizeClass == .compact {
                            appState.showingSheet = true
                        } else {
                            appState.showingSidebar = true
                        }
                    
                    
                } label: {
                    Image(systemName: "ellipsis").font(.headline).padding(14).padding(.vertical, 10)
                }, alignment: .topTrailing)
                    .overlay(
                        RoundedRectangle(cornerRadius: 16, style: .continuous)
                            .stroke(Color.primary, lineWidth: 2)
                            .opacity(timeItem == appState.selectedTimeItem && horizontalSizeClass != .compact ? 1 : 0))
                    
                .overlay(appState.editingHomeScreen ? Image(systemName: appState.selectedTimeItems.contains(timeItem) ? "checkmark.circle.fill" : "circle").font(.title2).padding(7) : nil, alignment: .topTrailing)
                    
            }
            
            
            //MARK: Styling
            .fontSize(.smallTitle)
            .buttonStyle(TitleButtonStyle())
        }.lineLimit(1)

    }
    
    func updateTime() {
        
        if timeItem.isStopwatch {
            if !timeItem.isPaused {
                currentTime = Date().timeIntervalSince(timeItem.timeStarted).editableStringMilliseconds()
            } else {
                
            }
            
            
        } else {
            if !timeItem.isPaused {
                
                
                if timeItem.timeFinished.timeIntervalSince(Date()) <= 0 {
                    
                    timeItem.togglePause()
                    
                    timeItem.remainingTime = 0
                    
                    //AudioServicesPlaySystemSound(timeItem.soundSetting == TimeItem.soundSettings[0] ? 1007 : 1036)
                    
                }
                
                currentTime = timeItem.timeFinished.timeIntervalSince(Date()).editableStringMilliseconds()
                
                
            }
        }
        
        
        
    }
}

extension View {
    func phoneOnlyStackNavigationView() -> some View {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return AnyView(self.navigationViewStyle(StackNavigationViewStyle()))
        } else {
            return AnyView(self)
        }
    }
}
