//
//  BaseButton.swift
//  DesignSystem
//
//  Created by Supermove on 9/11/24.
//  Copyright © 2024 kr.co.supermove.rush. All rights reserved.
//

import UIKit

open class BaseButton: UIButton {
    
    public var touchBoundsInsets: CGFloat = 20
    
    public override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        super.point(inside: point, with: event)
        
        let insets = -(self.touchBoundsInsets)
        let touchArea = bounds.insetBy(dx: insets, dy: insets)
        return touchArea.contains(point)
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupConstraints()
    }
    
    @available(*, unavailable)
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open func setupViews() { }
    open func setupConstraints() { }
}
