//
//  RoundedTextField.swift
//  DesignSystem
//
//  Created by Supermove on 9/11/24.
//  Copyright © 2024 kr.co.supermove.rush. All rights reserved.
//

import Foundation
import UIKit
import Then
import SnapKit

public class CertiTextField : UIView {
    
    public var textField : RoundedTextField
    
    public var clearButton = UIButton().then {
        $0.setImage(UIImage(named: "navigation_cancel"), for: .normal)
        $0.tintColor = UIColor(red: 0.8, green: 0.8, blue: 0.8, alpha: 1)
    }
    public var errorSubLabel = UILabel().then {
        $0.textColor = .systemRed
        $0.font = .spoqaFont(size: 14, weight: .medium)
        $0.isHidden = true
    }
    
    public init(
        _ cornerRadius: CGFloat,
        _ borderWidth: CGFloat,
        _ backgroundColor: UIColor,
        _ placeholder: String,
        font: UIFont,
        errorText: String,
        _ keyboardType: UIKeyboardType
    ) {
        self.textField = RoundedTextField(cornerRadius, borderWidth, UIColor(red: 0.933, green: 0.933, blue: 0.933, alpha: 1), backgroundColor, placeholder, font: font, textColor: .black)
        self.errorSubLabel.text = errorText
        textField.keyboardType = keyboardType
        
        super.init(frame: CGRect())
    
        self.setupView()
        self.bind()
    }
    
    public func showError(_ show : Bool) {
        errorSubLabel.isHidden = show
        textField.layer.borderColor = errorSubLabel.isHidden ? UIColor.sm(.primary).cgColor : UIColor.systemRed.cgColor
        textField.textColor = errorSubLabel.isHidden ? .sm(.text(.t10)) : UIColor.systemRed
    }
    
    private func setupView() {
        self.addSubview(textField)
        self.addSubview(clearButton)
        textField.addSubview(errorSubLabel)
        
        textField.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        clearButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(10)
            $0.centerY.equalToSuperview()
        }
        
        errorSubLabel.snp.makeConstraints {
            $0.top.equalTo(textField.snp.bottom).offset(12)
            $0.leading.equalToSuperview()
        }
    }
    var inputBorderColor : UIColor = UIColor(red: 0.933, green: 0.933, blue: 0.933, alpha: 1)
    
    private func bind() {
//        clearButton.rx.tap.bind {
//            [weak self] _ in
//            guard let self = self else { return }
//            self.textField.text = ""
//        }.disposed(by: disposeBag)
//        
//        self.textField.rx.controlEvent(.editingDidBegin).bind {
//            [weak self] _ in
//            guard let self = self else { return }
//            self.backgroundColor = .clear
//        }.disposed(by: disposeBag)
//        
//        self.textField.rx.controlEvent(.editingDidEndOnExit).bind {
//            [weak self] _ in
//            guard let self = self else { return }
//            self.textField.textColor = self.inputBorderColor
//            self.backgroundColor = .white
//        }.disposed(by: disposeBag)
//        
//        self.textField.rx.controlEvent(.editingDidEnd).bind {
//            [weak self] _ in
//            guard let self = self else { return }
//            self.textField.textColor = self.inputBorderColor
//            self.backgroundColor = .white
//        }.disposed(by: disposeBag)
//        
//        self.textField.rx.text.bind {
//            [weak self ] text in
//            guard let self = self else { return }
//            if text != "" {
//                self.clearButton.isHidden = false
//            } else {
//                self.clearButton.isHidden = true
//            }
//        }.disposed(by: disposeBag)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
}

open class RoundedTextField : UITextField, UITextFieldDelegate {
    
    var clearButton = BaseButton().then {
        $0.setImage(UIImage(named: "icClearT3"), for: .normal)
        $0.tintColor = UIColor(red: 0.8, green: 0.8, blue: 0.8, alpha: 1)
    }
    
    public func setupClearButton() {

        self.addSubview(clearButton)
        
        clearButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(10)
            $0.top.bottom.equalToSuperview()
            $0.width.equalTo(clearButton.snp.height)
        }
    }
   
    
    public init(_ cornerRadius : CGFloat, _ borderWidth: CGFloat, _ borderColor : UIColor, _ backgroundColor : UIColor, _ placeholder : String, font : UIFont, textColor : UIColor) {
        super.init(frame: CGRect())
        
        self.backgroundColor = backgroundColor
        self.layer.cornerRadius = cornerRadius
        self.layer.borderWidth = borderWidth
        self.layer.borderColor = borderColor.cgColor
        self.font = font
        self.textColor = .black
        self.attributedPlaceholder = NSAttributedString(
            string: placeholder,
            attributes: [
                NSAttributedString.Key.foregroundColor: UIColor(red: 0.698, green: 0.698, blue: 0.698, alpha: 1)
            ]
        )
        self.addLeftPadding(16)
        self.addRightPadding(16, viewMode: .unlessEditing)
        self.addRightPadding(46, viewMode: .whileEditing)
    }
    
    func bind() {
        let clearAction = UIAction(handler: { [weak self] _ in
            self?.text = nil
        })
        
        self.clearButton.addAction(clearAction, for: .touchUpInside)
    }
    
    public required init?(coder: NSCoder) {
        fatalError()
    }
    
    public func textFieldDidBeginEditing(_ textField: UITextField) {
        self.backgroundColor = UIColor(cgColor: self.layer.borderColor!)
    }
    
    public func textFieldDidEndEditing(_ textField: UITextField) {
        self.backgroundColor = .white
    }
    
}


