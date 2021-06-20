//
//  CommentSheet.swift
//  TimePiece (iOS)
//
//  Created by Alexey Primechaev on 6/20/21.
//  Copyright © 2021 Alexey Primechaev. All rights reserved.
//

import SwiftUI

struct CommentSheet: View {
    
    @Binding var comment: String
    
    @State var localComment = ""
    
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            HeaderBar(showingMenu: true) {
                RegularButton(title: "Cancel", icon: "xmark", isDestructive: false) {
                    presentationMode.wrappedValue.dismiss()
                }
            } trailingItems: {
                RegularButton(title: "Delete Comment", icon: "trash", isDestructive: true) {
                    presentationMode.wrappedValue.dismiss()
                    comment = ""
                }
            }
            TextEditor(text: $localComment).introspectTextView { textView in
                textView.becomeFirstResponder()
            }.fontSize(.title2).padding(.horizontal, 21)
            Spacer()
            EditorBar(titleField: .constant(UITextField()), timeField: .constant(UITextField()), titleFocused: .constant(false), timeFocused: .constant(false), showSwitcher: .constant(true), button: {
                Text("\(localComment.count)/280").fontSize(.secondaryText)
                Spacer()
                Button {
                    comment = localComment
                    presentationMode.wrappedValue.dismiss()
                } label: {
                    Label {
                        Text("Save").fontSize(.smallTitle)
                    } icon: {
                        Image(systemName: "square.and.arrow.down").font(.headline)
                    }.padding(.horizontal, 14).padding(.vertical, 7).opacity(comment != localComment ? 1: 0.33).animation(.easeOut(duration: 0.2), value: comment == localComment).background(RoundedRectangle(cornerRadius: 8, style: .continuous)
                                                                                    .foregroundColor(Color("button.gray"))).padding(.vertical, 7)
                }.disabled(comment == localComment)
            })
        }.onAppear {
            localComment = comment
        }
        .onChange(of: localComment) { newValue in
            if newValue.count > 280 {
                lightHaptic()
                localComment = String(newValue.prefix(280))
            }
        }
    }
}

