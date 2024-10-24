//
//  String+ExpireDate.swift
//  Extensions
//
//  Created by Supermove on 7/2/24.
//  Copyright © 2024 kr.co.supermove.rush. All rights reserved.
//

import Foundation

public extension String {
    func toExpireDateString() -> String {
        if self.count > 5 { return String(self.prefix(5)) }
        let trimmedString = self.components(separatedBy: "/").joined()
        let arrayOfCharacters = Array(trimmedString)
        var modifiedString = ""
        
        if arrayOfCharacters.count > 0 {
            arrayOfCharacters.enumerated().forEach {
                modifiedString.append($0.element)
                if ($0.offset + 1) % 2 == 0 && ($0.offset + 1) != arrayOfCharacters.count {
                    modifiedString.append("/")
                }
                
            }
        }
        return modifiedString
    }
}
