//
//  ObservableType+Extension.swift
//  Util
//
//  Created by Supermove on 2/2/24.
//  Copyright © 2024 kr.co.supermove.rush. All rights reserved.
//

import RxSwift
import RxCocoa

public extension ObservableType {
    
    func catchErrorJustComplete() -> Observable<Element> {
        return catchError { _ in Observable.empty() }
    }
    
    func asDriverOnErrorJustComplete() -> Driver<Element> {
        return asDriver { _ in Driver.empty() }
    }
    
    func mapToVoid() -> Observable<Void> {
        return map { _ in }
    }
}

