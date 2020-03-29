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
        
    func body(content: Content) -> some View {
        content
            .font(.system(size: 34, weight: .bold, design: settings.fontDesign))
            .saturation(settings.isMonochrome ? 0 : 1)
    }
}

//MARK: Small Title Style
struct SmallTitleStyle: ViewModifier {
    
    @EnvironmentObject var settings: Settings
    
    func body(content: Content) -> some View {
        content
            .font(.system(size: 17, weight: .semibold, design: settings.fontDesign))
            .saturation(settings.isMonochrome ? 0 : 1)
    }
}

struct SecondaryTextStyle: ViewModifier {
    
    @EnvironmentObject var settings: Settings
    
    func body(content: Content) -> some View {
        content
            .font(.system(size: 14, weight: .medium, design: settings.fontDesign)).multilineTextAlignment(.center)
            .saturation(settings.isMonochrome ? 0 : 1)
    }
}


//MARK: Application Functions
extension View {
    func title(design: Font.Design? = .default) -> some View {
        self.modifier(TitleStyle())
    }
    
    func smallTitle(design: Font.Design? = .default) -> some View {
        self.modifier(SmallTitleStyle())
    }
    
    func secondaryText(design: Font.Design? = .default) -> some View {
        self.modifier(SecondaryTextStyle())
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
