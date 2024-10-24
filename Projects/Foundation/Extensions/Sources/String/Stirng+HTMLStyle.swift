//
//  Stirng+HTMLStyle.swift
//  Extensions
//
//  Created by Supermove on 7/2/24.
//  Copyright © 2024 kr.co.supermove.rush. All rights reserved.
//

import Foundation

public extension String {
    func convertToAttributedFromHTML() -> NSMutableAttributedString? {
        var attributedText: NSMutableAttributedString?
        let options: [NSAttributedString.DocumentReadingOptionKey: Any] = [.documentType: NSAttributedString.DocumentType.html, .characterEncoding: String.Encoding.utf8.rawValue]
        if let data = data(using: .unicode, allowLossyConversion: true),
           let attrStr = try? NSMutableAttributedString(data: data, options: options, documentAttributes: nil) {
            attributedText = attrStr
        }
        return attributedText
    }
}
