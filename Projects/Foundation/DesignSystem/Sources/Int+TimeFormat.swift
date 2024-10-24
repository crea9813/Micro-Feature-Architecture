//
//  Int+TimeFormat.swift
//  DesignSystem
//
//  Created by Supermove on 10/16/24.
//  Copyright © 2024 kr.co.supermove.rush. All rights reserved.
//

import Foundation

extension Int {
    public enum AbbreviationType {
        case oneLetter
        case halfLetter
        case full
        
        var localizedTitle: String {
            switch self {
            case .oneLetter: return "_one_letter"
            case .halfLetter: return "_short"
            case .full: return ""
            }
        }
    }
    
    public func timeFormatted(abbreviationType: AbbreviationType = .halfLetter, shouldDisplaySecond: Bool = false) -> String {
        let seconds = self
        let hour = seconds / 3600
        let minute = (seconds % 3600) / 60
        let second = seconds % 60

        var components: [String] = []

        if hour > 0 {
            components.append("to_hour\(abbreviationType.localizedTitle)".localized(with: hour))
        }
        if minute > 0 {
            components.append("to_minute\(abbreviationType.localizedTitle)".localized(with: minute))
        }
        if (hour == 0 && minute == 0) || shouldDisplaySecond {
            components.append("to_second\(abbreviationType.localizedTitle)".localized(with: second))
        }

        return components.joined(separator: " ")
    }
}
