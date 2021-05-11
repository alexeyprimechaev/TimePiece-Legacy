//
//  LogSectionSheet.swift
//  TimePiece (iOS)
//
//  Created by Alexey Primechaev on 5/11/21.
//  Copyright © 2021 Alexey Primechaev. All rights reserved.
//

import SwiftUI

struct LogSectionSheet: View {
    
    @EnvironmentObject var appState: AppState
    @EnvironmentObject var settings: Settings
    @State var logItemSection: [LogItem]
    @State var segment: LogSegment
    @State private var showingDeleteAlert = false
    
    var discard: () -> ()
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HeaderBar(showingMenu: false) {
                RegularButton(title: "Back", icon: "chevron.down") {
                    discard()
                    appState.editingLogScreen = false
                    appState.selectedLogItems = []
                }
            } trailingItems: {
                if appState.editingLogScreen {
                    RegularButton(title: "Done", icon: "") {
                        appState.editingLogScreen = false
                    }
                } else {
                    Menu {
                        RegularButton(title: "Select", icon: "checkmark.circle") {
                            appState.editingLogScreen = true
                        }
                    } label: {
                        Image(systemName: "ellipsis.circle")
                            .foregroundColor(.primary).padding(7).font(.title2)
                    }
                }
            }
                LogSection(segment: segment, logItemSection: logItemSection, isCompact: false).environmentObject(appState).environmentObject(settings)
            
            if appState.editingLogScreen {
                BottomBar {
                    RegularButton(title: "Delete", icon: "trash", isDestructive: true) {
                        showingDeleteAlert = true
                    }.padding(.horizontal, 7).disabled(appState.selectedLogItems.count == 0).opacity(appState.selectedLogItems.count == 0 ? 0.33 : 1).animation(.easeOut(duration: 0.2), value: appState.selectedLogItems.count == 0).animation(nil)
                }.animation(.default)
            }
            
        }
        .alert(isPresented: $showingDeleteAlert) {
            Alert(title: Text("Delete selected Timers?"), primaryButton: .destructive(Text("Delete")) {
                
                withAnimation {
                    for logItem in appState.selectedLogItems {
                        logItem.managedObjectContext?.delete(logItem)
                    }
                }
                appState.selectedLogItems = []
                appState.editingLogScreen = false
            }, secondaryButton: .cancel())
        }
    }
}

