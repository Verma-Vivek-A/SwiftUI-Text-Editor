//
//  TextCoordinator.swift
//  TextEditorDemo
//
//  Created by PC on 15/10/24.
//

import SwiftUI
import Combine

final class TextCoordinator: NSObject {
    
    private var text: Binding<NSAttributedString>
    private let textView: UITextView
    private let context: TextContext
    
    private var addUndoContext: Bool = true
    private var undoAttributedStrings: [NSAttributedString] = [] {
        didSet {
            print(self.undoAttributedStrings.count)
        }
    }
    private var redoAttributedStrings: [NSAttributedString] = []
    
    private var workItem: DispatchWorkItem?
    private var defaultText = NSAttributedString()
    private var cancellationBag = Set<AnyCancellable>()
    
    init(text: Binding<NSAttributedString>, textView: UITextView, context: TextContext) {
        self.text = text
        self.textView = textView
        self.context = context
        super.init()
        textView.delegate = self
        self.bindContextUpdates()
        self.defaultText = self.text.wrappedValue
    }
    
    private func bindContextUpdates() {
        self.context
            .$shouldUndo
            .sink { [weak self] shouldUndo in
                guard let self = self else { return }
                if shouldUndo {
                    self.undo()
                } else {
                    self.redo()
                }
            }
            .store(in: &self.cancellationBag)
        
        self.context
            .$setAttributedString
            .sink { [weak self] attributedString in
                guard let self = self else { return }
                if let attributedText = attributedString {
                    self.textView.attributedText = attributedText
                }
            }
            .store(in: &self.cancellationBag)
        
        self.context
            .$myshadow
            .sink { [weak self] shadow in
                guard let self = self else { return }
                self.updateShadow(with: shadow.shadow)
                let range = self.textView.selectedRange
                if shadow.isEditing == false, shadow.isTextEditing == false, self.addUndoContext, range.length > 0 {
                    self.undoAttributedStrings.append(self.textView.attributedText)
                }
            }
            .store(in: &self.cancellationBag)
        
        self.context
            .$link
            .sink { [weak self] link in
                guard let self = self, let url = link else { return }
                self.addUrl(with: url)
                let range = self.textView.selectedRange
                if  self.addUndoContext, range.length > 0 {
                    self.undoAttributedStrings.append(self.textView.attributedText)
                }
            }
            .store(in: &self.cancellationBag)
        
        self.context
            .$kern
            .sink { [weak self] kern in
                guard let self = self else { return }
                self.updateKern(with: kern.value)
                let range = self.textView.selectedRange
                if kern.isEditing == false, kern.isTextEditing == false, self.addUndoContext, range.length > 0 {
                    self.undoAttributedStrings.append(self.textView.attributedText)
                }
            }
            .store(in: &self.cancellationBag)
        
        self.context
            .$lineSpacing
            .sink { [weak self] lineSpacing in
                guard let self = self else { return }
                self.updateLineSpacing(with: lineSpacing.value)
                let range = self.textView.selectedRange
                if lineSpacing.isEditing == false,  lineSpacing.isTextEditing == false, self.addUndoContext, range.length > 0 {
                    self.undoAttributedStrings.append(self.textView.attributedText)
                }
            }
            .store(in: &self.cancellationBag)
        
        self.context
            .$isBold
            .sink { [weak self] isBold in
                guard let self = self else { return }
                self.updateBold(with: isBold)
                let range = self.textView.selectedRange
                if self.addUndoContext, range.length > 0 {
                    self.undoAttributedStrings.append(self.textView.attributedText)
                }
            }
            .store(in: &self.cancellationBag)
        
        self.context
            .$isItalic
            .sink { [weak self] isItalic in
                guard let self = self else { return }
                self.updateItalic(with: isItalic)
                let range = self.textView.selectedRange
                if self.addUndoContext, range.length > 0 {
                    self.undoAttributedStrings.append(self.textView.attributedText)
                }
            }
            .store(in: &self.cancellationBag)
        
        self.context
            .$strokeColor
            .sink { [weak self] strokeColor in
                guard let self = self else { return }
                self.updateStrokeColor(with: strokeColor)
                let range = self.textView.selectedRange
                if self.addUndoContext, range.length > 0 {
                    self.undoAttributedStrings.append(self.textView.attributedText)
                }
            }
            .store(in: &self.cancellationBag)
        
        self.context
            .$strokeWidth
            .sink { [weak self] strokeWidth in
                guard let self = self else { return }
                self.updateStroke(with: strokeWidth.value)
                let range = self.textView.selectedRange
                if strokeWidth.isEditing == false, strokeWidth.isTextEditing == false, self.addUndoContext, range.length > 0 {
                    self.undoAttributedStrings.append(self.textView.attributedText)
                }
            }
            .store(in: &self.cancellationBag)
        
        self.context
            .$isUnderlined
            .sink { [weak self] isUnderlined in
                guard let self = self else { return }
                self.updateUnderlined(with: isUnderlined)
                let range = self.textView.selectedRange
                if self.addUndoContext, range.length > 0 {
                    self.undoAttributedStrings.append(self.textView.attributedText)
                }
            }
            .store(in: &self.cancellationBag)
        
        self.context
            .$isStrikethrough
            .sink { [weak self] strikethrough in
                guard let self = self else { return }
                self.updateStrikethrough(with: strikethrough)
                let range = self.textView.selectedRange
                if self.addUndoContext, range.length > 0 {
                    self.undoAttributedStrings.append(self.textView.attributedText)
                }
            }
            .store(in: &self.cancellationBag)
        
        self.context
            .$foregroundColor
            .sink { [weak self] foregroundColor in
                guard let self = self else { return }
                self.updateForegroundColor(with: foregroundColor)
                let range = self.textView.selectedRange
                if self.addUndoContext, range.length > 0 {
                    self.undoAttributedStrings.append(self.textView.attributedText)
                }
            }
            .store(in: &self.cancellationBag)
        
        self.context
            .$backgroundColor
            .sink { [weak self] backgroundColor in
                guard let self = self else { return }
                self.updateBackgroundColor(with: backgroundColor)
                let range = self.textView.selectedRange
                if self.addUndoContext, range.length > 0 {
                    self.undoAttributedStrings.append(self.textView.attributedText)
                }
            }
            .store(in: &self.cancellationBag)
        
        self.context
            .$alignment
            .sink { [weak self] alignment in
                guard let self = self else { return }
                if self.textView.textAlignment != alignment {
                    self.textView.textAlignment = alignment
                    self.undoAttributedStrings.append(self.textView.attributedText)
                }
            }
            .store(in: &self.cancellationBag)
    }
    
    func undo() {
        guard let attributedString = self.undoAttributedStrings.last else { return }
        self.redoAttributedStrings.append(attributedString)
        self.undoAttributedStrings.removeLast()
        
        if let lastAttributedString = self.undoAttributedStrings.last {
            self.textView.attributedText = lastAttributedString
        } else {
            self.textView.attributedText = self.defaultText
        }
    }
    
    func redo() {
        guard let attributedString = self.redoAttributedStrings.last else { return }
        self.textView.attributedText = attributedString
        self.undoAttributedStrings.append(attributedString)
        self.redoAttributedStrings.removeLast()
    }
    
}

extension TextCoordinator: UITextViewDelegate {
    
    func textViewDidChangeSelection(_ textView: UITextView) {
        DispatchQueue.main.async {
            self.updateContextFromTextView()
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        self.workItem?.cancel()
        self.workItem = DispatchWorkItem(block: {
            self.undoAttributedStrings.append(textView.attributedText)
        })
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3, execute: self.workItem!)
    }
    
}

private extension TextCoordinator {
    
    func updateContextFromTextView() {
        self.addUndoContext = false
        let range = self.textView.selectedRange
        let attributes = self.textView.attributedText.textAttributes(in: range)
        
        if let shadow = attributes[.shadow] as? NSShadow {
            self.context.myshadow.shadow = shadow
        } else {
            self.context.myshadow.shadow = NSShadow()
        }
        
        if let kern = attributes[.kern] as? Double, kern != 0 {
            self.context.kern.value = kern
        } else {
            self.context.kern.value = 0
        }
        
        if let paragraphStyle = attributes[.paragraphStyle] as? NSMutableParagraphStyle, paragraphStyle.lineSpacing != 0 {
            self.context.lineSpacing.value = paragraphStyle.lineSpacing
        } else {
            self.context.lineSpacing.value = 0
        }
        
        if let font = attributes[.font] as? UIFont {
            let isBold = font.fontDescriptor.symbolicTraits.contains(.traitBold)
            self.context.isBold = isBold
        }
        
        if let font = attributes[.font] as? UIFont {
            let isItalic = font.fontDescriptor.symbolicTraits.contains(.traitItalic)
            self.context.isItalic = isItalic
        }
        
        if let strokeColor = attributes[.strokeColor] as? UIColor {
            self.context.strokeColor = strokeColor
        }
        
        let strokeWidth = attributes[.strokeWidth] as? NSNumber
        self.context.strokeWidth.value = strokeWidth?.doubleValue ?? 0
        
        if let underlinedColor = attributes[.underlineColor] as? UIColor {
            self.context.underlinedColor = underlinedColor
        }
        
        let isUnderlined = attributes[.underlineStyle] as? Int == 1
        self.context.isUnderlined = isUnderlined
        
        if let strikethroughColor = attributes[.strikethroughColor] as? UIColor {
            self.context.strikethroughColor = strikethroughColor
        }
        
        let strikethroughStyle = attributes[.strikethroughStyle] as? Int == 1
        self.context.isStrikethrough = strikethroughStyle
        
        if let foregroundColor = attributes[.foregroundColor] as? UIColor {
            self.context.foregroundColor = foregroundColor
        }
        
        if let backgroundColor = attributes[.backgroundColor] as? UIColor {
            self.context.backgroundColor = backgroundColor
        }

        self.addUndoContext = true
    }
    
}

private extension TextCoordinator {
    
    func updateShadow(with value: NSShadow, in range: NSRange? = nil) {
        let range = range ?? textView.selectedRange
        self.textView.textStorage.updateAttribute(.shadow, with: value, in: range)
    }
    
    func addUrl(with value: URL, in range: NSRange? = nil) {
        let range = range ?? self.textView.selectedRange
        self.textView.textStorage.updateAttribute(.link, with: value, in: range)
    }
    
    func updateKern(with value: Double, in range: NSRange? = nil) {
        let range = range ?? self.textView.selectedRange
        self.textView.textStorage.updateAttribute(.kern, with: value, in: range)
    }
    
    func updateLineSpacing(with value: Double, in range: NSRange? = nil) {
        let range = range ?? self.textView.selectedRange
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = value
        paragraphStyle.alignment = self.context.alignment
        self.textView.textStorage.updateAttribute(.paragraphStyle, with: paragraphStyle, in: range)
    }

    func updateBold(with value: Bool, in range: NSRange? = nil) {
        let range = range ?? self.textView.selectedRange
        let font: UIFont = self.textView.attributedText.textAttributes(in: range)[.font] as? UIFont ?? .systemFont(ofSize: 18.0)
        
        let originalSymbolicTraits = font.fontDescriptor.symbolicTraits
        let newSymbolicTraits = value ? originalSymbolicTraits.union(.traitBold) : originalSymbolicTraits.subtracting(.traitBold)
        
        let newFont: UIFont = UIFont(descriptor: font.fontDescriptor.withSymbolicTraits(newSymbolicTraits) ?? font.fontDescriptor, size: font.pointSize)
        self.textView.textStorage.updateAttribute(.font, with: newFont, in: range)
    }
    
    func updateItalic(with value: Bool, in range: NSRange? = nil) {
        let range = range ?? self.textView.selectedRange
        let font: UIFont = self.textView.attributedText.textAttributes(in: range)[.font] as? UIFont ?? .systemFont(ofSize: 18.0)
        
        let originalSymbolicTraits = font.fontDescriptor.symbolicTraits
        let newSymbolicTraits = value ? originalSymbolicTraits.union(.traitItalic) : originalSymbolicTraits.subtracting(.traitItalic)
        
        let newFont: UIFont = UIFont(descriptor: font.fontDescriptor.withSymbolicTraits(newSymbolicTraits) ?? font.fontDescriptor, size: font.pointSize)
        self.textView.textStorage.updateAttribute(.font, with: newFont, in: range)
    }

    func updateStroke(with value: Double, in range: NSRange? = nil) {
        let range = range ?? self.textView.selectedRange
        self.textView.textStorage.updateAttribute(.strokeWidth, with: value, in: range)
    }
    
    func updateStrokeColor(with value: UIColor, in range: NSRange? = nil) {
        let range = range ?? self.textView.selectedRange
        self.textView.textStorage.updateAttribute(.strokeColor, with: value, in: range)
    }
    
    func updateUnderlined(with value: Bool, in range: NSRange? = nil) {
        let range = range ?? self.textView.selectedRange
        self.textView.textStorage.updateAttribute(.underlineStyle, with: value, in: range)
        self.textView.textStorage.updateAttribute(.underlineColor, with: self.context.underlinedColor, in: range)
    }
    
    func updateStrikethrough(with value: Bool, in range: NSRange? = nil) {
        let range = range ?? self.textView.selectedRange
        self.textView.textStorage.updateAttribute(.strikethroughStyle, with: value, in: range)
        self.textView.textStorage.updateAttribute(.strikethroughColor, with: self.context.strikethroughColor, in: range)
    }
    
    func updateForegroundColor(with value: UIColor, in range: NSRange? = nil) {
        let range = range ?? textView.selectedRange
        self.textView.textStorage.updateAttribute(.foregroundColor, with: value, in: range)
    }
    
    func updateBackgroundColor(with value: UIColor, in range: NSRange? = nil) {
        let range = range ?? self.textView.selectedRange
        self.textView.textStorage.updateAttribute(.backgroundColor, with: value, in: range)
    }
    
}
