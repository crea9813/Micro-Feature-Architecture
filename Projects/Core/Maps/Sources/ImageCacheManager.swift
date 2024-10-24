//
//  ImageCacheManager.swift
//  Maps
//
//  Created by Supermove on 9/11/24.
//  Copyright © 2024 kr.co.supermove.rush. All rights reserved.
//

import UIKit

final class ImageCacheManager {
    static let shared = NSCache<NSString, UIImage>()
    private init() {}
}
