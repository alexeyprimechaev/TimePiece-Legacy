//
//  Styles.swift
//  TimerPlus
//
//  Created by Alexey Primechaev on 1/27/20.
//  Copyright © 2020 Alexey Primechaev. All rights reserved.
//

import SwiftUI

struct TitleStyle: ViewModifier {
    
    var design: Font.Design?
    
    func body(content: Content) -> some View {
        content
            .font(.system(size: 34, weight: .bold, design: design ?? .default))
    }
}

struct SecondaryTitleStyle: ViewModifier {
    
    var design: Font.Design?
    
    func body(content: Content) -> some View {
        content
            .font(.system(size: 34, weight: .bold, design: design ?? .default))
            .opacity(0.5)
    }
}

struct SmallTitleStyle: ViewModifier {
    
    var design: Font.Design?
    
    func body(content: Content) -> some View {
        content
            .font(.system(size: 17, weight: .semibold, design: design ?? .default))
    }
}

extension View {
    func titleStyle(design: Font.Design? = .default) -> some View {
        self.modifier(TitleStyle(design: design))
    }
    
    func secondaryTitleStyle(design: Font.Design? = .default) -> some View {
        self.modifier(SecondaryTitleStyle(design: design))
    }
    
    func smallTitleStyle(design: Font.Design? = .default) -> some View {
        self.modifier(SmallTitleStyle(design: design))
    }
}
