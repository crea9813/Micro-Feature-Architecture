//
//  Encodable+ToURLEncodingTask.swift
//  Networking
//
//  Created by Supermove on 9/12/24.
//  Copyright © 2024 kr.co.supermove.rush. All rights reserved.
//

import Moya
import Extensions

extension Encodable {
    public func toURLEncodingTask() -> Task {
        Moya.Task.requestParameters(parameters: self.toDictionary, encoding: URLEncoding.default)
    }
}
