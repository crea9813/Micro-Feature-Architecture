//
//  SMStackViewPriority.swift
//  DesignSystem
//
//  Created by Supermove on 6/27/24.
//  Copyright © 2024 kr.co.supermove.rush. All rights reserved.
//

import UIKit

public enum SMStackViewPriority {
    case required
    case high
    case medium
    case low
    
    public var font: UIFont {
        switch self {
        case .required: return .spoqaFont(size: 14, weight: .bold)
        case .high: return .spoqaFont(size: 14, weight: .medium)
        case .medium: return .spoqaFont(size: 14, weight: .regular)
        case .low: return .spoqaFont(size: 14, weight: .regular)
        }
    }
    
    public var textColor: UIColor {
        switch self {
        case .required: return UIColor(red: 0.16, green: 0.73, blue: 0.19, alpha: 1)
        case .high, .medium: return UIColor(red: 0.07, green: 0.07, blue: 0.07, alpha: 1)
        case .low: return UIColor(red: 0.45, green: 0.45, blue: 0.47, alpha: 1)
        }
    }
}
