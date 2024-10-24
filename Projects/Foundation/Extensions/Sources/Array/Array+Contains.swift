//
//  Array+Contains.swift
//  Extensions
//
//  Created by Supermove on 7/8/24.
//  Copyright © 2024 kr.co.supermove.rush. All rights reserved.
//

import Foundation

public extension Array {
     func contains<T>(obj: T) -> Bool where T: Equatable {
         return !self.filter({$0 as? T == obj}).isEmpty
     }
 }
