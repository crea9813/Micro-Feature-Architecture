//
//  String+CreditCard.swift
//  Extensions
//
//  Created by Supermove on 7/2/24.
//  Copyright © 2024 kr.co.supermove.rush. All rights reserved.
//

import Foundation

public extension String {
    func toCreditCardString() -> String {
        if self.count > 19 { return String(self.prefix(19)) }
        let trimmedString = self.components(separatedBy: "-").joined()
        let arrOfCharacters = Array(trimmedString)
        var modifiedCreditCardString = ""
        
        if(arrOfCharacters.count > 0) {
            //             if arrOfCharacters.count > 16 { return String(modifiedCreditCardString.prefix(16)) }
            for i in 0...arrOfCharacters.count-1 {
                modifiedCreditCardString.append(arrOfCharacters[i])
//                if i > 3 && i < 12 {
//                    modifiedCreditCardString.append("*")
//                } else {
//                    modifiedCreditCardString.append(arrOfCharacters[i])
//                }
                
                if((i+1) % 4 == 0 && i+1 != arrOfCharacters.count){
                    modifiedCreditCardString.append("-")
                }
            }
        }
        return modifiedCreditCardString
    }
}
