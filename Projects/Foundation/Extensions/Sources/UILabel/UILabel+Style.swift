//
//  UILabel+Style.swift
//  Extensions
//
//  Created by Supermove on 7/3/24.
//  Copyright © 2024 kr.co.supermove.rush. All rights reserved.
//

import UIKit

public extension UILabel {
    func setAttribute(
        lineSpacing: CGFloat? = nil,
        hightlightText: String? = nil,
        hightlightColor: UIColor? = nil,
        hightlightTextFont: UIFont? = nil,
        linkTargetText: String? = nil,
        targetLink: String? = nil
    ) {
        guard let text = text else { return }
        
        let attributeString = NSMutableAttributedString(string: text)
        
        if let lineSpacing {
            let style = NSMutableParagraphStyle()
            style.lineSpacing = lineSpacing
            attributeString.addAttribute(.paragraphStyle,
                                         value: style,
                                         range: NSRange(location: 0, length: attributeString.length))
        }
        
        if let hightlightText,
           let hightlightColor {
            attributeString.addAttribute(.foregroundColor, value: hightlightColor, range: (text as NSString).range(of: hightlightText))
        }
        
        if let hightlightTextFont,
           let hightlightText {
            attributeString.addAttribute(.font, value: hightlightTextFont, range: (text as NSString).range(of: hightlightText))
        }
        
        if let linkTargetText,
           let targetLink {
            attributeString.addAttribute(.link, value: URL(string: targetLink)!, range: (text as NSString).range(of: linkTargetText))
        }
        
        attributedText = attributeString
    }
}
