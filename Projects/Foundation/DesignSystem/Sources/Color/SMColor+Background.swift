//
//  SMColor+Background.swift
//  SMUIKit
//
//  Created by Supermove on 3/4/24.
//  Copyright © 2024 kr.co.supermove. All rights reserved.
//

import UIKit

public extension UIColor.SMColor {
    enum Background: Colorable {
        case bg0
        case bg10
        case bg20
        case bg30
        case bg40
    }
}

public extension UIColor.SMColor.Background {
    var color: UIColor {
        switch self {
        case .bg0: return UIColor.black.withAlphaComponent(0.3)
        case .bg10: return UIColor.white
        case .bg20: return UIColor(red: 0.97, green: 0.97, blue: 0.97, alpha: 1.00)
        case .bg30: return UIColor(red: 0.93, green: 0.93, blue: 0.93, alpha: 1.00)
        case .bg40: return UIColor(red: 0.91, green: 0.91, blue: 0.91, alpha: 1.00)
        }
    }
}
