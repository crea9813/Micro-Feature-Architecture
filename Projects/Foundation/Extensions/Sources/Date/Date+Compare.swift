//
//  Date+Compare.swift
//  Extensions
//
//  Created by Supermove on 7/2/24.
//  Copyright © 2024 kr.co.supermove.rush. All rights reserved.
//

import Foundation

public extension Date {
    func dateCompare(fromDate: Date) -> Bool {
        let result: ComparisonResult = self.compare(fromDate)
        switch result {
        case .orderedAscending:
            return true
        case .orderedDescending:
            return false
        case .orderedSame:
            return true
        default:
            return true
        }
    }
}
