//
//  SMTextField.swift
//  DesignSystem
//
//  Created by Supermove on 3/4/24.
//  Copyright © 2024 kr.co.supermove.rush. All rights reserved.
//

import UIKit
import SnapKit

public final class SMTextField: UITextField {
    
    public func setImage(image: UIImage?) {
        self.iconView.image = image
    }
    
    public override var isSelected: Bool {
        willSet(isSelected) {
            if isSelected {
                focusing()
            } else {
                unfocusing()
            }
        }
    }
    
    public func focusing() {
        self.layer.borderWidth = 1
        self.backgroundColor = .white
    }
    
    public func unfocusing() {
        self.layer.borderWidth = 0
        self.backgroundColor = .sm(.background(.bg20))
    }
    
    private let iconView = UIImageView()
    
    private func setupViews() {
        self.addSubview(iconView)
        
        iconView.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(10)
            $0.leading.equalToSuperview().inset(8)
            $0.width.height.equalTo(24)
        }
        
        self.layer.cornerRadius = 8
        self.layer.borderColor = UIColor.sm(.primary).cgColor
        self.backgroundColor = UIColor(red: 0.969, green: 0.969, blue: 0.969, alpha: 1)
        self.addLeftPadding(36)
    }
    
    override init(frame : CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
