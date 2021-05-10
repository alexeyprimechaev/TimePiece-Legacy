//
//  SubscriptionPointView.swift
//  TimePiece (iOS)
//
//  Created by Alexey Primechaev on 2/22/21.
//  Copyright © 2021 Alexey Primechaev. All rights reserved.
//

import SwiftUI

enum PointSize {
    case small, medium, large
}

struct SubscriptionPointView: View {
    
    @State var style: PointSize = .small
    
    @State private var hasAppeared = false
    
    @State var color = Color.primary
    @State var image = "ellipsis.circle.fill"
    @State var isSFSymbol = true
    @State var text = "Unlock Reusable Timers"
    @State var images = [String]()
    @State var colors = [Color]()
    
    @State var spacerWidth: CGFloat = 40
    
    @ViewBuilder
    var body: some View {
        Group {
            switch style {
            case .small:
                VStack(spacing: 14) {
                    Group {
                        if isSFSymbol {
                            Image(systemName: image).foregroundColor(color)
                        } else {
                            Image(image)
                        }
                    }
                    .font(Font.system(size: 34, weight: .medium))
                    .scaleEffect(hasAppeared ? 1 : 0)
                    .animation(Animation.easeOut(duration: 0.5).delay(Double.random(in: 0...0.2)), value: hasAppeared)
                    Spacer()
                }
            case .medium:
                VStack {
                    HStack {
                        ForEach(images.indices) { i in
                            if isSFSymbol {
                                Image(systemName: images[i])
                                    .foregroundColor(colors[i])
                                    .font(Font.system(size: 30, weight: .medium))
                                    .scaleEffect(hasAppeared ? 1 : 0)
                                    .animation(.easeOut(duration: 0.5).delay(Double.random(in: 0...0.2)), value: hasAppeared)
                            } else {
                                Image(images[i])
                                    .resizable()
                                    .aspectRatio(1, contentMode: .fit)
                                    .frame(width: 72, height: 72)
                                    .scaleEffect(hasAppeared ? 1 : 0)
                                    .animation(.easeOut(duration: 0.5).delay(Double.random(in: 0...0.2)), value: hasAppeared)
                            }
                        }
                    }

                    Spacer()

                }
            case .large:
                VStack {
                    if isSFSymbol {
                        Spacer().frame(height: 30)
                        ScrollView(.horizontal, showsIndicators: false) {
                            ScrollViewReader { scrollView in
                                HStack {
                                    Spacer().frame(width: spacerWidth)
                            
                                    VStack(spacing: 5) {
                                    HStack {
                                        ForEach(0...5, id: \.self) { _ in
                                            ForEach(0...8, id: \.self) { i in
                                                Text(images[i]).scaleEffect(hasAppeared ? 1 : 0.6)
                                                    .animation(.easeOut(duration: 0.3).delay(Double.random(in: 0.2...0.6)), value: hasAppeared)
                                            }
                                        }
                                    }
                                    HStack {
                                        Text(images[0]).opacity(0)
                                        ForEach(0...5, id: \.self) { _ in
                                            ForEach(9...17, id: \.self) { i in
                                                Text(images[i]).scaleEffect(hasAppeared ? 1 : 0.6)
                                                    .animation(.easeOut(duration: 0.3).delay(Double.random(in: 0.2...0.6)), value: hasAppeared)
                                            }
                                        }
                                    }
                                    HStack {
                                        ForEach(0...5, id: \.self) { _ in
                                            ForEach(18...26, id: \.self) { i in
                                                Text(images[i]).scaleEffect(hasAppeared ? 1 : 0.6)
                                                    .animation(.easeOut(duration: 0.3).delay(Double.random(in: 0.2...0.6)), value: hasAppeared)
                                            }
                                        }
                                    }
                                }.font(.largeTitle)
                                }
                                .onAppear {
                                    scrollView.scrollTo(6)
                                }
                            }
                        }
                        .disabled(true)
                        .animation(.linear(duration: 60).repeatForever(autoreverses: false))
                        .onAppear {
                            spacerWidth = 1000
                        }
                        .scaleEffect(hasAppeared ? 1 : 0.8)
                        .animation(.easeOut(duration: 0.5), value: hasAppeared)
                        Spacer()
                    } else {
                        Spacer().frame(height: 22)
                        Image(image)
                            .resizable()
                            .scaledToFit()
                            .frame(height: 136)
                            
                        Spacer()
                    }
                }
            }
        }
        .padding(style == .large ? 0 : isSFSymbol ? 20 : 6).frame(maxWidth: .infinity, maxHeight: .infinity).background(RoundedRectangle(cornerRadius: 16, style: .continuous).foregroundColor(Color("button.gray"))).overlay( Text(text).fontSize(.secondaryText).padding(.bottom, 14).padding(.horizontal, 4).lineLimit(2).multilineTextAlignment(.center), alignment: .bottom)
        .clipped()
        .onAppear {
            hasAppeared = true
        }
        
    }
}

struct SubscriptionPointView_Previews: PreviewProvider {
    static var previews: some View {
        SubscriptionPointView()
    }
}
