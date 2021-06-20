//
//  HomeView.swift
//  TimePiece (iOS)
//
//  Created by Alexey Primechaev on 2/21/21.
//  Copyright © 2021 Alexey Primechaev. All rights reserved.
//

import SwiftUI
import UniformTypeIdentifiers

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
    
    @State private var dragging: TimeItem?
    
    var compactColumns = [GridItem(.flexible(), spacing: 14), GridItem(.flexible(), spacing: 14)]
    var regularColumns = [GridItem(.adaptive(minimum: 152, maximum: 428), spacing: 14)]
    
    var body: some View {
        
        HStack(spacing:0) {
            VStack(alignment: .leading, spacing: 0) {
                TitledScrollView(title: "TimePiece") {
                    if appState.showSections {
                        VStack(alignment: .leading, spacing: 0) {
                            if timeItems.filter{$0.isRunning == true && $0.remainingTime == 0}.count > 0 {
                                Text("Finished").fontSize(.smallTitle).padding(7)
                                LazyVGrid(columns: horizontalSizeClass == .compact ? compactColumns : regularColumns, alignment: .leading, spacing: 14) {
                                    ForEach(timeItems.filter{$0.isRunning == true && $0.remainingTime == 0}) { timeItem in
                                        TimeItemGridCell(timeItem: timeItem)
                                            .contentShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                                            //.opacity(self.dragging?.id == timeItem.id ? 0 : 1)
                                            .onDrag {
                                                self.dragging = timeItem
                                                return NSItemProvider(object: String(timeItem.order) as NSString)
                                            }
                                            .onDrop(of: [UTType.text], delegate: DragRelocateDelegate(item: timeItem, listData: timeItems, current: $dragging))
                                    }
                                }.padding(7)
                                Divider().padding(7).padding(.vertical, 7)
                            }
                            if timeItems.filter{$0.isRunning == true && $0.remainingTime != 0}.count > 0 {
                                Text("Active").fontSize(.smallTitle).padding(7)
                                LazyVGrid(columns: horizontalSizeClass == .compact ? compactColumns : regularColumns, alignment: .leading, spacing: 14) {
                                    ForEach(timeItems.filter{$0.isRunning == true && $0.remainingTime != 0}) { timeItem in
                                        TimeItemGridCell(timeItem: timeItem)
                                            .contentShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                                            //.opacity(self.dragging?.id == timeItem.id ? 0 : 1)
                                            .onDrag {
                                                self.dragging = timeItem
                                                return NSItemProvider(object: String(timeItem.order) as NSString)
                                            }
                                            .onDrop(of: [UTType.text], delegate: DragRelocateDelegate(item: timeItem, listData: timeItems, current: $dragging))
                                    }
                                }.padding(7)
                                Divider().padding(7).padding(.vertical, 7)
                            }
                            
                            if timeItems.count == timeItems.filter{$0.isRunning != true}.count {
                                
                            } else {
                            Text("Saved").fontSize(.smallTitle).padding(7)
                            }
                            LazyVGrid(columns: horizontalSizeClass == .compact ? compactColumns : regularColumns, alignment: .leading, spacing: 14) {
                                ForEach(timeItems.filter{$0.isRunning != true}) { timeItem in
                                    TimeItemGridCell(timeItem: timeItem)
                                        .contentShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                                        //.opacity(self.dragging?.id == timeItem.id ? 0 : 1)
                                        .onDrag {
                                            self.dragging = timeItem
                                            return NSItemProvider(object: String(timeItem.order) as NSString)
                                        }
                                        .onDrop(of: [UTType.text], delegate: DragRelocateDelegate(item: timeItem, listData: timeItems, current: $dragging))
                                }
                            }.padding(7)
                        }
                        
                    } else {
                        LazyVGrid(columns: horizontalSizeClass == .compact ? compactColumns : regularColumns, alignment: .leading, spacing: 14) {
                            ForEach(timeItems) { timeItem in
                                TimeItemGridCell(timeItem: timeItem)
                                    .contentShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                                    //.opacity(self.dragging?.id == timeItem.id ? 0 : 1)
                                    .onDrag {
                                        self.dragging = timeItem
                                        return NSItemProvider(object: String(timeItem.order) as NSString)
                                    }
                                    .onDrop(of: [UTType.text], delegate: DragRelocateDelegate(item: timeItem, listData: timeItems, current: $dragging))
                            }
                        }.padding(7)
                    }
                }
                BottomBar {
                    if appState.editingHomeScreen {
                        BottomBarItem(title: "Delete", icon: "trash") {
                            showingDeleteAlert = true
                        }.foregroundColor(.red).opacity(appState.selectedTimeItems.isEmpty ? 0.5 : 1).disabled(appState.selectedTimeItems.isEmpty)
                        .alert(isPresented: $showingDeleteAlert) {
                            Alert(title: Text("Delete selected Timers?"), primaryButton: .destructive(Text("Delete")) {
                                
                                withAnimation {
                                    for timeItem in appState.selectedTimeItems {
                                        timeItem.remove(from: context)
                                    }
                                }
                                appState.editingHomeScreen = false
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
                        
                        BottomBarItem(title: Strings.log, icon: "tray") {
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
            
            if horizontalSizeClass != .compact {
                if appState.showingSidebar {
                    
                    Divider()
                    
                    TimeItemSheet(timeItem: appState.selectedTimeItem) {
                        appState.showingSheet = false
                        appState.showingSidebar = false
                        appState.selectedTimeItem = TimeItem()
                    } delete: {
                        withAnimation(.default) {
                            appState.selectedTimeItem.remove(from: context)
                        }
                        appState.showingSheet = false
                        appState.showingSidebar = false
                    }.environmentObject(settings).frame(maxWidth: 375)
                    

                    
                }
                
                    
                
            }
            
        }
        
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
            if horizontalSizeClass != .compact {
            switch appState.activeSheet {
                
            case 1:
                NewTimeItemSheet(timeItem: appState.newTimeItem, isAdding: $isAdding) {
                    appState.showingSheet = false
                }.environmentObject(settings).environmentObject(appState)
                
            case 2:
                SettingsSheet {
                    appState.showingSheet = false
                }.environmentObject(settings).environmentObject(appState)
            case 3:
                LogSheet {
                    appState.showingSheet = false
                }.environmentObject(settings).environmentObject(appState).environment(\.managedObjectContext, context)
            case 4:
                SubscriptionSheet {
                    appState.showingSheet = false
                    settings.showingSubscription = false
                }.environmentObject(settings).environmentObject(appState)
            case 5:
                OnboardingSheet {
                    settings.hasSeenOnboarding = true
                    appState.showingSheet = false
                }.environmentObject(settings).environmentObject(appState)
            default:
                SettingsSheet {
                    appState.showingSheet = false
                }.environmentObject(settings).environmentObject(appState)
            }
            } else {
                switch appState.activeSheet {
                
                case 0:
                    TimeItemSheet(timeItem: appState.selectedTimeItem) {
                        appState.showingSheet = false
                        appState.showingSidebar = false
                        appState.selectedTimeItem = TimeItem()
                    } delete: {
                        withAnimation(.default) {
                            appState.selectedTimeItem.remove(from: context)
                        }
                        appState.showingSheet = false
                        appState.showingSidebar = false
                        appState.selectedTimeItem = TimeItem()
                    }.environmentObject(settings)
                    .environmentObject(appState)
                    
                case 1:
                    NewTimeItemSheet(timeItem: appState.newTimeItem, isAdding: $isAdding) {
                        appState.showingSheet = false
                    }.environmentObject(settings)
                    .environmentObject(appState)
                    
                case 2:
                    SettingsSheet {
                        appState.showingSheet = false
                    }.environmentObject(settings)
                    .environmentObject(appState)
                case 3:
                    LogSheet {
                        appState.showingSheet = false
                    }.environmentObject(settings).environmentObject(appState).environment(\.managedObjectContext, context)
                case 4:
                    SubscriptionSheet {
                        appState.showingSheet = false
                        settings.showingSubscription = false
                    }.environmentObject(settings)
                    .environmentObject(appState)
                case 5:
                    OnboardingSheet {
                        settings.hasSeenOnboarding = true
                        appState.showingSheet = false
                    }.environmentObject(settings)
                    .environmentObject(appState)
                default:
                    SettingsSheet {
                        appState.showingSheet = false
                    }.environmentObject(settings)
                    .environmentObject(appState)
                }
            }
        
    
}
        
        .onAppear {
            
            
            if settings.isFirstLaunch {
                if timeItems.count == 0 {
                    TimeItem.prefillData(context: context)
                }
                settings.isFirstLaunch = false
            }
            
            
            if timeItems.count > 0 {
                for i in 0...timeItems.count-1 {
                    timeItems[i].order = i
                }
            }
        }
        
        
    }
    
    func deleteLast() {
        timeItems[timeItems.count - 1].remove(from: context)
    }
}

struct DragRelocateDelegate: DropDelegate {
    let item: TimeItem
    var listData: FetchedResults<TimeItem>
    @Binding var current: TimeItem?
    
    func dropEntered(info: DropInfo) {
        if item != current {
            let from = current?.order ?? 0
            let to = item.order
            
            var revisedItems: [TimeItem] = listData.map{ $0 }
            
            // change the order of the items in the array
            revisedItems.move(fromOffsets: IndexSet(integer: from), toOffset: to )
            
            // update the userOrder attribute in revisedItems to
            // persist the new order. This is done in reverse order
            // to minimize changes to the indices.
            for reverseIndex in stride( from: revisedItems.count - 1,
                                        through: 0,
                                        by: -1 )
            {
                revisedItems[reverseIndex].order =
                    Int( reverseIndex )
            }
        }
    }
    
    
    func dropUpdated(info: DropInfo) -> DropProposal? {
        print("meks")
        return DropProposal(operation: .move)
    }
    
    func dropExited(info: DropInfo) {
        print("keks")
    }
    
    func performDrop(info: DropInfo) -> Bool {
        self.current = nil
        return true
    }
}


struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView().environmentObject(Settings()).environmentObject(AppState())
    }
}
