//
//  ContentView.swift
//  TimerPlus
//
//  Created by Alexey Primechaev on 1/5/20.
//  Copyright © 2020 Alexey Primechaev. All rights reserved.
//

import SwiftUI
import ASCollectionView

enum ActiveSheet {
   case timer, newTimer, settings, trends, subscription
}

struct ContentView: View {
    
//MARK: - Variable Defenition
    
    

    //MARK: Core Data Setup
    @Environment(\.managedObjectContext) var context
    @FetchRequest(fetchRequest: TimerItem.getAllTimers()) var timerItems: FetchedResults<TimerItem>
    
    @EnvironmentObject var settings: Settings
    
    //MARK: State Variables
    @State var showingSheet = false
    @State var activeSheet = 2
    
    @State var isAdding = false
    @State var selectedTimer = 0
    
    @State var isLarge = true
    
        
//MARK: - View
    
    var body: some View {
        
            VStack(spacing: 0) {
                VStack(spacing: 0) {
                    HStack {

                        Text(Strings.timePiece).fontSize(.smallTitle).opacity(isLarge ? 0 : 1).padding(14)


                    }

                    Divider().opacity(isLarge ? 0 : 1)
                }.animation(.easeOut(duration: 0.2))

            ASCollectionView(
                sections:
                [

                    ASCollectionViewSection(id: 0) {
                        Text(Strings.timePiece).fontSize(.title).padding(.bottom, 14).padding(.leading, 7)
                    },
            //MARK: Timers
                    ASCollectionViewSection(id: 1, data: timerItems, dragDropConfig: dragDropConfig, contextMenuProvider: contextMenuProvider) { timer, _ in
                        TimerItemCell(timer: timer).environmentObject(settings)

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
            .animation(.default)
                TabBar(actions: [
                {
                    withAnimation(.default) {
                        TimerItem.newTimerItem(totalTime: 0, title: "", context: context, reusableSetting: settings.isReusableDefault, soundSetting: settings.soundSettingDefault, precisionSetting: settings.precisionSettingDefault, notificationSetting: settings.notificationSettingDefault, showInLog: settings.showInLogDefault, order: timerItems.count)
                        activeSheet = 1
                        showingSheet = true
                    }
                },{
                    activeSheet = 3
                    showingSheet = true
                },{
                    activeSheet = 2
                    showingSheet = true
                    }]).environmentObject(settings)

            }
        
        .ignoresSafeArea(.keyboard)
        .onAppear {
            if !settings.hasSeenOnboarding {
                activeSheet = 5
                showingSheet = true
            } else {
                activeSheet = 3
            }
            
            if timerItems.count > 0 {
                for i in 0...timerItems.count-1 {
                    timerItems[i].order = i
                }
            }
            
            dump(timerItems)
        }
        //MARK: Sheet
        .sheet(isPresented: $showingSheet) {
            if activeSheet == 1 {
                if isAdding {
                    
                } else {
                    withAnimation(.default) {
                        deleteLast()
                    }
                }
            }
            
        } content: {
            switch activeSheet {
    
                case 0:
                    TimerSheet(timer: timerItems[selectedTimer]) {
                        showingSheet = false
                    } delete: {
                        withAnimation(.default) {
                            timerItems[selectedTimer].remove(from: context)
                        }
                        showingSheet = false
                    }.environmentObject(settings)
                    
                case 1:
                    NewTimerSheet(timer: timerItems[timerItems.count-1], isAdding: $isAdding) {
                        showingSheet = false
                    }.environmentObject(settings)
                    
                case 2:
                    SettingsSheet {
                        showingSheet = false
                    }.environmentObject(settings)
                case 3:
                    LogSheet {
                        showingSheet = false
                    }.environmentObject(settings).environment(\.managedObjectContext, context)
                case 4:
                    SubscriptionSheet {
                        showingSheet = false
                        settings.showingSubscription = false
                    }.environmentObject(settings)
                case 5:
                    OnboardingSheet {
                        settings.hasSeenOnboarding = true
                        showingSheet = false
                        
                    }.environmentObject(settings)
                default:
                SettingsSheet {
                    showingSheet = false
                }.environmentObject(settings)
                }
            
           
            
        }

        
        
        
    }
    
//MARK: - Data Functions
    
    
    
    //MARK: Delete
    func deleteLast() {
        timerItems[timerItems.count - 1].remove(from: context)
    }
    
//MARK: - CollectionView Functions
    
    
    
    //MARK: Context Menu
    func contextMenuProvider(int: Int, timer: TimerItem) -> UIContextMenuConfiguration? {
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
                    activeSheet = 4
                    showingSheet = true
                }
            }
            
            let deleteReusable = UIMenu(title: NSLocalizedString("delete", comment: "Delete"), image: UIImage(systemName: "trash"), options: settings.isMonochrome ? UIMenu.Options() : .destructive, children: [deleteCancel, deleteConfirmReusable])
            

            // The edit menu adds delete as a child, just like an action
            let edit = UIMenu(title: "Edit...", options: .displayInline, children: timer.isReusable ? [pause, delete] : [pause, makeReusable, deleteReusable])

            let info = UIAction(title: NSLocalizedString("showDetails", comment: "Show Details"), image: UIImage(systemName: "ellipsis")) { action in
                selectedTimer = timerItems.lastIndex(of: timer) ?? 0
                activeSheet = 0
                showingSheet = true
            }

            // Then we add edit as a child of the main menu
            let mainMenu = UIMenu(title: "", children: [edit, info])
            return mainMenu
        }
        return configuration
    }
    
    var dragDropConfig: ASDragDropConfig<TimerItem>
    {
        ASDragDropConfig(dragEnabled: true, dropEnabled: true, reorderingEnabled: true, onMoveItem:  { (from, to) -> Bool in
            
            return false
        })
            .canDragItem { (indexPath) -> Bool in
                false
            }
            .canMoveItem { (from, to) -> Bool in
                false
            }
        
        
    }
    
    
    
}

//MARK: - Previews

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
