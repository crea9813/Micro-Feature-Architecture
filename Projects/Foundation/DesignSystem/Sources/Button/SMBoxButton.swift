//
//  SMBoxButton.swift
//  DesignSystem
//
//  Created by Supermove on 3/4/24.
//  Copyright © 2024 kr.co.supermove.rush. All rights reserved.
//

import UIKit

extension SMBoxButton {
    public enum SMButtonStyle: Int {
        case primary
        case subtle
        case outline
    }

    public enum SMButtonState: Int {
        case active
        case inactive
        case pressed
        case loading
    }
}

open class SMBoxButton: UIButton {
    open var buttonStyle: SMBoxButton.SMButtonStyle
    
    open var font: UIFont! = .spoqaFont(size: 16, weight: .bold) {
        didSet {
            self.titleLabel?.font = self.font
        }
    }
    
    open var title: String! {
        didSet {
            self.setTitle(self.title, for: .normal)
        }
    }
    
    open override var isEnabled: Bool {
        didSet {
            self.updateView(in: isEnabled ? .active : .inactive)
        }
    }
    
    var activeBackgroundColor: UIColor {
        switch self.buttonStyle {
        case .primary: return UIColor(red: 0.18, green: 0.78, blue: 0.39, alpha: 1)
        case .subtle: return UIColor(red: 0.18, green: 0.78, blue: 0.39, alpha: 0.16)
        case .outline: return .clear
        }
    }
    
    var activeTitleColor: UIColor {
        switch self.buttonStyle {
        case .primary: return UIColor.white
        case .subtle, .outline: return UIColor(red: 0.18, green: 0.78, blue: 0.39, alpha: 1)
        }
    }
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        self.setTitle(self.title, for: .normal)
        self.titleLabel?.font = self.font
    }
    
    public init(with title: String, buttonStyle: SMButtonStyle = .primary) {
        self.title = title
        self.buttonStyle = buttonStyle
        super.init(frame: CGRect(x: 0, y: 0, width: 0, height: 56))
        self.setTitleColor(activeTitleColor, for: .normal)
        self.setTitleColor(UIColor.sm(.text(.t40)), for: .disabled)
        self.layer.cornerRadius = 8
        self.isEnabled = true
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension SMBoxButton {
    
    private func updateView(in state: SMButtonState) {
        switch state {
        case .active:
            self.backgroundColor = activeBackgroundColor
            self.titleLabel?.font = .spoqaFont(size: self.font.pointSize, weight: .bold)
        case .inactive:
            self.backgroundColor = UIColor.sm(.background(.bg40))
            self.titleLabel?.font = .spoqaFont(size: self.font.pointSize, weight: .medium)
        case .pressed:
            self.backgroundColor = UIColor.sm(.primary)
            self.titleLabel?.textColor = .white
        case .loading:
            self.backgroundColor = UIColor.sm(.primary)
            self.titleLabel?.textColor = .white
        }
    }
}
