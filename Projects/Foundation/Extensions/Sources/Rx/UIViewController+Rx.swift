//
//  UIViewController+Rx.swift
//  Extensions
//
//  Created by Supermove on 7/2/24.
//  Copyright © 2024 kr.co.supermove.rush. All rights reserved.
//

import UIKit
import RxSwift

extension RxSwift.Reactive where Base: UIViewController {
    public var viewDidAppear: Observable<Void> {
        return methodInvoked(#selector(UIViewController.viewDidAppear)).mapToVoid()
      }
    
    public var viewWillAppear: Observable<Bool> {
        return methodInvoked(#selector(UIViewController.viewWillAppear)).map { $0.first as? Bool ?? false }
      }
    
    public var viewIsAppearing: Observable<Bool> {
        return methodInvoked(#selector(UIViewController.viewIsAppearing(_:))).map { $0.first as? Bool ?? false }
      }
    
    public var viewDidLoad: Observable<Void> {
        return methodInvoked(#selector(UIViewController.viewDidLoad)).map { $0.first as? Void ?? Void() }
    }
    
    public var viewWillDisappear: Observable<Bool> {
        return methodInvoked(#selector(UIViewController.viewWillDisappear(_:))).map { $0.first as? Bool ?? false }
    }
    
    public var viewDidDisappear: Observable<Bool> {
        return methodInvoked(#selector(UIViewController.viewDidDisappear(_:))).map { $0.first as? Bool ?? false }
    }
}

