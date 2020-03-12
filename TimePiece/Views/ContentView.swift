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
    @FetchRequest(fetchRequest: TimerPlus.getAllTimers()) var timers: FetchedResults<TimerPlus>
    
    @EnvironmentObject var settings: Settings
    
    //MARK: State Variables
    @State var showingNewTimerSheet = false
    @State var isAdding = false
    
    @State var showingTimerSheet = false
    @State var selectedTimer = 0
    
    @State var showingSettingsSheet = false
        
//MARK: - View
    
    var body: some View {
        ASCollectionView(
            sections:
            [
        //MARK: Title
                ASCollectionViewSection(id: 0) {
                    HStack(alignment: .bottom, spacing: 4) {
                        Text("TimePiece")
                            .titleStyle()
//                        Image("PlusIcon")
//                            .padding(.bottom, 9)
                    }
                        .padding(7)
                        .padding(.vertical, 12)
                        
                },
                
                
        //MARK: Timers
                ASCollectionViewSection(id: 1, data: timers, dataID: \.self, contextMenuProvider: contextMenuProvider) { timer, _ in
                    TimerView(timer: timer).fixedSize().environmentObject(self.settings)
                        
                },
                
                
        //MARK: Button
                ASCollectionViewSection(id: 2) {
                    TimerButton(title: "New", icon: "+", action: {
                        TimerPlus.newTimer(totalTime: 0, title: "", context: self.context, reusableSetting: self.settings.isReusableDefault, soundSetting: self.settings.soundSettingDefault, precisionSetting: self.settings.precisionSettingDefault, notificationSetting: self.settings.notificationSettingDefault)
                        self.showingNewTimerSheet = true
                    }).padding(.vertical, 12)
                    .sheet(isPresented: self.$showingSettingsSheet) {
                        SettingsSheet(discard: {self.showingSettingsSheet.toggle()}).environmentObject(self.settings)
                    }
                    TimerButton(title: "Settings", icon: "ellipsis.circle.fill", sfSymbolIcon: true, action: {
                        self.showingSettingsSheet = true
                    })
                    .betterSheetIsModalInPresentation(true)
                        .betterSheet(isPresented: $showingNewTimerSheet, onDismiss: {
                            if self.isAdding {
                                
                            } else {
                                self.deleteLast()
                            }
                        }) {
                            NewTimerSheet(timer: self.timers[self.timers.count-1], isAdding: self.$isAdding, discard: {self.showingNewTimerSheet = false}).environmentObject(self.settings)
                    }
                }
            ]
        )
            
        //MARK: Layout Configuration
        .layout {
            let fl = AlignedFlowLayout()
            fl.sectionInset = UIEdgeInsets(top: 0, left: 21, bottom: 0, right: 7)
            fl.minimumInteritemSpacing = 14
            fl.minimumLineSpacing = 14
            fl.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
            return fl
        }
        
            
        //MARK: Sheet
        .sheet(isPresented: self.$showingTimerSheet) {
            TimerSheet(timer: self.timers[self.selectedTimer], discard: {self.showingTimerSheet = false}, delete: {
                self.timers[self.selectedTimer].remove(from: self.context)
                self.showingTimerSheet = false
            }).environmentObject(self.settings)
        }
        .betterSheet(isPresented: $settings.showingSubscription) {
            SubscriptionSheet(discard: {
                self.settings.showingSubscription = false
            }).environmentObject(self.settings)
        }
        
        
    }
    
//MARK: - Data Functions
    
    
    
    //MARK: Delete
    func deleteLast() {
        timers[timers.count - 1].remove(from: context)
    }
    
//MARK: - CollectionView Functions
    
    
    
    //MARK: Context Menu
    func contextMenuProvider(_ timer: TimerPlus) -> UIContextMenuConfiguration? {
        let configuration = UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { (suggestedActions) -> UIMenu? in
            let deleteCancel = UIAction(title: "Cancel", image: UIImage(systemName: "xmark")) { action in }
            let deleteConfirm = UIAction(title: timer.isRunning ? "Stop" : "Delete", image: UIImage(systemName: timer.isRunning ? "stop" : "trash"), attributes: self.settings.isMonochrome ? UIMenuElement.Attributes() : .destructive) { action in
                if !(timer.isRunning) {
                    timer.remove(from: self.context)
                    try? self.context.save()
                } else {
                    timer.reset()
                }
               
            }
            
            let deleteConfirmReusable = UIAction(title: "Delete", image: UIImage(systemName: "trash"), attributes: self.settings.isMonochrome ? UIMenuElement.Attributes() : .destructive) { action in
                timer.remove(from: self.context)
                try? self.context.save()
               
            }

            // The delete sub-menu is created like the top-level menu, but we also specify an image and options
            let delete = UIMenu(title: timer.isRunning ? "Stop" : "Delete", image: UIImage(systemName: timer.isRunning ? "stop" : "trash"), options: self.settings.isMonochrome ? UIMenu.Options() : .destructive, children: [deleteCancel, deleteConfirm])
            

            let pause = UIAction(title: timer.isPaused ? "Start" : "Pause", image: UIImage(systemName: timer.isPaused ? "play" : "pause")) { action in
                if timer.currentTime == 0 {
                    if timer.isReusable {
                        timer.reset()
                    } else {
                        timer.remove(from: self.context)
                    }
                } else {
                    timer.togglePause()
                }
            }
            
            let makeReusable = UIAction(title: "Make Reusable", image: UIImage(systemName: "arrow.clockwise")) { action in
                if self.settings.isSubscribed {
                    timer.makeReusable()
                } else {
                    self.settings.showingSubscription = true
                }
            }
            
            let deleteReusable = UIMenu(title: "Delete", image: UIImage(systemName: "trash"), options: self.settings.isMonochrome ? UIMenu.Options() : .destructive, children: [deleteCancel, deleteConfirmReusable])
            

            // The edit menu adds delete as a child, just like an action
            let edit = UIMenu(title: "Edit...", options: .displayInline, children: timer.isReusable ? [pause, delete] : [pause, makeReusable, deleteReusable])

            let info = UIAction(title: "Show Details", image: UIImage(systemName: "ellipsis")) { action in
                self.selectedTimer = self.timers.firstIndex(of: timer) ?? 0
                self.showingTimerSheet = true
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
