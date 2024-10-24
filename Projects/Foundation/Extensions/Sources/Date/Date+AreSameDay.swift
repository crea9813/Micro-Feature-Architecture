//
//  Date+AreSameDay.swift
//  Extensions
//
//  Created by Supermove on 6/27/24.
//  Copyright © 2024 kr.co.supermove.rush. All rights reserved.
//

import Foundation

public extension Date {
    func areSameDay(date: Date) -> Bool {
        return Calendar.current.compare(self, to: date, toGranularity: .day) == ComparisonResult.orderedSame
    }
}
