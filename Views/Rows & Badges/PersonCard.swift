//
//  PersonCard.swift
//  TimePiece
//
//  Created by Alexey Primechaev on 3/5/20.
//  Copyright © 2020 Alexey Primechaev. All rights reserved.
//

import SwiftUI

struct PersonCard: View {
    
    @EnvironmentObject var settings: Settings
    
    @State var name = LocalizedStringKey("")
    
    @State var description = LocalizedStringKey("")
    
    @State var link = String()
    
    @State var image = String()
    
    @State var icon = String()
    
    var body: some View {
        Button(action: {
            mediumHaptic()
            UIApplication.shared.open(URL(string: self.link)!)
        }) {
            HStack(alignment: .center, spacing: 7) {
                Image(image).frame(width: 44, height: 44).cornerRadius(.infinity).padding(7).saturation(settings.isMonochrome ? 0 : 1)
                VStack(alignment: .leading, spacing: 4) {
                    Text(name).fontSize(.smallTitle)
                    
                    Label {
                        Image(icon)
                    } icon: {
                        
                        Text(description).opacity(0.5).fontSize(.smallTitle)
                    }
                        
                        
                }
            }
        }.buttonStyle(RegularButtonStyle())
    }
}

struct PersonCard_Previews: PreviewProvider {
    static var previews: some View {
        PersonCard()
    }
}
