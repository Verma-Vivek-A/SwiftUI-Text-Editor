//
//  TextContext.swift
//  TextEditorDemo
//
//  Created by PC on 15/10/24.
//

import UIKit

final class TextContext: ObservableObject {
    
    typealias EditingValue = (isEditing: Bool, isTextEditing: Bool, value: Double)
    typealias EditingShadow = (isEditing: Bool,  isTextEditing: Bool, shadow: NSShadow)
    
    @Published var shouldUndo: Bool = false
    @Published var setAttributedString: NSAttributedString?
    
    @Published var myshadow: EditingShadow = (false, false, NSShadow())
    
    @Published var link: URL? = nil
    @Published var kern: EditingValue = (false, false, 0.0)
    @Published var lineSpacing: EditingValue = (false, false, 0.0)
        
    @Published var isBold = false
    @Published var isItalic = false
    
    @Published var strokeWidth: EditingValue = (false, false, 0.0)
    @Published var strokeColor = UIColor.black
    
    @Published var isUnderlined = false
    @Published var underlinedColor = UIColor.black
    
    @Published var isStrikethrough = false
    @Published var strikethroughColor = UIColor.black
        
    @Published var foregroundColor = UIColor.black
    @Published var backgroundColor = UIColor.black
    @Published var alignment = NSTextAlignment.left
    
}
