//
//  TipView.swift
//  DesignSystem
//
//  Created by Supermove on 10/17/24.
//  Copyright © 2024 kr.co.supermove.rush. All rights reserved.
//

import UIKit

open class TipView: UIView {
    
    private let color: UIColor!
    
    public init(frame: CGRect, _ color: UIColor) {
        self.color = color
        super.init(frame: frame)
    }
    
    public required init?(coder: NSCoder) {
        self.color = UIColor(red: 0.233, green: 0.233, blue: 0.233, alpha: 1)
        super.init(coder: coder)
    }
    
    public override func draw(_ rect: CGRect) {
        
        guard let context = UIGraphicsGetCurrentContext() else { return }
        
        context.move(to: CGPoint(x: rect.minX, y: rect.minY))
        context.addLine(to: CGPoint(x: rect.maxX / 2, y: rect.maxY))
        context.addLine(to: CGPoint(x: rect.maxX, y: rect.minY))
        context.closePath()
        
        context.setFillColor(color.cgColor)
        context.fillPath()
        
    }
}
