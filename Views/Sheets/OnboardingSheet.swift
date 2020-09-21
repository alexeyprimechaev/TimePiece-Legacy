//
//  OnboardingSheet.swift
//  TimePiece (iOS)
//
//  Created by Alexey Primechaev on 9/21/20.
//  Copyright © 2020 Alexey Primechaev. All rights reserved.
//

import SwiftUI

struct OnboardingSheet: View {
    
    var dismiss: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            
            Text("Thank You For Testing TimePiece").fontSize(.title).padding(7)

            Text("We need your feedback to make TimePiece even better. Tell us what you think about it. Every bit of information is helpful to us. Even a single word of feedback would help a lot!").fontSize(.smallTitle).padding(7)
            Text("If you have any ideas about how we could improve TimePiece, please consider sharing them with us.").fontSize(.smallTitle).padding(7)
            Text("No pressure. If you want to do it later, you can do it from the Settings page.").fontSize(.smallTitle).padding(7)
            
            Spacer()
            
            
            Button {
                UIApplication.shared.open(URL(string: "mailto:monochromestudios@icloud.com")!)
            } label: {
                HStack {
                    Spacer()
                    Text("Send Feedback").padding(14).foregroundColor(Color(.systemBackground)).fontSize(.smallTitle)
                    Spacer()
                }.background(RoundedRectangle(cornerRadius: 8, style: .continuous).foregroundColor(Color("priority.gray")))
            }
            Button {
                dismiss()
            } label: {
                HStack {
                    Spacer()
                    Text("Okay").padding(14).foregroundColor(.primary).fontSize(.smallTitle)
                    Spacer()
                }.background(RoundedRectangle(cornerRadius: 8, style: .continuous).foregroundColor(Color("button.gray")))
            }
        }.padding(.leading, 21).padding(.trailing, 21).padding(.vertical, 21)
        
        
    }
}
