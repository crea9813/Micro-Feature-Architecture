//
//  String+Date.swift
//  Extensions
//
//  Created by Supermove on 7/10/24.
//  Copyright © 2024 kr.co.supermove.rush. All rights reserved.
//

import Foundation

public extension String {
    func toDate(dateFormat: String = "yyyy.MM.dd") -> Date? {
        if self.isEmpty { return nil }
        
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ko_KR")
        dateFormatter.dateFormat = dateFormat
        dateFormatter.timeZone = NSTimeZone(name: "KST") as TimeZone?
        
        guard let date = dateFormatter.date(from: self) else { return nil }
        return date
    }
}
