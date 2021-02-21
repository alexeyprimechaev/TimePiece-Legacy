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
    
    @Binding var isLarge: Bool
    
    var body: some View {
        VStack(spacing: 0) {
            ZStack {
                HStack {
                    Text(Strings.timePiece).fontSize(.smallTitle).opacity(isLarge ? 0 : 1).padding(14)
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
                            Picker("", selection: $appState.selectedView) {
                                HStack {
                                    Text("Grid")
                                    Image(systemName: "rectangle.grid.2x2")
                                }.tag(ViewType.grid)
                                HStack {
                                    Text("Classic")
                                    Image(systemName: "textformat")
                                }.tag(ViewType.classic)
                            }
                        } label: {
                            Image(systemName: "ellipsis.circle")
                                .foregroundColor(.primary).padding(14).padding(.horizontal, 14).font(.headline)
                        }
                    }
                }
            }.animation(nil)

            Divider().opacity(isLarge ? 0 : 1)
        }.animation(.easeOut(duration: 0.2))
    }
}
