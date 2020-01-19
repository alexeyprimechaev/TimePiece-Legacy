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
        
    var update: () -> ()?
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            HStack(alignment: .bottom, spacing: 5) {
                ZStack(alignment: .bottomLeading) {
                    Text("\((time as! TimeInterval).stringFromTimeInterval(precisionSetting: precisionSetting ?? "Off"))")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .animation(nil)
                    if ((time as! TimeInterval).stringFromTimeInterval(precisionSetting: precisionSetting ?? "Off").count == 8) {
                        Text("88:88:88")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(Color.primary)
                        .opacity(0)
                    } else if ((time as! TimeInterval).stringFromTimeInterval(precisionSetting: precisionSetting ?? "Off").count == 5) {
                        Text("88:88")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(Color.primary)
                        .opacity(0)
                    } else {
                        Text("88:88:88.88")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(Color.primary)
                        .opacity(0)
                    }
                    
                }
                Text(title)
                .font(.headline)
                .fontWeight(.semibold)
                .padding(.bottom, 5)
                .opacity(0.5)
                .animation(nil)
            }
            
        }.padding(7)
    }
}
