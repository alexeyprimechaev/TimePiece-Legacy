//
//  SubscriptionPointView.swift
//  TimePiece (iOS)
//
//  Created by Alexey Primechaev on 2/22/21.
//  Copyright © 2021 Alexey Primechaev. All rights reserved.
//

import SwiftUI

enum PointSize {
    case small, medium, large
}

struct SubscriptionPointView: View {
    
    @State var style: PointSize = .small
    
    @State var image = "ellipsis.circle.fill"
    @State var isSFSymbol = true
    @State var text = "Placeholder Text"
    @State var images = [String]()
    
    @ViewBuilder
    var body: some View {
        switch style {
        case .small:
            VStack {
                Group {
                    if isSFSymbol {
                        Image(systemName: image)
                    } else {
                        Image(image)
                    }
                }
                Text(text)
            }.padding(14).frame(maxWidth: .infinity, maxHeight: .infinity).background(RoundedRectangle(cornerRadius: 16, style: .continuous).foregroundColor(Color(.systemGray6)))
        case .medium:
            VStack {
                HStack {
                    ForEach(images, id: \.self) { image in
                        if isSFSymbol {
                            Image(systemName: image)
                        } else {
                            Image(image)
                        }
                    }
                }
                Text(text)
                
            }.padding(14).frame(maxWidth: .infinity, maxHeight: .infinity).background(RoundedRectangle(cornerRadius: 16, style: .continuous).foregroundColor(Color(.systemGray6)))
        case .large:
            Text("No")
        }
        
    }
}

struct SubscriptionPointView_Previews: PreviewProvider {
    static var previews: some View {
        SubscriptionPointView()
    }
}
