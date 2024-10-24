//
//  Maps+Rx.swift
//  Maps
//
//  Created by Supermove on 9/24/24.
//  Copyright © 2024 kr.co.supermove.rush. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import NMapsMap

public extension Reactive where Base: Maps {
    var delegate: DelegateProxy<Maps, NMFMarkerDelegate> {
        return RxNMFMarkerDelegateProxy.proxy(for: self.base)
    }
    
    var didSelectMarker: Observable<NMFMarker> {
        return delegate
            .methodInvoked(#selector(NMFMarkerDelegate.marker(_:_:)))
            .map({ return $0[1] as! NMFMarker })
    }
    
    func setDelegate(_ delegate: NMFMarkerDelegate) -> Disposable {
        return RxNMFMarkerDelegateProxy.installForwardDelegate(delegate, retainDelegate: false, onProxyForObject: self.base)
    }
}
