//
//  Color+SM.swift
//  SMUIKit
//
//  Created by Supermove on 3/4/24.
//  Copyright © 2024 kr.co.supermove. All rights reserved.
//

import UIKit

public extension UIColor {
    enum SMColor {
        case primary
        case subtle
        case error
        case text(Text)
        case background(Background)
    }

    static func sm(_ style: SMColor) -> UIColor {
        switch style {
        case .primary: return UIColor(red: 0.18, green: 0.78, blue: 0.39, alpha: 1.00)
        case .subtle: return UIColor(red: 0.18, green: 0.78, blue: 0.39, alpha: 0.16)
        case .error: return UIColor(red: 0.96, green: 0.35, blue: 0.27, alpha: 1.00)
        case let .text(colorable as Colorable),
             let .background(colorable as Colorable):
            return colorable.color
        }
    }
}
