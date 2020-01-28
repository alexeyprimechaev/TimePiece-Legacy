//
//  TimeView.swift
//  TimerPlus
//
//  Created by Alexey Primechaev on 1/19/20.
//  Copyright © 2020 Alexey Primechaev. All rights reserved.
//

import SwiftUI

struct TimeView: View {
    
    @Binding var time: NSNumber?
    
    @Binding var precisionSetting: String?
    
    @State var title = String()
    
    @State var frame = String()
        
    var update: () -> ()?
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            HStack(alignment: .bottom, spacing: 5) {
                ZStack(alignment: .bottomLeading) {
                    Text("\((time as! TimeInterval).stringFromTimeInterval(precisionSetting: precisionSetting ?? "Off"))")
                        .titleStyle()
                        .animation(nil)
                    if ((time as! TimeInterval).stringFromTimeInterval(precisionSetting: precisionSetting ?? "Off").count == 8) {
                        Text("88:88:88")
                        .titleStyle()
                        .opacity(0)
                    } else if ((time as! TimeInterval).stringFromTimeInterval(precisionSetting: precisionSetting ?? "Off").count == 5) {
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
