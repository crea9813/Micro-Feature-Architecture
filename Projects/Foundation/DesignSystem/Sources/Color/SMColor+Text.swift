//
//  SMColor+Text.swift
//  SMUIKit
//
//  Created by Supermove on 3/4/24.
//  Copyright © 2024 kr.co.supermove. All rights reserved.
//

import UIKit

public extension UIColor.SMColor {
    enum Text: Colorable {
        case t10
        case t20
        case t30
        case t40
        case t50
        case t60
        case t100
    }
}

public extension UIColor.SMColor.Text {
    var color: UIColor {
        switch self {
        case .t10: return UIColor.black
        case .t20: return UIColor(red: 0.07, green: 0.07, blue: 0.07, alpha: 1.00)
        case .t30: return UIColor(red: 0.20, green: 0.20, blue: 0.20, alpha: 1.00)
        case .t40: return UIColor(red: 0.45, green: 0.45, blue: 0.47, alpha: 1.00)
        case .t50: return UIColor(red: 0.55, green: 0.55, blue: 0.55, alpha: 1.00)
        case .t60: return UIColor(red: 0.62, green: 0.62, blue: 0.62, alpha: 1.00)
        case .t100: return UIColor.white
        }
    }
}
