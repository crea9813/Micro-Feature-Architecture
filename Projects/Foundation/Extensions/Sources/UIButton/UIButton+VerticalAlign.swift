//
//  UIButton+VerticalAlign.swift
//  Extensions
//
//  Created by Supermove on 9/6/24.
//  Copyright © 2024 kr.co.supermove.rush. All rights reserved.
//

import UIKit

public extension UIButton {
    func alignVertical(spacing: CGFloat = 2.0) {
        guard
            let image = self.imageView?.image,
            let titleLabel = self.titleLabel,
            let titleText = titleLabel.text
        else { return }
        
        let titleSize = titleText.size(
            withAttributes: [NSAttributedString.Key.font: titleLabel.font as Any]
        )
        
        titleEdgeInsets = UIEdgeInsets(
            top: spacing,
            left: -image.size.width,
            bottom: -image.size.height,
            right: 0
        )
        imageEdgeInsets = UIEdgeInsets(
            top: -(titleSize.height + spacing),
            left: 0,
            bottom: 0,
            right: -titleSize.width
        )
    }
}
