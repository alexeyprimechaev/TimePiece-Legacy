//
//  TimerPlusDetailView.swift
//  TimerPlus
//
//  Created by Alexey Primechaev on 1/6/20.
//  Copyright © 2020 Alexey Primechaev. All rights reserved.
//

import SwiftUI

struct TimerPlusDetailView: View {
    
    @ObservedObject var timer = TimerPlus()
    
    let formatter = RelativeDateTimeFormatter()
    
    var body: some View {
        VStack {
            Text(timer.title ?? "Timer")
            Text(timer.time ?? "0:00")
            Text("\(timer.createdAt ?? Date(), formatter: formatter)")
        }
    }
}

struct TimerPlusDetailView_Previews: PreviewProvider {
    static var previews: some View {
        TimerPlusDetailView()
    }
}
