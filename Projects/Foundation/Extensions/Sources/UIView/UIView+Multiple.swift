//
//  UIView+Multiple.swift
//  Util
//
//  Created by Supermove on 3/4/24.
//  Copyright © 2024 kr.co.supermove.rush. All rights reserved.
//

import UIKit

public extension UIView {
    @discardableResult
    func addSubviews( _ closure: () -> [UIView]) -> [UIView] {
        let views = closure()
        views.forEach {
            self.addSubview($0)
        }
        return views
    }

    func addSubviews(_ views: UIView...) {
        views.forEach(self.addSubview(_:))
    }
}
