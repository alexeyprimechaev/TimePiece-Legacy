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
        
    @Binding var property: String?
    
    @State var value = ""
    
    @State var title = ""
    
    var body: some View {
        HStack(spacing: 7) {
            TextField("", text: $value){
                self.property = self.value
                self.value = self.property ?? "Found nil"
            }
                .onAppear() {
                    self.value = self.property ?? "Found nil"
                    
                }
                .introspectTextField(customize: { textField in
                    textField.font = UIFont(name: "AppleColorEmoji", size: 34)
                    textField.font = UIFont.systemFont(ofSize: 34, weight: .bold)
                    textField.tintColor = UIColor.label
                })
                .font(.system(size: 34, weight: .bold))
            
            Text(title)
            .font(.headline)
            .fontWeight(.semibold)
            .padding(.bottom, 5)
                .opacity(0.5)
        }
        .padding(7)
        
            
    }
}

