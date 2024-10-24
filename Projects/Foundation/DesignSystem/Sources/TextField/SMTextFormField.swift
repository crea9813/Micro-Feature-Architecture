//
//  SMTextFormField.swift
//  DesignSystem
//
//  Created by Supermove on 7/1/24.
//  Copyright © 2024 kr.co.supermove.rush. All rights reserved.
//

import UIKit

open class SMTextFormField: UITextField {
    
    open var title: String? {
        willSet(title) {
            self.titleLabel.text = title
        }
    }
    
    open var originalText: String?
    
    open var formattedText: String? {
        willSet(text) {
            self.text = text
        }
    }
    
    fileprivate let titleLabel = UILabel()
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupTitle()
        self.layer.borderColor = UIColor(hex: "2FC863").cgColor
        self.delegate = self
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension SMTextFormField {
    open override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: UIEdgeInsets(top: 26, left: 12, bottom: 10, right: 12))
    }
    
    open override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: UIEdgeInsets(top: 18, left: 12, bottom: 18, right: 12))
    }
    
    open override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: UIEdgeInsets(top: 18, left: 12, bottom: 18, right: 12))
    }
}

extension SMTextFormField: UITextFieldDelegate {
    
    private func setupTitle() {
        self.addSubviews(titleLabel)
        
        self.titleLabel.do {
            $0.font = .spoqaFont(size: 10, weight: .regular)
            $0.textColor = .black
            $0.alpha = 0
        }

        self.titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(9)
            $0.leading.equalToSuperview().inset(12)
        }
    }
    
    public func textFieldDidBeginEditing(_ textField: UITextField) {
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseInOut, animations: {
                self.titleLabel.alpha = 0
                self.backgroundColor = .white
                self.layer.borderWidth = 1
                self.layoutIfNeeded()
            })
        }
    }
    
    public func textFieldDidEndEditing(_ textField: UITextField) {
        if textField.text?.isEmpty ?? true {
            self.titleLabel.alpha = 0
            return
        }
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseInOut, animations: {
                self.backgroundColor =  UIColor(hex: "F7F7F7")
                self.layer.borderWidth = 0
                self.titleLabel.alpha = 1
                self.layoutIfNeeded()
            })
        }
    }
}
