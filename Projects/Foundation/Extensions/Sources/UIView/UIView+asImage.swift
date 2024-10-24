//
//  UIView+asImage.swift
//  Extensions
//
//  Created by Supermove on 10/17/24.
//  Copyright © 2024 kr.co.supermove.rush. All rights reserved.
//

import UIKit

extension UIView {
    public func asImage() -> UIImage {
        let renderer = UIGraphicsImageRenderer(bounds: bounds)
        return renderer.image { rendererContext in
            layer.render(in: rendererContext.cgContext)
        }
    }
}
