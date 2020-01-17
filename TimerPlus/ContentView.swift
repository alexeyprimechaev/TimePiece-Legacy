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
    
    let strings = ["Hey"]
    
    var body: some View {
        ASCollectionView(
            sections:
            [
                ASCollectionViewSection(id: 0) {
                    Text("Timer+")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .padding(7)
                        .padding(.vertical, 12)
                        
                },
                ASCollectionViewSection(id: 1, data: timers, dataID: \.self) { timer, _ in
                    TimerView(timer: timer).padding(.vertical, 2).fixedSize()
                },
                ASCollectionViewSection(id: 2) {
                    TimerButton(onTap: {TimerPlus.newTimer(totalTime: 180, title: "Bacon 🥓", context: self.context)})
                    .padding(.vertical, 2)
                    .contextMenu {
                        Button(action: {
                             TimerPlus.newTimer(totalTime: 1800, title: "Steak 🥩", context: self.context)
                        }) {
                            Text("10 Seconds")
                        }
                        
                        Button(action: {
                             TimerPlus.newTimer(totalTime: 1200, title: "Soup 🍲", context: self.context)
                        }) {
                            Text("2 Minutes")
                        }
                        
                        Button(action: {
                             TimerPlus.newTimer(totalTime: 3605, title: "Pie 🥧", context: self.context)
                        }) {
                            Text("1 Hour 2 Secs")
                        }
                    }
                }
            ]
        
        )
        .layout {
            let fl = AlignedFlowLayout()
            fl.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
            return fl
        }
        .padding(.leading, 21)
        

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
