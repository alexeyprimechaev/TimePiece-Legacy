//
//  ContentView.swift
//  TimerPlus
//
//  Created by Alexey Primechaev on 1/5/20.
//  Copyright © 2020 Alexey Primechaev. All rights reserved.
//

import SwiftUI
import ASCollectionView

struct ContentView: View {
    
    //MARK: - Variable Defenition
    
    
    
    //MARK: Core Data Setup
    @Environment(\.managedObjectContext) var context
    @FetchRequest(fetchRequest: TimeItem.getAllTimeItems()) var timeItems: FetchedResults<TimeItem>
    
    @EnvironmentObject var settings: Settings
    @EnvironmentObject var appState: AppState
    
    //MARK: State Variables
    
    @State var isAdding = false
    @State var newTimeItem = TimeItem()
    
    @State var isLarge = true
    
    @State var showingDeleteAlert = false
    
    
    //MARK: - View
    
    var body: some View {
        
        VStack(spacing: 0) {
            VStack(spacing: 0) {
                ZStack {
                    HStack {
                        
                        Text(Strings.timePiece).fontSize(.smallTitle).opacity(isLarge ? 0 : 1).padding(14)
                        
                    }
                    HStack {
                        Spacer()
                        Button {
                            appState.isInEditing.toggle()
                            appState.selectedValues = []
                        } label: {
                            Label {
                                Text(appState.isInEditing ? "Done" : "Edit").fontSize(.smallTitle)
                            } icon: {
                                
                            }.foregroundColor(.primary).padding(14).padding(.horizontal, 14)
                        }
                    }
                }.animation(nil)
                
                Divider().opacity(isLarge ? 0 : 1)
            }.animation(.easeOut(duration: 0.2))
            
            ASCollectionView(
                sections:
                    [
                        
                        ASCollectionViewSection(id: 0) {
                            Text(Strings.timePiece).fontSize(.title).padding(.bottom, 14).padding(.leading, 7)
                        },
                        //MARK: Timers
                        ASCollectionViewSection(id: 1, data: timeItems, contextMenuProvider: appState.isInEditing ? nil : contextMenuProvider) { timer, _ in
                            TimeItemCell(timeItem: timer).environmentObject(settings).environmentObject(appState)
                            
                        }
                    ]
            )
            
            //MARK: Layout Configuration
            .layout {
                let fl = AlignedCollectionViewFlowLayout()
                fl.horizontalAlignment = .leading
                fl.sectionInset = UIEdgeInsets(top: 0, left: 21, bottom: 0, right: 7)
                fl.minimumInteritemSpacing = 14
                fl.minimumLineSpacing = 14
                fl.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
                return fl
            }
            .onScroll { scroll, _ in
                if scroll.y >= 32 {
                    isLarge = false
                } else if scroll.y < 32  {
                    isLarge = true
                }
            }
            .alwaysBounceVertical(true)
            .ignoresSafeArea(.keyboard)
            .animation(.default)
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
                            TimeItem.newTimeItem(totalTime: 0, title: "", context: context, reusableSetting: settings.isReusableDefault, soundSetting: settings.soundSettingDefault, precisionSetting: settings.precisionSettingDefault, notificationSetting: settings.notificationSettingDefault, showInLog: settings.showInLogDefault, isStopwatch: false, order: timeItems.count)
                            appState.activeSheet = 1
                            appState.showingSheet = true
                        }
                    }
                    
                    .contextMenu {
                        
                        Button {
                            withAnimation(.default) {
                                TimeItem.newTimeItem(totalTime: 0, title: "", context: context, reusableSetting: settings.isReusableDefault, soundSetting: settings.soundSettingDefault, precisionSetting: settings.precisionSettingDefault, notificationSetting: settings.notificationSettingDefault, showInLog: settings.showInLogDefault, isStopwatch: false, order: timeItems.count)
                                appState.activeSheet = 1
                                appState.showingSheet = true
                            }
                        } label: {
                            Label("New Timer", systemImage: "timer")
                        }
                        
                        Button {
                            withAnimation(.default) {
                                TimeItem.newTimeItem(totalTime: 0, title: "", context: context, reusableSetting: settings.isReusableDefault, soundSetting: settings.soundSettingDefault, precisionSetting: settings.precisionSettingDefault, notificationSetting: settings.notificationSettingDefault, showInLog: settings.showInLogDefault, isStopwatch: true,order: timeItems.count)
                                appState.activeSheet = 1
                                appState.showingSheet = true
                            }
                        } label: {
                            Label("New Stopwatch", systemImage: "stopwatch")
                        }
                        Divider()
                        Button {
                            withAnimation(.default) {
                                TimeItem.newTimeItem(totalTime: 0, title: "", context: context, reusableSetting: settings.isReusableDefault, soundSetting: settings.soundSettingDefault, precisionSetting: settings.precisionSettingDefault, notificationSetting: settings.notificationSettingDefault, showInLog: settings.showInLogDefault, isStopwatch: true,order: timeItems.count)
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                    timeItems[timeItems.count-1].togglePause()
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
        
        .ignoresSafeArea(.keyboard)
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
                NewTimeItemSheet(timeItem: timeItems[timeItems.count-1], isAdding: $isAdding) {
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
    
    //MARK: - Data Functions
    
    
    
    //MARK: Delete
    func deleteLast() {
        timeItems[timeItems.count - 1].remove(from: context)
    }
    
    //MARK: - CollectionView Functions
    
    
    
    //MARK: Context Menu
    func contextMenuProvider(int: Int, timer: TimeItem) -> UIContextMenuConfiguration? {
        let configuration = UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { (suggestedActions) -> UIMenu? in
            let deleteCancel = UIAction(title: "Cancel", image: UIImage(systemName: "xmark")) { action in }
            let deleteConfirm = UIAction(title: timer.isRunning ? NSLocalizedString("stop", comment: "Stop") : NSLocalizedString("delete", comment: "Delete"), image: UIImage(systemName: timer.isRunning ? "stop" : "trash"), attributes: settings.isMonochrome ? UIMenuElement.Attributes() : .destructive) { action in
                if !(timer.isRunning) {
                    timer.remove(from: context)
                    try? context.save()
                } else {
                    timer.reset()
                }
                
            }
            
            let deleteConfirmReusable = UIAction(title: NSLocalizedString("delete", comment: "Delete"), image: UIImage(systemName: "trash"), attributes: settings.isMonochrome ? UIMenuElement.Attributes() : .destructive) { action in
                timer.remove(from: context)
                try? context.save()
                
            }
            
            // The delete sub-menu is created like the top-level menu, but we also specify an image and options
            let delete = UIMenu(title: timer.isRunning ? NSLocalizedString("stop", comment: "Stop") : NSLocalizedString("delete", comment: "Delete"), image: UIImage(systemName: timer.isRunning ? "stop" : "trash"), options: settings.isMonochrome ? UIMenu.Options() : .destructive, children: [deleteCancel, deleteConfirm])
            
            
            let pause = UIAction(title: timer.isPaused ? NSLocalizedString("start", comment: "Start") : NSLocalizedString("pause", comment: "Pause"), image: UIImage(systemName: timer.isPaused ? "play" : "pause")) { action in
                if timer.remainingTime == 0 {
                    if timer.isReusable {
                        timer.reset()
                    } else {
                        timer.remove(from: context)
                    }
                } else {
                    timer.togglePause()
                }
            }
            
            let makeReusable = UIAction(title: NSLocalizedString("makeReusable", comment: "Make Reusable"), image: UIImage(systemName: "arrow.clockwise")) { action in
                if settings.isSubscribed {
                    timer.makeReusable()
                } else {
                    appState.activeSheet = 4
                    appState.showingSheet = true
                }
            }
            
            let deleteReusable = UIMenu(title: NSLocalizedString("delete", comment: "Delete"), image: UIImage(systemName: "trash"), options: settings.isMonochrome ? UIMenu.Options() : .destructive, children: [deleteCancel, deleteConfirmReusable])
            
            
            // The edit menu adds delete as a child, just like an action
            let edit = UIMenu(title: "Edit...", options: .displayInline, children: timer.isReusable ? [pause, delete] : [pause, makeReusable, deleteReusable])
            
            let info = UIAction(title: NSLocalizedString("showDetails", comment: "Show Details"), image: UIImage(systemName: "ellipsis")) { action in
                appState.selectedTimeItem = timer
                appState.activeSheet = 0
                appState.showingSheet = true
            }
            
            // Then we add edit as a child of the main menu
            let mainMenu = UIMenu(title: "", children: [edit, info])
            return mainMenu
        }
        return configuration
    }
    
    //    var dragDropConfig: ASDragDropConfig<TimerItem>
    //    {
    //        ASDragDropConfig(dragEnabled: true, dropEnabled: true, reorderingEnabled: true, onMoveItem:  { (from, to) -> Bool in
    //
    //            var revisedItems: [ TimerItem ] = timeItems.map{ $0 }
    //
    //                // change the order of the items in the array
    //                revisedItems.move(fromOffsets: IndexSet(integer: from), toOffset: to )
    //
    //                // update the userOrder attribute in revisedItems to
    //                // persist the new order. This is done in reverse order
    //                // to minimize changes to the indices.
    //                for reverseIndex in stride( from: revisedItems.count - 1,
    //                                            through: 0,
    //                                            by: -1 )
    //                {
    //                    revisedItems[ reverseIndex ].order =
    //                        Int( reverseIndex )
    //                }
    //
    //            return true
    //        })
    //            .canDragItem { (indexPath) -> Bool in
    //                true
    //            }
    //            .canMoveItem { (from, to) -> Bool in
    //                true
    //            }
    //
    //
    //    }
    
    
    
}

//MARK: - Previews

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
