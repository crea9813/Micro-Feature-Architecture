//
//  UIViewController+ObserveKeyboardHeight.swift
//  Extensions
//
//  Created by Supermove on 8/29/24.
//  Copyright © 2024 kr.co.supermove.rush. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

extension Reactive where Base: UIViewController {
    public var isKeyboardHeightChanged: Observable<CGFloat> {
        return Observable
            .from([
                NotificationCenter.default.rx
                    .notification(UIResponder.keyboardWillShowNotification)
                    .map { notification -> CGFloat in
                        (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.height ?? 0 },
                NotificationCenter.default.rx
                    .notification(UIResponder.keyboardWillHideNotification)
                    .map { _ -> CGFloat in return 0 }
            ])
            .merge()
            .share()
    }
}
