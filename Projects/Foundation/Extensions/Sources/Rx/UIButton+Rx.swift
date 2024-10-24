//
//  UIButton+Rx.swift
//  Extensions
//
//  Created by Supermove on 6/27/24.
//  Copyright © 2024 kr.co.supermove.rush. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

public extension Reactive where Base: UIButton {
    var isSelectedChanged: ControlProperty<Bool> {
        return base.rx.controlProperty(
            editingEvents: [.allTouchEvents],
            getter: { $0.isSelected },
            setter: { $0.isSelected = $1 })
    }
}
