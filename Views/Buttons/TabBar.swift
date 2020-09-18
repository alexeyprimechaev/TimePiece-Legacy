//
//  TabBar.swift
//  TimePiece
//
//  Created by Alexey Primechaev on 5/30/20.
//  Copyright © 2020 Alexey Primechaev. All rights reserved.
//

import SwiftUI

struct TabBar: View {
    
    var actions: [() -> ()]
    
    @EnvironmentObject var settings: Settings
    
    @State var showingSubscriptionSheet = false
    
    var body: some View {
        VStack(spacing: 0) {
            Divider()
            HStack(spacing: 0) {
                Spacer().frame(width: 14)
                TabItem(title: newString,icon: "plus") {
                    self.actions[0]()
                }
                TabItem(title: logString, icon: "bolt") {
                    self.actions[1]()
                }.overlay(
                        Circle().frame(width: 7, height: 7).foregroundColor(.red).padding(.top, 7).padding(.leading, 26).opacity(settings.hasSeenTrends ? 0 : 1)
                    , alignment: .topLeading)
                TabItem(title: settingsString, icon: "gear") {
                    self.actions[2]()
                }
                Spacer()
            }
        }
        .fullScreenCover(isPresented: $showingSubscriptionSheet) {
            SubscriptionSheet {
                self.showingSubscriptionSheet = false
            }
            .environmentObject(self.settings)
        }

    }
}

struct TabItem: View {
    
    @State var title = LocalizedStringKey("")
    
    @State var icon = "plus"
    
    var action: () -> Void
    
    var body: some View {
        Button {
            self.action()
            regularHaptic()
        } label: {
            Label {
                Text(title).fontSize(.smallTitle)
            } icon: {
                Image(systemName: icon).font(.headline)
            }
            .lineLimit(1)
            .padding(14)
        
        }.foregroundColor(.primary)
        
    }
}
