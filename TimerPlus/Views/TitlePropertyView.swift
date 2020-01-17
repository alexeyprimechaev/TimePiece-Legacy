//
//  EditablePropertyView.swift
//  TimerPlus
//
//  Created by Alexey Primechaev on 1/16/20.
//  Copyright © 2020 Alexey Primechaev. All rights reserved.
//

import SwiftUI
import Introspect

struct TitlePropertyView: View {
    
    @Environment(\.managedObjectContext) var context
        
    @Binding var property: String
    
    @State var value = ""
    
    @State var title = ""
    
    var body: some View {
        HStack(alignment: .bottom, spacing: 7) {
            
            MultilineTextField(text: $value)
            
            .onAppear() {
                self.value = self.property ?? "NIL"
            }
            
            
            
//            TextField("", text: $value) {
//                self.property = self.value
//            }
//            .onAppear() {
//                self.value = self.property ?? "NIL"
//            }
//            .introspectTextField(customize: { textField in
//                textField.font = UIFont(name: "AppleColorEmoji", size: 34)
//                textField.font = UIFont.systemFont(ofSize: 34, weight: .semibold)
//            })
//            .font(.system(size: 34, weight: .bold))
            
            Text(title)
                .font(.headline)
                .fontWeight(.semibold)
                .padding(.bottom, 5)
                .opacity(0.5)
        }
        .padding(7)
        
            
    }
}

fileprivate struct UITextViewWrapper: UIViewRepresentable {
    typealias UIViewType = UITextView

    @Binding var text: String
    @Binding var calculatedHeight: CGFloat
    @Binding var calculatedWidth: CGFloat
    var onDone: (() -> Void)?

    func makeUIView(context: UIViewRepresentableContext<UITextViewWrapper>) -> UITextView {
        let textField = UITextView()
        textField.delegate = context.coordinator

        textField.isEditable = true
        textField.font = UIFont.preferredFont(forTextStyle: .body)
        textField.isSelectable = true
        textField.isUserInteractionEnabled = true
        textField.isScrollEnabled = false
        if nil != onDone {
            textField.returnKeyType = .done
        }

        textField.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        return textField
    }

    func updateUIView(_ uiView: UITextView, context: UIViewRepresentableContext<UITextViewWrapper>) {
        if uiView.text != self.text {
            uiView.text = self.text
        }
        if uiView.window != nil, !uiView.isFirstResponder {
            uiView.becomeFirstResponder()
        }
        UITextViewWrapper.recalculateWidth(view: uiView, result: $calculatedWidth)
        UITextViewWrapper.recalculateHeight(view: uiView, result: $calculatedHeight)
    }

    fileprivate static func recalculateHeight(view: UIView, result: Binding<CGFloat>) {
        let newSize = view.sizeThatFits(CGSize(width: view.frame.size.width, height: CGFloat.greatestFiniteMagnitude))
        if result.wrappedValue != newSize.height {
            DispatchQueue.main.async {
                result.wrappedValue = newSize.height // !! must be called asynchronously
            }
        }
    }

    fileprivate static func recalculateWidth(view: UIView, result: Binding<CGFloat>) {
        let newSize = view.sizeThatFits(CGSize(width: CGFloat.greatestFiniteMagnitude, height: view.frame.size.height))
        if result.wrappedValue != newSize.width {
            DispatchQueue.main.async {
                result.wrappedValue = newSize.width // !! must be called asynchronously
            }
        }
    }

    
    func makeCoordinator() -> Coordinator {
        return Coordinator(text: $text, height: $calculatedHeight, width: $calculatedWidth, onDone: onDone)
    }

    final class Coordinator: NSObject, UITextViewDelegate {
        var text: Binding<String>
        var calculatedHeight: Binding<CGFloat>
        var calculatedWidth: Binding<CGFloat>
        var onDone: (() -> Void)?

        init(text: Binding<String>, height: Binding<CGFloat>, width: Binding<CGFloat>, onDone: (() -> Void)? = nil) {
            self.text = text
            self.calculatedHeight = height
            self.calculatedWidth = width
            self.onDone = onDone
        }

        func textViewDidChange(_ uiView: UITextView) {
            text.wrappedValue = uiView.text
            UITextViewWrapper.recalculateWidth(view: uiView, result: calculatedWidth)
            UITextViewWrapper.recalculateHeight(view: uiView, result: calculatedHeight)
        }

        func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
            if let onDone = self.onDone, text == "\n" {
                textView.resignFirstResponder()
                onDone()
                return false
            }
            return true
        }
    }

}

struct MultilineTextField: View {

    private var placeholder: String
    private var onCommit: (() -> Void)?

    @Binding private var text: String
    private var internalText: Binding<String> {
        Binding<String>(get: { self.text } ) {
            self.text = $0
            self.showingPlaceholder = $0.isEmpty
        }
    }

    @State private var dynamicHeight: CGFloat = 100
    @State private var dynamicWidth: CGFloat = 100
    @State private var showingPlaceholder = false

    init (_ placeholder: String = "", text: Binding<String>, onCommit: (() -> Void)? = nil) {
        self.placeholder = placeholder
        self.onCommit = onCommit
        self._text = text
        self._showingPlaceholder = State<Bool>(initialValue: self.text.isEmpty)
    }

    var body: some View {
        UITextViewWrapper(text: self.internalText, calculatedHeight: $dynamicHeight, calculatedWidth: $dynamicWidth, onDone: onCommit)
            .frame(minHeight: dynamicHeight, maxHeight: dynamicHeight)
            .overlay(placeholderView, alignment: .topLeading)
    }

    var placeholderView: some View {
        Group {
            if showingPlaceholder {
                Text(placeholder).foregroundColor(.gray)
                    .padding(.leading, 4)
                    .padding(.top, 8)
            }
        }
    }
}

