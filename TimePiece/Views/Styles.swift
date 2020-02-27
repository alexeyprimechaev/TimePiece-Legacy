//
//  Styles.swift
//  TimerPlus
//
//  Created by Alexey Primechaev on 1/27/20.
//  Copyright © 2020 Alexey Primechaev. All rights reserved.
//

import SwiftUI

//MARK: - Text Styles



//MARK: Title Style
struct TitleStyle: ViewModifier {
    
    @EnvironmentObject var settings: Settings
    
    var design: Font.Design?
    
    func body(content: Content) -> some View {
        content
            .font(.system(size: 34, weight: .bold, design: settings.fontDesign))
    }
}


//MARK: Secondary Title Style
struct SecondaryTitleStyle: ViewModifier {
    
    var design: Font.Design?
    
    func body(content: Content) -> some View {
        content
            .font(.system(size: 34, weight: .bold, design: design ?? .default))
            .opacity(0.5)
    }
}


//MARK: Small Title Style
struct SmallTitleStyle: ViewModifier {
    
    var design: Font.Design?
    
    func body(content: Content) -> some View {
        content
            .font(.system(size: 17, weight: .semibold, design: design ?? .default))
    }
}


//MARK: Application Functions
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


//MARK: - Button Styles
struct RegularButtonStyle: ButtonStyle {

    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.96 : 1.0)
            .opacity(configuration.isPressed ? 0.5 : 1.0)
    }

}
