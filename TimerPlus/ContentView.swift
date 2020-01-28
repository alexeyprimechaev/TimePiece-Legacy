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
    
    @Environment(\.managedObjectContext) var context
    @FetchRequest(fetchRequest: TimerPlus.getAllTimers()) var timers: FetchedResults<TimerPlus>
    
    @State var showingNewTimerView = false
    @State var showingDetailTimerView = false
    
    @State var selectedTimer = 0
    
    func delete() {
        context.delete(timers[timers.count-1])
    }
    
    var body: some View {
        ASCollectionView(
            sections:
            [
                
                // Title
                ASCollectionViewSection(id: 0) {
                    Text("Timer+")
                        .titleStyle()
                        .padding(7)
                        .padding(.vertical, 12)
                        
                },
                
                // Timers
                ASCollectionViewSection(id: 1, data: timers, dataID: \.self, contextMenuProvider: contextMenuProvider) { timer, _ in
                    TimerView(timer: timer).fixedSize()
                        
                },
                
                // Button
                ASCollectionViewSection(id: 2) {
                    TimerButton(onTap: {
                        TimerPlus.newTimer(totalTime: 60, title: "Timer", context: self.context)
                        self.showingNewTimerView = true
                    })
                    .sheet(isPresented: $showingNewTimerView) {
                        NewTimerView(timer: self.timers[self.timers.count-1], onDismiss: {self.showingNewTimerView = false}, delete: {self.delete()})
                    }
                }
                
            ]
        )
        .layout {
            let fl = AlignedFlowLayout()
            fl.sectionInset = UIEdgeInsets(top: 0, left: 21, bottom: 0, right: 7)
            fl.minimumInteritemSpacing = 14
            fl.minimumLineSpacing = 14
            fl.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
            return fl
        }
        .sheet(isPresented: self.$showingDetailTimerView) {
            TimerDetailView(timer: self.timers[self.selectedTimer], onDismiss: {self.showingDetailTimerView = false}, delete: {
                self.context.delete(self.timers[self.selectedTimer])
                    self.showingDetailTimerView = false
                })
            }

    }
    
    func contextMenuProvider(_ timer: TimerPlus) -> UIContextMenuConfiguration? {
        let configuration = UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { (suggestedActions) -> UIMenu? in
            let deleteCancel = UIAction(title: "Cancel", image: UIImage(systemName: "xmark.circle.fill")) { action in }
            let deleteConfirmation = UIAction(title: timer.isPaused?.boolValue ?? true ? "Delete" : "Stop", image: UIImage(systemName: timer.isPaused?.boolValue ?? true ? "trash.fill" : "stop.fill"), attributes: .destructive) { action in
                if(timer.isPaused?.boolValue ?? false) {
                    self.context.delete(timer)
                    try? self.context.save()
                } else {
                    timer.reset()
                }
               
            }

            // The delete sub-menu is created like the top-level menu, but we also specify an image and options
            let delete = UIMenu(title: timer.isPaused?.boolValue ?? true ? "Delete" : "Stop", image: UIImage(systemName: timer.isPaused?.boolValue ?? true ? "trash.fill" : "stop.fill"), options: .destructive, children: [deleteCancel, deleteConfirmation])

            let pause = UIAction(title: timer.isPaused?.boolValue ?? true ? "Start" : "Pause", image: UIImage(systemName: timer.isPaused?.boolValue ?? true ? "play.fill" : "pause.fill")) { action in
                timer.togglePause()
            }
            
            let stop = UIAction(title: "Stop", image: UIImage(systemName: "stop"), attributes: .destructive) { action in
                timer.reset()
            }

            // The edit menu adds delete as a child, just like an action
            let edit = UIMenu(title: "Edit...", options: .displayInline, children: [pause, delete])

            let info = UIAction(title: "Show Details", image: UIImage(systemName: "ellipsis.circle")) { action in
                self.selectedTimer = self.timers.firstIndex(of: timer) ?? 0
                self.showingDetailTimerView = true
            }

            // Then we add edit as a child of the main menu
            let mainMenu = UIMenu(title: "", children: [edit, info])
            return mainMenu
        }
        return configuration
    }
    
    
    
}

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

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
