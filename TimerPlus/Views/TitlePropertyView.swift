//
//  EditablePropertyView.swift
//  TimerPlus
//
//  Created by Alexey Primechaev on 1/16/20.
//  Copyright © 2020 Alexey Primechaev. All rights reserved.
//

import SwiftUI
import Introspect

struct TitlePropertyView: View {
    
    @Environment(\.managedObjectContext) var context
        
    @Binding var title: String?
    
    @State var value = ""
    
    var body: some View {
        TextField("", text: $value){
            self.title = self.value
            self.value = self.title ?? "Found nil"
        }
            .onAppear() {
                self.value = self.title ?? "Found nil"
                
            }
            .introspectTextField(customize: { textField in
                textField.font = UIFont(name: "AppleColorEmoji", size: 34)
                textField.font = UIFont.systemFont(ofSize: 34, weight: .bold)
                textField.tintColor = UIColor.label
            })
            .font(.system(size: 34, weight: .bold))
            
    }
}

