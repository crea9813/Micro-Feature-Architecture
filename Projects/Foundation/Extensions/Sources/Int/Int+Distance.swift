//
//  Int+Distance.swift
//  Extensions
//
//  Created by Supermove on 10/17/24.
//  Copyright © 2024 kr.co.supermove.rush. All rights reserved.
//

import Foundation

extension Int {
    public func toDistance() -> String {
        if self >= 1000 {
            if self % 1000 == 0 {
                return "\(self / 1000)km"
            } else {
                return "\(self / 1000).\(String(self % 1000).first ?? Character("0"))km"
            }
        } else {
            return "\(self)m"
        }
    }
}
