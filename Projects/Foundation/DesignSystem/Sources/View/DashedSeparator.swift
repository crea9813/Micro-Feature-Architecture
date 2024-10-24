//
//  DashedSeparator.swift
//  DesignSystem
//
//  Created by Supermove on 7/11/24.
//  Copyright © 2024 kr.co.supermove.rush. All rights reserved.
//

import UIKit

open class DashedSeparator: UIView {
    
    open override func draw(_ rect: CGRect) {
        let shapeLayer = CAShapeLayer()
        shapeLayer.strokeColor = UIColor(hex: "BCBDBD").cgColor
        shapeLayer.lineWidth = 1
        shapeLayer.lineDashPattern = [2, 2]
        
        let path = CGMutablePath()
        path.addLines(between: [CGPoint(x: 0, y: 0),
                                CGPoint(x: rect.width, y: 0)])
        shapeLayer.path = path
        layer.addSublayer(shapeLayer)
    }
}
