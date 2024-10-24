//
//  RxNMFMarkerDelegateProxy.swift
//  Maps
//
//  Created by Supermove on 9/24/24.
//  Copyright © 2024 kr.co.supermove.rush. All rights reserved.
//

import Foundation
import NMapsMap
import RxCocoa
import RxSwift

public class RxNMFMarkerDelegateProxy: DelegateProxy<Maps, NMFMarkerDelegate>,
                                     DelegateProxyType, NMFMarkerDelegate {
    
    public static func currentDelegate(for object: Maps) -> NMFMarkerDelegate? {
        return object.markerDelegate
    }
    
    public static func setCurrentDelegate(_ delegate: NMFMarkerDelegate?, to object: Maps) {
        object.markerDelegate = delegate
    }
    
    public static func registerKnownImplementations() {
        self.register(make: { maps -> RxNMFMarkerDelegateProxy in
            RxNMFMarkerDelegateProxy(parentObject: maps, delegateProxy: self)
        })
    }
}
