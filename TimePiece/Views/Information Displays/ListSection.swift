//
//  CollapsibleTitle.swift
//  TimerPlus
//
//  Created by Alexey Primechaev on 2/25/20.
//  Copyright © 2020 Alexey Primechaev. All rights reserved.
//

import SwiftUI

struct ListSection<Content:View>: View {
    
    let title: String
    let content: Content

    init(title: String, @ViewBuilder content: @escaping () -> Content) {
        self.title = title
        self.content = content()
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text(title)
                .padding(.horizontal, 7)
                .padding(.top, 7)
                .smallTitle()
            VStack(alignment: .leading, spacing: 14) {
                content
            }
        }
    }
}
