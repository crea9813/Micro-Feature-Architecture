//
//  Int+Currency.swift
//  Extensions
//
//  Created by Supermove on 6/27/24.
//  Copyright © 2024 kr.co.supermove.rush. All rights reserved.
//

import Foundation

public extension Int {
    func addDecimal() -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter.string(from: NSNumber(value: self))!
    }
    
    func toCurrency() -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter.string(from: NSNumber(value: self))! + "원"
    }
}
