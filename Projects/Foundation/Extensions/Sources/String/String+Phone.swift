//
//  String+Phone.swift
//  Extensions
//
//  Created by Supermove on 6/27/24.
//  Copyright © 2024 kr.co.supermove.rush. All rights reserved.
//

import Foundation
import UIKit

public extension String {
    func pretty() -> String {
        let _str = self.replacingOccurrences(of: "-", with: "")
        let arr = Array(_str)
        if arr.count > 3 {
            let prefix = String(format: "%@%@", String(arr[0]), String(arr[1]))
            if prefix == "02" {
                if let regex = try? NSRegularExpression(pattern: "([0-9]{2})([0-9]{3,4})([0-9]{4})", options: .caseInsensitive) {
                    let modString = regex.stringByReplacingMatches(in: _str, options: [], range: NSRange(_str.startIndex..., in: _str), withTemplate: "$1-$2-$3")
                    return modString
                }
            } else if prefix == "15" || prefix == "16" || prefix == "18" {
                if let regex = try? NSRegularExpression(pattern: "([0-9]{4})([0-9]{4})", options: .caseInsensitive) { let modString = regex.stringByReplacingMatches(in: _str, options: [], range: NSRange(_str.startIndex..., in: _str), withTemplate: "$1-$2")
                    return modString
                    
                }
                
            } else {
                if let regex = try? NSRegularExpression(pattern: "([0-9]{3})([0-9]{3,4})([0-9]{4})", options: .caseInsensitive) { let modString = regex.stringByReplacingMatches(in: _str, options: [], range: NSRange(_str.startIndex..., in: _str), withTemplate: "$1-$2-$3")
                    return modString }
            }
        }
        return self
    }
}
