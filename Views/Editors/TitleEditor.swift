//
//  TitleEditor.swift
//  TimerPlus
//
//  Created by Alexey Primechaev on 1/16/20.
//  Copyright © 2020 Alexey Primechaev. All rights reserved.
//

import SwiftUI
import Introspect
import WidgetKit

struct PlaceHolder<T: View>: ViewModifier {
    var placeHolder: T
    var show: Bool
    func body(content: Content) -> some View {
        ZStack(alignment: .leading) {
            if show { placeHolder }
            content
        }
    }
}

extension View {
    func placeHolder<T:View>(_ holder: T, show: Bool) -> some View {
        self.modifier(PlaceHolder(placeHolder:holder, show: show))
    }
}

struct TitleEditor: View {
    
    @State var title = LocalizedStringKey("")
    
    @State var value = String()
    
    @State var becomeFirstResponder = false
    
    @ObservedObject var timeItem = TimeItem()
    
    @Binding var textField: UITextField
    
    @Binding var isFocused: Bool
    
    var body: some View {
        TextField("", text: $timeItem.title) { (editingChanged) in
            if editingChanged {
                isFocused = true
            } else {
                isFocused = false
            }
        }
        .introspectTextField { field in
            if becomeFirstResponder {
                field.becomeFirstResponder()
            }
            textField = field
        }
        .onChange(of: timeItem.title) { newValue in
            try? timeItem.managedObjectContext?.save()
            WidgetCenter.shared.reloadAllTimelines()
        }
        .fontSize(.title)
        .foregroundColor(.primary)
        .accentColor(Color.primary)
        .placeHolder(Text(timeItem.title.isEmpty ? timeItem.isStopwatch ? "Stopwatch ⏱" : Strings.timer : LocalizedStringKey(timeItem.title)).fontSize(.title).opacity(0.5).animation(nil), show: timeItem.title.isEmpty)
        .padding(7)
        
        .animation(nil)
        
    }
}



