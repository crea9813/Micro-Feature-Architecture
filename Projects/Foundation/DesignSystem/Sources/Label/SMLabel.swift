//
//  SMLabel.swift
//  DesignSystem
//
//  Created by Supermove on 3/5/24.
//  Copyright © 2024 kr.co.supermove.rush. All rights reserved.
//

import UIKit

open class SMLabel: UILabel {
    private let insets: UIEdgeInsets
    
    required public init(insets: UIEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)) {
        self.insets = insets
        super.init(frame: CGRect.zero)
        self.clipsToBounds = true
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open override func drawText(in rect: CGRect) {
        super.drawText(in: rect.inset(by: insets))
    }
    
    open override var intrinsicContentSize: CGSize {
        get {
            var contentSize = super.intrinsicContentSize
            contentSize.height += insets.top + insets.bottom
            contentSize.width += insets.left + insets.right
            return contentSize
        }
    }
}
