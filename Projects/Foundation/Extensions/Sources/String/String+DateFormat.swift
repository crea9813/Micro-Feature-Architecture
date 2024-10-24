//
//  String+DateFormat.swift
//  Extensions
//
//  Created by Supermove on 6/27/24.
//  Copyright © 2024 kr.co.supermove.rush. All rights reserved.
//

import Foundation

public extension String {
    func toDateString(dateFormat: String = "yyyy.MM.dd") -> String {
        if self.isEmpty { return "" }
        
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ko_KR")
        dateFormatter.dateFormat = "yyyyMMdd"
        dateFormatter.timeZone = NSTimeZone(name: "KST") as TimeZone?
        
        guard let date = dateFormatter.date(from: self) else { return self }
        
        dateFormatter.dateFormat = dateFormat
        
        let dateString = dateFormatter.string(from: date)
        
        return dateString
    }
}
