//
//  TitleEditor.swift
//  TimePiece (iOS)
//
//  Created by Alexey Primechaev on 8/29/20.
//  Copyright © 2020 Alexey Primechaev. All rights reserved.
//

import SwiftUI

struct TitleEditor: View {
    
    @State var text = "Hello there"
    var body: some View {
        HStack(alignment: .bottom, spacing: 7) {
            Text(text)
                .title()
                .background(Color.blue)
                .overlay(
                    TextEditor(text: $text).title().background(Color.red)
                )
            Text("Title").smallTitle()
        }
    }
}

struct TitleEditor_Previews: PreviewProvider {
    static var previews: some View {
        TitleEditor()
    }
}
