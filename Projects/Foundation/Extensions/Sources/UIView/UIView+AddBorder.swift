//
//  UIView+AddBorder.swift
//  Extensions
//
//  Created by Supermove on 6/27/24.
//  Copyright © 2024 kr.co.supermove.rush. All rights reserved.
//

import Foundation
import UIKit

public extension UIView {
    enum ViewSide {
        case top
        case bottom
        case left
        case right
    }

    func addBorder(toSide side: ViewSide, withColor color: UIColor, andThickness thickness: CGFloat) {

        let border = CALayer()
        border.backgroundColor = color.cgColor

        switch side {
        case .left: border.frame = CGRect(x: frame.minX, y: frame.minY, width: thickness, height: frame.height); break
        case .right: border.frame = CGRect(x: frame.maxX, y: frame.minY, width: thickness, height: frame.height); break
        case .top: border.frame = CGRect(x: frame.minX, y: frame.minY, width: frame.width, height: thickness); break
        case .bottom: border.frame = CGRect(x: frame.minX, y: frame.maxY, width: frame.width, height: thickness); break
        }

        layer.addSublayer(border)
    
    }
}
