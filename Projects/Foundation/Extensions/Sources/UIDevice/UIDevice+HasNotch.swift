//
//  UIDevice+HasNotch.swift
//  Util
//
//  Created by Supermove on 1/17/24.
//  Copyright © 2024 kr.co.supermove.rush. All rights reserved.
//

import Foundation
import UIKit

public extension UIDevice {
    static var hasNotch: Bool {
        UIApplication.shared.keyWindow?.safeAreaInsets.bottom ?? 0 > 0
    }
}
