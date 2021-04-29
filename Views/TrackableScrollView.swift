//
//  TrackableScrollView.swift
//  TimePiece (iOS)
//
//  Created by Alexey Primechaev on 2/21/21.
//  Copyright © 2021 Alexey Primechaev. All rights reserved.
//

import SwiftUI

enum TitleType {
    case small, large, empty
}

struct TitledScrollView<Content: View>: View {
    
    var title: LocalizedStringKey
    private var type: TitleType
    @State private var isLarge = true
    
    @State private var scrollOffset: CGFloat = .zero
    
    let content: Content
    
    init(title: LocalizedStringKey, alwaysSmall: Bool = false, @ViewBuilder content: @escaping () -> Content) {
        self.title = title
        if alwaysSmall {
            self.type = .small
        } else {
            self.type = .large
        }
        
        self.content = content()
    }
    
    init(@ViewBuilder content: @escaping () -> Content) {
        self.title = ""
        self.type = .empty
        self.content = content()
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            switch type {
            case .empty:
                EmptyView()
            case .small:
                TopBar(showDivider: $isLarge, alwaysShowTitle: true, title: title)
            case .large:
                TopBar(showDivider: $isLarge, title: title)
            }
            Divider().opacity(isLarge ? 0 : 1).animation(.easeOut(duration: 0.1))
            
            TrackableScrollView {
                scrollOffset = $0
            } content: {
                VStack(alignment: .leading, spacing: 0) {
                    if type == .large {
                        Text(title).fontSize(.title).padding(.bottom, 21).padding(.leading, 7)
                    }
                    content
                }.padding(.horizontal, 21).padding(.vertical, type == .empty ? 0 : 14)
            }
            .onChange(of: scrollOffset) { newValue in
                if newValue <= -32 {
                    isLarge = false
                } else if newValue > -32  {
                    isLarge = true
                }
            }
        }
    }
}

private struct TrackableScrollView<Content: View>: View {
  let onOffsetChange: (CGFloat) -> Void
  let content: () -> Content

  init(
    onOffsetChange: @escaping (CGFloat) -> Void,
    @ViewBuilder content: @escaping () -> Content
  ) {
    self.onOffsetChange = onOffsetChange
    self.content = content
  }

  var body: some View {
    ScrollView {
      offsetReader
      content()
        .padding(.top, -21)
    }
    .coordinateSpace(name: "frameLayer")
    .onPreferenceChange(OffsetPreferenceKey.self, perform: onOffsetChange)
  }

  var offsetReader: some View {
    GeometryReader { proxy in
      Color.clear
        .preference(
          key: OffsetPreferenceKey.self,
          value: proxy.frame(in: .named("frameLayer")).minY
        )
    }
    .frame(height: 0)
  }
}

private struct OffsetPreferenceKey: PreferenceKey {
  static var defaultValue: CGFloat = .zero
  static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {}
}
