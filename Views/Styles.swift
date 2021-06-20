//
//  Styles.swift
//  TimerPlus
//
//  Created by Alexey Primechaev on 1/27/20.
//  Copyright © 2020 Alexey Primechaev. All rights reserved.
//

import SwiftUI

//MARK: - Text Styles


public enum FontSize {
    case title, title2, smallTitle, secondaryText
}

//MARK: Small Title Style

struct FontStyle: ViewModifier {
    
    @EnvironmentObject var settings: Settings
    
    @State var fontSize: FontSize
    
    @State var changeDesign = true
    
    func body(content: Content) -> some View {
        
        switch fontSize {
        case .title:
            content
                .font(Font.system(.largeTitle, design: changeDesign ? settings.fontDesign : .default).bold().monospacedDigit())
                .saturation(settings.isMonochrome ? 0 : 1)
        case .smallTitle:
            content
                .font(Font.system(.headline, design: changeDesign ? settings.fontDesign : .default).monospacedDigit())
                .saturation(settings.isMonochrome ? 0 : 1)
        case .secondaryText:
            content
                .font(Font.system(size: 13, weight: .medium, design: changeDesign ? settings.fontDesign : .default))
                .saturation(settings.isMonochrome ? 0 : 1)
        case .title2:
            content
                .font(Font.system(.title2, design: changeDesign ? settings.fontDesign : .default).bold())
                .saturation(settings.isMonochrome ? 0 : 1)
        }
        
        
           
    }
}

//MARK: Application Functions
extension View {
    func fontSize(_ size: FontSize = .title, changeDesign: Bool = true) -> some View {
        return self.modifier(FontStyle(fontSize: size))
    }
}


//MARK: - Button Styles
struct TitleButtonStyle: ButtonStyle {
    
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.96 : 1.0)
            .opacity(configuration.isPressed ? 0.5 : 1.0)
            .animation(.easeOut(duration: 0.2))
    }
    
}

struct CellButtonStyle: ButtonStyle {
    
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .opacity(configuration.isPressed ? 0.5 : 1.0)
            .animation(.easeOut(duration: 0.2))
    }
    
}

struct RegularButtonStyle: ButtonStyle {
    
    func makeBody(configuration: Self.Configuration) -> some View {
        
        configuration.label
            .opacity(configuration.isPressed ? 0.33 : 1.0)
            .animation(.easeOut(duration: 0.2))
            .contentShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
        
    }
    
}

struct PrimaryButtonStyle: ButtonStyle {
    
    func makeBody(configuration: Self.Configuration) -> some View {
        
        configuration.label
            .opacity(configuration.isPressed ? 0.5 : 1.0)
            .onChange(of: configuration.isPressed) { newValue in
                if newValue == true {
                    regularHaptic()
                } else {
                    regularHaptic()
                }
                
            }
        
    }
    
}

public func regularHaptic() {
    let generator = UIImpactFeedbackGenerator(style: .rigid)
    generator.impactOccurred()
}

public func mediumHaptic() {
    let generator = UIImpactFeedbackGenerator(style: .medium)
    generator.impactOccurred()
}

public func hardHaptic() {
    let generator = UIImpactFeedbackGenerator(style: .heavy)
    generator.impactOccurred()
}

public func lightHaptic() {
    let generator = UIImpactFeedbackGenerator(style: .light)
    generator.impactOccurred()
}

public func softHaptic() {
    let generator = UIImpactFeedbackGenerator(style: .soft)
    generator.impactOccurred()
}
