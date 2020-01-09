//
//  TimerView.swift
//  TimerPlus
//
//  Created by Alexey Primechaev on 1/5/20.
//  Copyright © 2020 Alexey Primechaev. All rights reserved.
//

import SwiftUI

struct TimerPlusView: View {
    
    @ObservedObject var timer = TimerPlus()
    
    @State var showingDetail = false
    
    @Environment(\.managedObjectContext) var context
    
    var body: some View {
        
        Button(action: {
            self.timer.title = "Tapped"
        }) {
            VStack(alignment: .leading) {
                Text(timer.title ?? "New Timer")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.black)
                Text(timer.time ?? "+")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.black)
                    .opacity(0.5)
                
            }
        }
        .buttonStyle(BorderlessButtonStyle())
        .contextMenu {
            Button(action: {
                self.context.delete(self.timer)
            }) {
                Text("Delete")
                Image(systemName: "trash")
            }.foregroundColor(.red)

            Button(action: {
                self.showingDetail.toggle()
            }) {
                Text("Show Info")
                Image(systemName: "location.circle")
            }.sheet(isPresented: $showingDetail) {
                TimerPlusDetailView(timer: self.timer, onDismiss: {self.showingDetail.toggle()})
            }
        }
        
        
        
    }
}

struct TimerView_Previews: PreviewProvider {
    static var previews: some View {
        TimerPlusView()
    }
}
