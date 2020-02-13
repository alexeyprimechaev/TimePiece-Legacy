//
//  NewTimerView.swift
//  TimerPlus
//
//  Created by Alexey Primechaev on 1/20/20.
//  Copyright © 2020 Alexey Primechaev. All rights reserved.
//

import SwiftUI

struct NewTimerView: View {
    
    @Environment(\.managedObjectContext) var context
    
    @ObservedObject var timer = TimerPlus()
    
    @Binding var isAdding: Bool
        
    var discard: () -> ()
            
    var body: some View {
        VStack(spacing:0) {
            HStack() {
                Button(action: {
                    self.isAdding = false
                    print(self.isAdding)
                    self.discard()
                }) {
                    HStack(alignment: .center) {
                        Image(systemName: "xmark")
                            .font(.system(size: 11.0, weight: .heavy))
                        Text("Discard")
                            .fontWeight(.semibold)
                    }
                    .padding(.leading, 28)
                    .padding(.trailing, 128)
                    .foregroundColor(Color.red)
                }
                .frame(height: 52)
                Spacer()
                Button(action: {
                    self.isAdding = true
                    print(self.isAdding)
                    if self.timer.title.count == 0 {
                        self.timer.title = "Timer ⏱"
                    }
                    
                    self.discard()
                }) {
                    HStack(alignment: .center) {
                        Image(systemName: "plus")
                            .font(.system(size: 11.0, weight: .heavy))
                        Text("Add")
                            .fontWeight(.semibold)
                    }
                    .padding(.leading, 64)
                    .padding(.trailing, 28)
                    .foregroundColor(Color.primary)
                }
                .frame(height: 52)
            }
            
            ScrollView() {
                
                VStack(alignment: .leading, spacing: 14) {
                                            
                    PropertyView(title: "Title", timer: self.timer )
                    
                    EditableTimeView(time: $timer.totalTime, title: "Enter Time", isFirstResponder: true, update: {
                        self.timer.reset()
                        self.timer.currentTimeStored = self.timer.totalTimeStored
                        //self.onDismiss()
                    })
                    
                    
                }.padding(.leading, 21)
            }
        }
    }
}

