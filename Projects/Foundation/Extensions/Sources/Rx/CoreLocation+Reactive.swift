//
//  CoreLocation+Reactive.swift
//  Extensions
//
//  Created by Supermove on 9/24/24.
//  Copyright © 2024 kr.co.supermove.rush. All rights reserved.
//

import Foundation
import CoreLocation
import RxSwift
import RxCocoa

extension Reactive where Base: CLLocationManager {
    public var delegate : DelegateProxy<CLLocationManager, CLLocationManagerDelegate> {
        return RxCLLocationDelegateProxy.proxy(for: self.base)
    }
    
    public var didChangeAuthorizationStatus: Observable<CLAuthorizationStatus> {
        RxCLLocationDelegateProxy.proxy(for: base).didChangeAuthorizationStatusSubject.asObservable()
    }
    
    public var didUpdateLocations: Observable<[CLLocation]> {
        RxCLLocationDelegateProxy.proxy(for: base).didUpdateLocationSubject.asObservable()
    }
    
    public var didFailWithError: Observable<Error> {
        RxCLLocationDelegateProxy.proxy(for: base).didFailWithErrorSubject.asObservable()
    }
    
    public var didPauseLocationUpdates: Observable<Void> {
          return delegate.methodInvoked(#selector(CLLocationManagerDelegate.locationManagerDidPauseLocationUpdates(_:)))
              .map { _ in
                  return ()
              }
      }
    
      public var didResumeLocationUpdates: Observable<Void> {
          return delegate.methodInvoked( #selector(CLLocationManagerDelegate.locationManagerDidResumeLocationUpdates(_:)))
              .map { _ in
                  return ()
              }
      }
    }


public class RxCLLocationDelegateProxy : DelegateProxy<CLLocationManager, CLLocationManagerDelegate>, DelegateProxyType, CLLocationManagerDelegate {
    
    public static func currentDelegate(for object: CLLocationManager) -> CLLocationManagerDelegate? {
        return object.delegate
    }
    
    public static func setCurrentDelegate(_ delegate: CLLocationManagerDelegate?, to object: CLLocationManager) {
        object.delegate = delegate
    }
    
    
    public init(locationManager : CLLocationManager) {
        super.init(parentObject: locationManager, delegateProxy: RxCLLocationDelegateProxy.self)
    }
    
    public static func registerKnownImplementations() {
        self.register { RxCLLocationDelegateProxy(locationManager: $0) }
    }
    
    internal lazy var didUpdateLocationSubject = PublishSubject<[CLLocation]>()
    internal lazy var didFailWithErrorSubject = PublishSubject<Error>()
    internal lazy var didChangeAuthorizationStatusSubject = PublishSubject<CLAuthorizationStatus>()
    
    public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        _forwardToDelegate?.locationManager?(manager, didUpdateLocations: locations)
        didUpdateLocationSubject.onNext(locations)
    }
    
    public func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        _forwardToDelegate?.locationManagerDidChangeAuthorization(manager)
        didChangeAuthorizationStatusSubject.onNext(manager.authorizationStatus)
    }
    
    public func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        _forwardToDelegate?.locationManager?(manager, didFailWithError: error)
        didFailWithErrorSubject.onNext(error)
    }
    
    deinit {
        self.didUpdateLocationSubject.on(.completed)
        self.didFailWithErrorSubject.on(.completed)
        self.didChangeAuthorizationStatusSubject.on(.completed)
    }
    
    
}
