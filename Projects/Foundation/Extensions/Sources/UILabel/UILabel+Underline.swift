//
//  UILabel+Underline.swift
//  Extensions
//
//  Created by Supermove on 6/27/24.
//  Copyright © 2024 kr.co.supermove.rush. All rights reserved.
//

import Foundation
import UIKit

public extension UILabel {
    func applyUnderline() {
        let attributeString = NSMutableAttributedString(string: self.text!)
        attributeString.addAttribute(
            .underlineStyle,
            value: NSUnderlineStyle.single.rawValue,
            range: NSMakeRange(0, attributeString.length)
        )
        self.attributedText = attributeString
    }
}
