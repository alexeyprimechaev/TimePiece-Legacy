//
//  TopBar.swift
//  TimePiece (iOS)
//
//  Created by Alexey Primechaev on 2/21/21.
//  Copyright © 2021 Alexey Primechaev. All rights reserved.
//

import SwiftUI

struct TopBar: View {
    
    @EnvironmentObject var appState: AppState
    @EnvironmentObject var settings: Settings
    
    @Binding var showDivider: Bool
    
    @State var alwaysShowTitle = false
    
    @State var title: LocalizedStringKey
    
    var body: some View {
        VStack(spacing: 0) {
            ZStack {
                HStack {
                    if alwaysShowTitle {
                        Text(title).fontSize(.smallTitle).opacity(showDivider ? 0 : 1).padding(14)
                    } else {
                        Text(title).fontSize(.smallTitle).opacity(showDivider ? 0 : 1).padding(14)
                    }
                }
                HStack {
                    Spacer()
                    if appState.isInEditing {
                        Button {
                            appState.isInEditing.toggle()
                            appState.selectedValues = []
                        } label: {
                            Text("Done").foregroundColor(.primary)
                        }.foregroundColor(.primary).padding(14).padding(.horizontal, 14)
                    } else {
                        Menu {
                            Button {
                                appState.isInEditing.toggle()
                                appState.selectedValues = []
                            } label: {
                                HStack {
                                    Text("Select")
                                    Image(systemName: "checkmark.circle")
                                }
                            }
                            Divider()
                            Picker("Home View", selection: $settings.selectedView) {
                                HStack {
                                    Text("Grid")
                                    Image(systemName: "rectangle.grid.2x2")
                                }.tag(ViewType.grid)
                                Button {
                                    if !settings.isSubscribed {
                                        appState.activeSheet = 4
                                        appState.showingSheet = true
                                    }
                                } label: {
                                    Text("Classic")
                                    Image(systemName: "textformat")
                                }.tag(ViewType.classic)
                            }
                            Divider()
                            Button {
                                appState.activeSheet = 4
                                appState.showingSheet = true
                            } label: {
                                HStack {
                                    Text("Show Subscription")
                                    Image(systemName: "gear")
                                }
                            }
                        } label: {
                            Image(systemName: "ellipsis.circle")
                                .foregroundColor(.primary).padding(10).padding(.horizontal, 18).font(.title2)
                        }
                    }
                }
            }.animation(nil)

        }.animation(.easeOut(duration: 0.2))
    }
}
