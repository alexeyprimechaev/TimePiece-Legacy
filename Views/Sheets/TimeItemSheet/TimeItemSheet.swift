//
//  TimerPlusDetailView.swift
//  TimerPlus
//
//  Created by Alexey Primechaev on 1/6/20.
//  Copyright © 2020 Alexey Primechaev. All rights reserved.
//

import SwiftUI
import Introspect
import AVFoundation
import CoreData

struct TimeItemSheet: View {
    
    
    @ObservedObject var timeItem = TimeItem()
    
    @EnvironmentObject var settings: Settings
    
        
    @State var picking: String = "Off"
        
    @State var titleField = UITextField()
    @State var timeField = UITextField()
    
    @State var titleFocused = false
    @State var timeFocused = false
    
    @State var showLogSheet = false
    
    @State var timeFieldDummy = UITextField()
    @State var timeFocusedDummy = false
    
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    
    var discard: () -> Void
    
    var delete: () -> Void
    
    var body: some View {
        
        
        VStack(spacing:0) {
            
            HeaderBar(showingMenu: timeItem.isRunning ? false : true) {
                RegularButton(title: Strings.dismiss, icon: "chevron.down") {
                    discard()
                }
            } trailingItems: {
                if timeItem.isRunning {
                    SummaryMenu(timeItem: timeItem) {
                        delete()
                    }
                } else {
                    RegularButton(title: Strings.delete, icon: "trash", isDestructive: true) {
                        delete()
                    }
                }
            }.animation(.default, value: timeItem.isRunning).transition(.slide)
        
            TitledScrollView {
                VStack(alignment: .leading, spacing: 14) {
                    DetailEditors(timeItem: timeItem, titleField: $titleField, timeField: $timeField, titleFocused: $titleFocused, timeFocused: $timeFocused)
                    
                    if !timeItem.isRunning {
                        DetailPickers(timeItem: timeItem)

                    }
                    DetailActions(timeItem: timeItem, presentation: timeItem.isRunning ? .compact : .normal)
                }.animation(.default, value: timeItem.isRunning)
                
                .padding(.top, 14)
                
            }
            
            DetailPrimaryActions(timeItem: timeItem, titleField: $titleField, timeField: $timeField, titleFocused: $titleFocused, timeFocused: $timeFocused)
            
        }
    }
    
}
