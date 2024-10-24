//
//  UITextField+Rx.swift
//  Extensions
//
//  Created by Supermove on 6/27/24.
//  Copyright © 2024 kr.co.supermove.rush. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

public extension Reactive where Base: UITextField {
    var isSelectedChanged: ControlProperty<Bool> {
        return base.rx.controlProperty(
            editingEvents:  [.allEvents],
            getter: { $0.isSelected },
            setter: { $0.isSelected = $1 })
    }
}
