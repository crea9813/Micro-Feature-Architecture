//
//  BaseResponse.swift
//  Network
//
//  Created by Supermove on 6/24/24.
//  Copyright © 2024 kr.co.supermove.rush. All rights reserved.
//

import Foundation

struct BaseResponse<D: Decodable>: Decodable {
    let resultCode: Int
    let message: String?
    let data: D?
    let guide: GuideDTO?
    
    private enum CodingKeys: String, CodingKey {
        case resultCode = "resultcode"
        case message, data, guide
    }
}

public struct GuideDTO: Decodable {
    enum CodingKeys: String, CodingKey {
        case display
        case back = "backYn"
        case title
        case contents
    }
    public let display: String
    public let back: String
    public let title, contents: String?
}
