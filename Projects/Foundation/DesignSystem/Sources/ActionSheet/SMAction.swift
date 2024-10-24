//
//  SMAction.swift
//  DesignSystem
//
//  Created by Supermove on 3/12/24.
//  Copyright © 2024 kr.co.supermove.rush. All rights reserved.
//

import Then
import UIKit
import SnapKit

open class SMAction: UIButton {
    open var title: String!
    open var subTitle: String?
    open var style: UIAlertAction.Style!
    open var imageAlignment: ContentHorizontalAlignment!
    open var handler: ((SMAction) -> Void)?
    open var userInfo: [String:Any] = [:]
    
    public let contentLabel = UILabel().then {
        $0.font = .spoqaFont(size: 16, weight: .medium)
        $0.textColor = .sm(.text(.t10))
    }
    public let subContentLabel = UILabel().then {
        $0.font = .spoqaFont(size: 10, weight: .regular)
        $0.textColor = .sm(.text(.t20))
    }
    private let iconView = UIImageView(image: UIImage(named: "ic_action_done")).then {
        $0.tintColor = .sm(.primary)
    }
    
    public override var isSelected: Bool {
        willSet(isSelected) {
            updateActionView(isSelected: isSelected)
        }
    }
    
    public func updateActionView(isSelected: Bool) {
        if self.imageAlignment == .left {
            self.iconView.tintColor = isSelected ? .sm(.primary) : .sm(.background(.bg40))
        } else {
            self.iconView.isHidden = !isSelected
        }
        
        self.backgroundColor = isSelected ? .sm(.primary).withAlphaComponent(0.08) : .clear
    }
    
    public init() {
        super.init(frame: CGRect(x: 0, y: 0, width: 0, height: 56))
    }
    
    public init(title: String!,
                subTitle: String? = nil,
                imageAlignment: ContentHorizontalAlignment = .right,
                isSelected: Bool = false,
                isEnabled: Bool = true,
                userInfo: [String:Any] = [:],
                handler: ((SMAction) -> Void)? = nil) {
        self.title = title
        self.subTitle = subTitle
        self.handler = handler
        self.imageAlignment = imageAlignment
        self.userInfo = userInfo
        super.init(frame: CGRect(x: 0, y: 0, width: 0, height: 56))
        
        self.isEnabled = isEnabled
        self.isSelected = isSelected
        self.layer.cornerRadius = 8
        self.alpha = isEnabled ? 1 : 0.4
        
        self.contentLabel.text = self.title
        self.subContentLabel.text = self.subTitle
        
        self.addSubview(contentLabel)
        self.addSubview(iconView)
        self.addSubview(subContentLabel)
        
        switch imageAlignment {
        case .left:
            self.iconView.tintColor = isSelected ? .sm(.primary) : .sm(.background(.bg40))
            iconView.snp.makeConstraints {
                $0.centerY.equalToSuperview()
                $0.leading.equalToSuperview().inset(16)
            }
            contentLabel.snp.makeConstraints {
                $0.centerY.equalToSuperview()
                $0.leading.equalTo(iconView.snp.trailing).offset(8)
            }
            
            subContentLabel.snp.makeConstraints {
                $0.centerY.equalToSuperview()
                $0.trailing.equalToSuperview().inset(16)
            }
        default:
            self.iconView.isHidden = !isSelected
            contentLabel.snp.makeConstraints {
                $0.top.equalToSuperview().inset(10)
                $0.leading.equalToSuperview().inset(16)
            }
            
            subContentLabel.snp.makeConstraints {
                $0.top.equalTo(contentLabel.snp.bottom).offset(4)
                $0.leading.trailing.equalToSuperview().inset(16)
                $0.bottom.equalToSuperview().inset(9)
            }
            
            iconView.snp.makeConstraints {
                $0.centerY.equalToSuperview()
                $0.trailing.equalToSuperview().inset(16)
            }
        }
        
        self.addTarget(self, action: #selector(handleAction), for: .touchUpInside)
    }
    
    required public init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    @objc public func handleAction() {
        handler?(self)
    }
}
