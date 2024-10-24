//
//  Date+Month.swift
//  Extensions
//
//  Created by Supermove on 7/1/24.
//  Copyright © 2024 kr.co.supermove.rush. All rights reserved.
//

import Foundation

public extension Date {
    func monthsFrom(from date: Date) -> String? {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.month]
        formatter.unitsStyle = .full
        formatter.calendar?.locale = Locale(identifier: "ko_KR")
        guard let monthString = formatter.string(from: date, to: self) else { return nil }
        return monthString
    }
}
