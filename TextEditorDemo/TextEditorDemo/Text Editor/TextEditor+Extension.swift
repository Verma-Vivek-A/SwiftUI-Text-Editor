//
//  TextEditor+Extension.swift
//  TextEditorDemo
//
//  Created by PC on 15/10/24.
//

import Foundation

extension NSMutableAttributedString {
    
    func removeAttribute(_ key: NSAttributedString.Key, in range: NSRange) {
        guard length > .zero, range.location >= .zero else { return }
        
        beginEditing()
        enumerateAttribute(key, in: range) { _, range, _ in
            removeAttribute(key, range: range)
        }
        endEditing()
    }
    
    func updateAttribute(_ key: NSAttributedString.Key, with value: Any, in range: NSRange) {
        guard length > .zero, range.location >= .zero else { return }
        
        beginEditing()
        enumerateAttribute(key, in: range) { _, range, _ in
            removeAttribute(key, range: range)
            addAttribute(key, value: value, range: range)
        }
        endEditing()
    }
    
}

extension NSAttributedString {
    
    func safeRange(for range: NSRange) -> NSRange {
        NSRange(location: max(.zero, min(length - 1, range.location)),
                length: min(range.length, max(.zero, length - range.location)))
    }
    
    func textAttributes(in range: NSRange) -> [Key: Any] {
        if length == .zero { return [:] }
        let range = safeRange(for: range)
        return attributes(at: range.location, effectiveRange: nil)
    }
    
}
