//
//  UIStackView+AddArrangedSubViews.swift
//  Extensions
//
//  Created by Supermove on 6/27/24.
//  Copyright © 2024 kr.co.supermove.rush. All rights reserved.
//

import Foundation
import UIKit

public extension UIStackView {
    @discardableResult
    func addArrangedSubviews( _ closure: () -> [UIView]) -> [UIView] {
        let views = closure()
        views.forEach {
            self.addArrangedSubview($0)
        }
        return views
    }
    
    func addArrangedSubviews(_ views: UIView...) {
        views.forEach(self.addArrangedSubview(_:))
    }
}
