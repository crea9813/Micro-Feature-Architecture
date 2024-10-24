//
//  NMapsMap+Rx.swift
//  Maps
//
//  Created by Supermove on 9/24/24.
//  Copyright © 2024 kr.co.supermove.rush. All rights reserved.
//

import Foundation
import NMapsMap
import RxSwift
import RxCocoa

public typealias MapViewRegionChanging = ((mapView: NMFMapView, reason: Int))

extension Reactive where Base: NMFMapView {
    public var delegate: DelegateProxy<NMFMapView, NMFMapViewDelegate> {
        return RxNMFMapViewCameraDelegateProxy.proxy(for: self.base)
    }
    
    public var mapViewRegionIsChanging: Observable<MapViewRegionChanging> {
        return delegate
            .methodInvoked(#selector(NMFMapViewDelegate.mapViewRegionIsChanging(_:byReason:)))
            .map { MapViewRegionChanging($0[0] as! NMFMapView, $0[1] as! Int) }
    }
    
    public var cameraDidChangeByReason: Observable<(NMFMapView, Bool, Int)> {
        return delegate
            .methodInvoked(#selector(NMFMapViewDelegate.mapView(_:regionDidChangeAnimated:byReason:)))
            .map({ ($0[0] as! NMFMapView, $0[1] as! Bool, $0[2] as! Int) })
    }
    
    public var mapViewIdle: Observable<NMFMapView> {
        return delegate
            .methodInvoked(#selector(NMFMapViewDelegate.mapViewIdle(_:)))
            .map({ ($0[0] as! NMFMapView) })
    }
    
    public var mapViewCameraIdle: Observable<NMGLatLng> {
        return delegate
            .methodInvoked(#selector(NMFMapViewDelegate.mapViewIdle(_:)))
            .map({ ($0[0] as! NMFMapView).cameraPosition.target })
    }
    
    
    public func setDelegate(_ delegate: NMFMapViewDelegate)
        -> Disposable {
        return RxNMFMapViewCameraDelegateProxy.installForwardDelegate(delegate, retainDelegate: false, onProxyForObject: self.base)
    }
}


public class RxNMFMapViewCameraDelegateProxy : DelegateProxy<NMFMapView, NMFMapViewDelegate>, DelegateProxyType, NMFMapViewDelegate {
    public static func currentDelegate(for object: NMFMapView) -> NMFMapViewDelegate? {
        return object.delegate
    }
    
    public static func setCurrentDelegate(_ delegate: NMFMapViewDelegate?, to object: NMFMapView) {
        object.delegate = delegate
    }
    
    public static func registerKnownImplementations() {
        self.register { (mapView) -> RxNMFMapViewCameraDelegateProxy in
            RxNMFMapViewCameraDelegateProxy(parentObject: mapView, delegateProxy: self)
        }
    }
}
