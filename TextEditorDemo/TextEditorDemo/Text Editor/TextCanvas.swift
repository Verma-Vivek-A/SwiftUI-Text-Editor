//
//  TextCanvas.swift
//  TextEditorDemo
//
//  Created by PC on 15/10/24.
//

import SwiftUI

struct TextCanvas {
    
    @ObservedObject private var textContext: TextContext
    @Binding private var text: NSAttributedString
    
    private let textView: UITextView = {
        let view = UITextView()
        view.textAlignment = .left
        return view
    }()
    
    init(text: Binding<NSAttributedString>, textContext: TextContext) {
        _text = text
        self.textContext = textContext
    }
    
    func setAttributedText(_ attributedText: NSAttributedString) {
        self.textView.attributedText = attributedText
    }
    
}

extension TextCanvas: UIViewRepresentable {
    
    func makeUIView(context: Context) -> some UITextView {
        self.textView.attributedText = self.text
        return self.textView
    }
    
    func updateUIView(_ uiView: some UITextView, context: Context) {
        DispatchQueue.main.async {
            self.text = uiView.attributedText
        }
    }
    
    func makeCoordinator() -> TextCoordinator {
        TextCoordinator(text: self.$text, textView: self.textView, context: self.textContext)
    }
    
}
