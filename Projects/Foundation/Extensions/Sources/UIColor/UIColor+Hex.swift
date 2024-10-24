//
//  UIColor+Hex.swift
//  Util
//
//  Created by Supermove on 3/4/24.
//  Copyright © 2024 kr.co.supermove.rush. All rights reserved.
//

import UIKit

public extension UIColor {
    convenience init(hex: String) {
        let cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()

        var rgbValue:UInt64 = 0
        Scanner(string: cString).scanHexInt64(&rgbValue)

        self.init(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
}
