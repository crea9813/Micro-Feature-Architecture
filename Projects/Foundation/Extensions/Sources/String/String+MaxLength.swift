//
//  String+MaxLength.swift
//  Extensions
//
//  Created by Supermove on 7/2/24.
//  Copyright © 2024 kr.co.supermove.rush. All rights reserved.
//

import Foundation

public extension String {
    func maxLength(_ length: Int) -> String {
        if self.count > length { return String(self.prefix(length)) } else { return self }
    }
}
