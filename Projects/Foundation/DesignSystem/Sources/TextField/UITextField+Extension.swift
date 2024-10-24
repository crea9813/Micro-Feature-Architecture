//
//  UITextField+Extension.swift
//  DesignSystem
//
//  Created by Supermove on 3/4/24.
//  Copyright © 2024 kr.co.supermove.rush. All rights reserved.
//

import UIKit

public extension UITextField {
    func addLeftPadding(_ inset : CGFloat, viewMode: ViewMode = .always) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: inset, height: self.frame.height))
        self.leftView = paddingView
        self.leftViewMode = viewMode
    }
    func addRightPadding(_ inset: CGFloat, viewMode: ViewMode = .always) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: inset, height: self.frame.height))
        self.rightView = paddingView
        self.rightViewMode = viewMode
    }
}
