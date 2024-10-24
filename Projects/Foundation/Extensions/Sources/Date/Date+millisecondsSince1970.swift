//
//  millisecondsSince1970.swift
//  Extensions
//
//  Created by Supermove on 7/11/24.
//  Copyright © 2024 kr.co.supermove.rush. All rights reserved.
//

import Foundation

extension Date {
    public var millisecondsSince1970: Int64 {
        Int64((self.timeIntervalSince1970 * 1000.0).rounded())
    }
}
