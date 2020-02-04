//
//  TimeView.swift
//  TimerPlus
//
//  Created by Alexey Primechaev on 1/19/20.
//  Copyright © 2020 Alexey Primechaev. All rights reserved.
//

import SwiftUI

struct TimeView: View {
    
//MARK: - Properties
    
    
    
    //MARK: Dynamic Properties
    @Binding var time: TimeInterval
    @Binding var precisionSetting: String
    @State var title = String()
    @State var frame = String()
    
//    MARK: Static Properties
    var update: () -> ()?
    
    
//MARK: - View
    var body: some View {
        ZStack(alignment: .topLeading) {
            HStack(alignment: .bottom, spacing: 5) {
                ZStack(alignment: .bottomLeading) {
                    Text("\(time.stringFromTimeInterval(precisionSetting: precisionSetting))")
                        .titleStyle()
                        .animation(nil)
                    if (time.stringFromTimeInterval(precisionSetting: precisionSetting).count == 8) {
                        Text("88:88:88")
                        .titleStyle()
                        .opacity(0)
                    } else if (time.stringFromTimeInterval(precisionSetting: precisionSetting).count == 5) {
                        Text("88:88")
                        .titleStyle()
                        .opacity(0)
                    } else {
                        Text("88:88:88.88")
                        .titleStyle()
                        .opacity(0)
                    }
                    
                }
                Text(title)
                    .smallTitleStyle()
                    .padding(.bottom, 5)
                    .opacity(0.5)
            }
            
        }.padding(7)
    }
}
