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
    @State var activeSheet: ActiveSheet = .settings
    
    @State var isAdding = false
    @State var selectedTimer = 0
    
    @State var isLarge = true
    
    @State var string = "000000"
        
        
//MARK: - View
    
    var body: some View {
        
        TimeView(timeString: $string)
//            VStack(spacing: 0) {
//                VStack(spacing: 0) {
//                    HStack {
//
//                        Text(timePieceString).smallTitle().opacity(isLarge ? 0 : 1).padding(14)
//
//
//                    }
//
//                    Divider().opacity(isLarge ? 0 : 1)
//                }.animation(.easeOut(duration: 0.2))
//
//            ASCollectionView(
//                sections:
//                [
//
//                    ASCollectionViewSection(id: 0) {
//                        Text(timePieceString).title().padding(.bottom, 14).padding(.leading, 7)
//                    },
//            //MARK: Timers
//                    ASCollectionViewSection(id: 1, data: timerItems, contextMenuProvider: contextMenuProvider) { timer, _ in
//                        TimerView(timer: timer).fixedSize().environmentObject(self.settings)
//
//                    },
//
//                    ASCollectionViewSection(id: 2) {
//                                        TimerButton(title: newString, icon: "plus.circle.fill", sfSymbolIcon: true, action: {
//                                            withAnimation(.default) {
//                                                TimerItem.newTimer(totalTime: 0, title: "", context: self.context, reusableSetting: self.settings.isReusableDefault, soundSetting: self.settings.soundSettingDefault, precisionSetting: self.settings.precisionSettingDefault, notificationSetting: self.settings.notificationSettingDefault, showInLog: self.settings.showInLogDefault)
//                                                activeSheet = .newTimer
//                                                showingSheet = true
//                                            }
//                                        }).padding(.vertical, 12)
//                                    }
//                ]
//            )
//
//
//            //MARK: Layout Configuration
//            .layout {
//                let fl = AlignedFlowLayout()
//                fl.sectionInset = UIEdgeInsets(top: 0, left: 21, bottom: 0, right: 7)
//                fl.minimumInteritemSpacing = 14
//                fl.minimumLineSpacing = 14
//                fl.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
//                return fl
//            }
//            .onScroll() { scroll, _ in
//                if scroll.y >= 48 {
//                    isLarge = false
//                } else if scroll.y < 48  {
//                    isLarge = true
//                }
//            }
//            .alwaysBounceVertical(true)
//                TabBar(actions: [
//                {
//                    withAnimation(.default) {
//                    TimerItem.newTimer(totalTime: 0, title: "", context: self.context, reusableSetting: self.settings.isReusableDefault, soundSetting: self.settings.soundSettingDefault, precisionSetting: self.settings.precisionSettingDefault, notificationSetting: self.settings.notificationSettingDefault, showInLog: self.settings.showInLogDefault)
//                        activeSheet = .newTimer
//                        showingSheet = true
//                    }
//                },{
//                    activeSheet = .trends
//                    showingSheet = true
//                },{
//                    activeSheet = .settings
//                    showingSheet = true
//                    }]).environmentObject(self.settings)
//
//            }
//    .animation(.default)
        
        
            
        //MARK: Sheet
        .sheet(isPresented: $showingSheet, onDismiss: {
            if activeSheet == .newTimer {
                if self.isAdding {
                    
                } else {
                    withAnimation(.default) {
                        self.deleteLast()
                    }
                }
            }
            
        }) {
            switch activeSheet {
    
                case .timer:
                    TimerSheet(timer: self.timerItems[self.selectedTimer], discard: {showingSheet = false}, delete: {
                        withAnimation(.default) {
                            self.timerItems[self.selectedTimer].remove(from: self.context)
                        }
                        showingSheet = false
                    }).environmentObject(self.settings)
                    
                case .newTimer:
                    NewTimerSheet(timer: self.timerItems[self.timerItems.count-1], isAdding: self.$isAdding, discard: {showingSheet = false}).environmentObject(self.settings)
                    
                case .settings:
                    SettingsSheet(discard: {showingSheet = false}).environmentObject(self.settings)
                case .trends:
                    LogSheet(discard: {showingSheet = false}).environmentObject(self.settings).environment(\.managedObjectContext, self.context)
                case .subscription:
                    SubscriptionSheet(discard: {
                        showingSheet = false
                        self.settings.showingSubscription = false
                    }).environmentObject(self.settings)
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
            let deleteConfirm = UIAction(title: timer.isRunning ? NSLocalizedString("stop", comment: "Stop") : NSLocalizedString("delete", comment: "Delete"), image: UIImage(systemName: timer.isRunning ? "stop" : "trash"), attributes: self.settings.isMonochrome ? UIMenuElement.Attributes() : .destructive) { action in
                if !(timer.isRunning) {
                    timer.remove(from: self.context)
                    try? self.context.save()
                } else {
                    timer.reset()
                }
               
            }
            
            let deleteConfirmReusable = UIAction(title: NSLocalizedString("delete", comment: "Delete"), image: UIImage(systemName: "trash"), attributes: self.settings.isMonochrome ? UIMenuElement.Attributes() : .destructive) { action in
                timer.remove(from: self.context)
                try? self.context.save()
               
            }

            // The delete sub-menu is created like the top-level menu, but we also specify an image and options
            let delete = UIMenu(title: timer.isRunning ? NSLocalizedString("stop", comment: "Stop") : NSLocalizedString("delete", comment: "Delete"), image: UIImage(systemName: timer.isRunning ? "stop" : "trash"), options: self.settings.isMonochrome ? UIMenu.Options() : .destructive, children: [deleteCancel, deleteConfirm])
            

            let pause = UIAction(title: timer.isPaused ? NSLocalizedString("start", comment: "Start") : NSLocalizedString("pause", comment: "Pause"), image: UIImage(systemName: timer.isPaused ? "play" : "pause")) { action in
                if timer.remainingTime == 0 {
                    if timer.isReusable {
                        timer.reset()
                    } else {
                        timer.remove(from: self.context)
                    }
                } else {
                    timer.togglePause()
                }
            }
            
            let makeReusable = UIAction(title: NSLocalizedString("makeReusable", comment: "Make Reusable"), image: UIImage(systemName: "arrow.clockwise")) { action in
                if self.settings.isSubscribed {
                    timer.makeReusable()
                } else {
                    activeSheet = .subscription
                    showingSheet = true
                }
            }
            
            let deleteReusable = UIMenu(title: NSLocalizedString("delete", comment: "Delete"), image: UIImage(systemName: "trash"), options: self.settings.isMonochrome ? UIMenu.Options() : .destructive, children: [deleteCancel, deleteConfirmReusable])
            

            // The edit menu adds delete as a child, just like an action
            let edit = UIMenu(title: "Edit...", options: .displayInline, children: timer.isReusable ? [pause, delete] : [pause, makeReusable, deleteReusable])

            let info = UIAction(title: NSLocalizedString("showDetails", comment: "Show Details"), image: UIImage(systemName: "ellipsis")) { action in
                self.selectedTimer = self.timerItems.lastIndex(of: timer) ?? 0
                activeSheet = .timer
                self.showingSheet = true
            }

            // Then we add edit as a child of the main menu
            let mainMenu = UIMenu(title: "", children: [edit, info])
            return mainMenu
        }
        return configuration
    }
    
    
}

//MARK: - CollectionView Layout

class AlignedFlowLayout: UICollectionViewFlowLayout {
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool
    {
        if let collectionView = self.collectionView
        {
            return collectionView.frame.width != newBounds.width // We only care about changes in the width
        }

        return false
    }

    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]?
    {
        let attributes = super.layoutAttributesForElements(in: rect)

        attributes?.forEach
        { layoutAttribute in
            guard layoutAttribute.representedElementCategory == .cell else
            {
                return
            }
            layoutAttributesForItem(at: layoutAttribute.indexPath).map { layoutAttribute.frame = $0.frame }
        }

        return attributes
    }

    private var leftEdge: CGFloat
    {
        guard let insets = collectionView?.adjustedContentInset else
        {
            return sectionInset.left
        }
        return insets.left + sectionInset.left
    }

    private var contentWidth: CGFloat?
    {
        guard let collectionViewWidth = collectionView?.frame.size.width,
            let insets = collectionView?.adjustedContentInset else
        {
            return nil
        }
        return collectionViewWidth - insets.left - insets.right - sectionInset.left - sectionInset.right
    }

    fileprivate func isFrame(for firstItemAttributes: UICollectionViewLayoutAttributes, inSameLineAsFrameFor secondItemAttributes: UICollectionViewLayoutAttributes) -> Bool
    {
        guard let lineWidth = contentWidth else
        {
            return false
        }
        let firstItemFrame = firstItemAttributes.frame
        let lineFrame = CGRect(
            x: leftEdge,
            y: firstItemFrame.origin.y,
            width: lineWidth,
            height: firstItemFrame.size.height)
        return lineFrame.intersects(secondItemAttributes.frame)
    }

    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes?
    {
        guard let attributes = super.layoutAttributesForItem(at: indexPath)?.copy() as? UICollectionViewLayoutAttributes else
        {
            return nil
        }
        guard attributes.representedElementCategory == .cell else
        {
            return attributes
        }
        guard
            indexPath.item > 0,
            let previousAttributes = layoutAttributesForItem(at: IndexPath(item: indexPath.item - 1, section: indexPath.section))
        else
        {
            attributes.frame.origin.x = leftEdge // first item of the section should always be left aligned
            return attributes
        }

        if isFrame(for: attributes, inSameLineAsFrameFor: previousAttributes)
        {
            attributes.frame.origin.x = previousAttributes.frame.maxX + 14
        }
        else
        {
            attributes.frame.origin.x = leftEdge
        }

        return attributes
    }
}

//MARK: - Previews

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
