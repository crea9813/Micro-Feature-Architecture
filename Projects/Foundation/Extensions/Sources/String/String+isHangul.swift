//
//  String+isHangul.swift
//  Extensions
//
//  Created by Supermove on 9/26/24.
//  Copyright © 2024 kr.co.supermove.rush. All rights reserved.
//

import Foundation

extension String {
    public var isHangul: Bool {
        return "\(self)".range(of: "\\p{Hangul}", options: .regularExpression) != nil
    }
}
