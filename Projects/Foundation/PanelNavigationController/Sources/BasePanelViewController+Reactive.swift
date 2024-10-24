//
//  BasePanelDelegate+Reactive.swift
//  PanelNavigationController
//
//  Created by Supermove on 9/24/24.
//  Copyright © 2024 kr.co.supermove.rush. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import FloatingPanel

public extension RxSwift.Reactive where Base: BasePanelViewController {
    var panelDidChangeState: Observable<FloatingPanelState> {
        return methodInvoked(#selector(BasePanelViewController.floatingPanelDidChangeState(_:)))
            .compactMap { $0.first as? FloatingPanelController }
            .map { $0.state }
    }
    var panelState: Observable<FloatingPanelState> {
        return methodInvoked(#selector(BasePanelViewController.floatingPanelDidEndAttracting(_:)))
            .compactMap { $0.first as? FloatingPanelController }
            .map { $0.state }
    }
    
    var panelDidLoad: Observable<Void> {
        return methodInvoked(#selector(BasePanelViewController.floatingPanel(_:animatorForPresentingTo:))).mapToVoid()
            .debounce(.milliseconds(100), scheduler: MainScheduler.asyncInstance)
    }
    
    var panelDidDisappear: Observable<Void> {
        return methodInvoked(#selector(BasePanelViewController.floatingPanelDidChangeState(_:)))
            .compactMap { $0.first as? FloatingPanelController }
            .filter { $0.state == .hidden }
            .mapToVoid()
    }
    
    var panelDidRemove: Observable<Void> {
        return methodInvoked(#selector(BasePanelViewController.floatingPanelDidRemove(_:))).mapToVoid()
    }
    
    var panelIsDragging: Observable<Bool> {
        return Observable.merge(
            methodInvoked(#selector(BasePanelViewController.floatingPanelWillBeginDragging(_:))).map { _ in true },
            methodInvoked(#selector(BasePanelViewController.floatingPanelWillEndDragging(_:withVelocity:targetState:))).map { _ in false }
        )
    }
}

extension ObservableType {
    func mapToVoid() -> Observable<Void> {
        return map { _ in }
    }
}
