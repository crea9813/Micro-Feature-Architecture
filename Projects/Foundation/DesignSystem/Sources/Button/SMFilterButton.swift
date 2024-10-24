//
//  SMFilterButton.swift
//  DesignSystem
//
//  Created by Supermove on 6/27/24.
//  Copyright © 2024 kr.co.supermove.rush. All rights reserved.
//

import Foundation
import UIKit
import SnapKit

open class SMFilterButton: UIButton {
    open var font: UIFont! = .spoqaFont(size: 12, weight: .medium) {
        didSet {
            self.titleLabel?.font = self.font
        }
    }
    
    open var title: String! {
        didSet {
            self.setTitle(self.title, for: .normal)
        }
    }
    
    open override var isSelected: Bool {
        didSet {
            self.updateView(in: isSelected)
        }
    }
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        self.setTitle(self.title, for: .normal)
        self.titleLabel?.font = self.font
    }
    
    private let dotView = UIView().then {
        $0.layer.cornerRadius = 1.5
        $0.backgroundColor = .sm(.primary)
        $0.isHidden = true
    }
    
    
    public init(with title: String) {
        self.title = title
        super.init(frame: .zero)
        self.backgroundColor = UIColor(hex: "F7F7F7")
        self.setTitleColor(.sm(.primary), for: .selected)
        self.setTitleColor(.black, for: .normal)
        self.layer.cornerRadius = 19
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.clear.cgColor
        self.isEnabled = true
        self.setImage(DesignSystemAsset.arrowDown.image, for: .normal)
        self.semanticContentAttribute = .forceRightToLeft
        self.contentHorizontalAlignment = .left
        self.contentEdgeInsets = .init(top: 0, left: 18, bottom: 0, right: 8)
        self.tintColor = UIColor(hex: "9E9E9E")
        
        self.addSubview(dotView)
        
        dotView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(7)
            $0.leading.equalToSuperview().inset(28)
            $0.width.height.equalTo(3)
        }
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension SMFilterButton {
    private func updateView(in isSelected: Bool) {
        if isSelected {
            self.titleLabel?.font = .spoqaFont(size: self.font.pointSize, weight: .medium)
            self.layer.borderColor = UIColor.sm(.primary).cgColor
            self.dotView.isHidden = false
            self.tintColor = .sm(.primary)
        } else {
            self.titleLabel?.font = .spoqaFont(size: self.font.pointSize, weight: .regular)
            self.dotView.isHidden = true
            self.layer.borderColor = UIColor.clear.cgColor
            self.tintColor = UIColor(hex: "9E9E9E")
        }
    }
}

