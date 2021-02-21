//
//  HomeView.swift
//  TimePiece (iOS)
//
//  Created by Alexey Primechaev on 2/21/21.
//  Copyright © 2021 Alexey Primechaev. All rights reserved.
//

import SwiftUI

struct HomeView: View {
    
    //MARK: - Variable Defenition
    
    
    
    //MARK: Core Data Setup
    @Environment(\.managedObjectContext) var context
    @FetchRequest(fetchRequest: TimeItem.getAllTimeItems()) var timeItems: FetchedResults<TimeItem>
    
    @EnvironmentObject var settings: Settings
    @EnvironmentObject var appState: AppState
    
    //MARK: State Variables
    
    @State var isAdding = false
    
    @State var isLarge = true
    
    @State var showingDeleteAlert = false
    
    @State private var scrollOffset: CGFloat = .zero
    
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    
    var compactColumns = [GridItem(.flexible(), spacing: 14), GridItem(.flexible(), spacing: 14)]
    var regularColumns = [GridItem(.adaptive(minimum: 152, maximum: 252), spacing: 14)]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            TopBar(isLarge: $isLarge)
            TrackableScrollView {
                scrollOffset = $0
            } content: {
                VStack(alignment: .leading, spacing: 0) {
                    Text(Strings.timePiece).fontSize(.title).padding(.bottom, 21).padding(.leading, 7)
                    LazyVGrid(columns: horizontalSizeClass == .compact ? compactColumns : regularColumns, alignment: .leading, spacing: 14) {
                        ForEach(timeItems) { timeItem in
                            TimeItemGridCell(timeItem: timeItem)
                        }
                    }.padding(7)
                }.padding(.horizontal, 21).padding(.vertical, 14)
            }
            .onChange(of: scrollOffset) { newValue in
                if newValue <= -32 {
                    isLarge = false
                } else if newValue > -32  {
                    isLarge = true
                }
            }
            BottomBar {
                if appState.isInEditing {
                    BottomBarItem(title: "Delete", icon: "trash") {
                        showingDeleteAlert = true
                    }.foregroundColor(.red).opacity(appState.selectedValues.isEmpty ? 0.5 : 1).disabled(appState.selectedValues.isEmpty)
                    .alert(isPresented: $showingDeleteAlert) {
                        Alert(title: Text("Delete selected Timers?"), primaryButton: .destructive(Text("Delete")) {
                            
                            withAnimation {
                                for timeItem in appState.selectedValues {
                                    context.delete(timeItem)
                                }
                            }
                            try? context.save()
                            appState.isInEditing = false
                        }, secondaryButton: .cancel())
                    }
                } else {
                    BottomBarItem(title: Strings.new,icon: "plus") {
                        withAnimation(.default) {
                            appState.newTimeItem = TimeItem.newTimeItem(totalTime: 0, title: "", context: context, reusableSetting: settings.isReusableDefault, soundSetting: settings.soundSettingDefault, precisionSetting: settings.precisionSettingDefault, notificationSetting: settings.notificationSettingDefault, showInLog: settings.showInLogDefault, isStopwatch: false, order: timeItems.count)
                            appState.activeSheet = 1
                            appState.showingSheet = true
                        }
                    }
                    
                    .contextMenu {
                        
                        Button {
                            withAnimation(.default) {
                                appState.newTimeItem = TimeItem.newTimeItem(totalTime: 0, title: "", context: context, reusableSetting: settings.isReusableDefault, soundSetting: settings.soundSettingDefault, precisionSetting: settings.precisionSettingDefault, notificationSetting: settings.notificationSettingDefault, showInLog: settings.showInLogDefault, isStopwatch: false, order: timeItems.count)
                                appState.activeSheet = 1
                                appState.showingSheet = true
                            }
                        } label: {
                            Label("New Timer", systemImage: "timer")
                        }
                        
                        Button {
                            withAnimation(.default) {
                                appState.newTimeItem = TimeItem.newTimeItem(totalTime: 0, title: "", context: context, reusableSetting: settings.isReusableDefault, soundSetting: settings.soundSettingDefault, precisionSetting: settings.precisionSettingDefault, notificationSetting: settings.notificationSettingDefault, showInLog: settings.showInLogDefault, isStopwatch: true,order: timeItems.count)
                                appState.activeSheet = 1
                                appState.showingSheet = true
                            }
                        } label: {
                            Label("New Stopwatch", systemImage: "stopwatch")
                        }
                        Divider()
                        Button {
                            withAnimation(.default) {
                                appState.newTimeItem = TimeItem.newTimeItem(totalTime: 0, title: "", context: context, reusableSetting: settings.isReusableDefault, soundSetting: settings.soundSettingDefault, precisionSetting: settings.precisionSettingDefault, notificationSetting: settings.notificationSettingDefault, showInLog: settings.showInLogDefault, isStopwatch: true,order: timeItems.count)
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                    appState.newTimeItem.togglePause()
                                }
                            }
                        } label: {
                            Label("Start Stopwatch", systemImage: "play.circle")
                        }
                        
                    }
                    .foregroundColor(.primary)
                    
                    BottomBarItem(title: Strings.log, icon: "bolt") {
                        appState.activeSheet = 3
                        appState.showingSheet = true
                    }.foregroundColor(.primary)
                    BottomBarItem(title: Strings.settings, icon: "gear") {
                        appState.activeSheet = 2
                        appState.showingSheet = true
                    }.environmentObject(settings).foregroundColor(.primary)
                }
                
                
            }
        }
        
        
        .onAppear {
            if !settings.hasSeenOnboarding {
                appState.activeSheet = 5
                appState.showingSheet = true
            } else {
                appState.activeSheet = 3
            }
            
            if timeItems.count > 0 {
                for i in 0...timeItems.count-1 {
                    timeItems[i].order = i
                }
            }
        }
        //MARK: Sheet
        .sheet(isPresented: $appState.showingSheet) {
            if appState.activeSheet == 1 {
                if isAdding {
                    
                } else {
                    withAnimation(.default) {
                        deleteLast()
                    }
                }
            }
            
        } content: {
            switch appState.activeSheet {
            
            case 0:
                TimeItemSheet(timeItem: appState.selectedTimeItem) {
                    appState.showingSheet = false
                } delete: {
                    withAnimation(.default) {
                        appState.selectedTimeItem.remove(from: context)
                    }
                    appState.showingSheet = false
                }.environmentObject(settings)
                
            case 1:
                NewTimeItemSheet(timeItem: appState.newTimeItem, isAdding: $isAdding) {
                    appState.showingSheet = false
                }.environmentObject(settings)
                
            case 2:
                SettingsSheet {
                    appState.showingSheet = false
                }.environmentObject(settings)
            case 3:
                LogSheet {
                    appState.showingSheet = false
                }.environmentObject(settings).environment(\.managedObjectContext, context)
            case 4:
                SubscriptionSheet {
                    appState.showingSheet = false
                    settings.showingSubscription = false
                }.environmentObject(settings)
            case 5:
                OnboardingSheet {
                    settings.hasSeenOnboarding = true
                    appState.showingSheet = false
                }.environmentObject(settings)
            default:
                SettingsSheet {
                    appState.showingSheet = false
                }.environmentObject(settings)
            }
            
            
            
        }
        
    }
    
    func deleteLast() {
        timeItems[timeItems.count - 1].remove(from: context)
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
