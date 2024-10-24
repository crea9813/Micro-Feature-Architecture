//
//  Decodable+ToDictionary.swift
//  Util
//
//  Created by Supermove on 1/17/24.
//  Copyright © 2024 kr.co.supermove.rush. All rights reserved.
//

import Foundation

public extension Encodable {
    var toDictionary: [String: Any] {
        guard let object = try? JSONEncoder().encode(self) else { return [:] }
        guard let dictionary = try? JSONSerialization.jsonObject(with: object, options: []) as? [String:Any] else { return [:] }
        return dictionary
    }
}
