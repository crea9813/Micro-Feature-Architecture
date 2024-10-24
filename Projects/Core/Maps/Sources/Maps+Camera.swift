//
//  Maps+Camera.swift
//  Maps
//
//  Created by Supermove on 9/12/24.
//  Copyright © 2024 kr.co.supermove.rush. All rights reserved.
//

import Foundation
import NMapsMap
import Then
import MapDomainInterface

extension Maps {
    internal struct CameraKey {
        static var timer             = "kr.co.supermove.camera.timer"
        static var duration             = "kr.co.supermove.camera.duration"
        static var completion             = "kr.co.supermove.camera.completion"
        static var activeCameras        = "kr.co.supermove.camera.activeCameras"
        static var queue                = "kr.co.supermove.marker.queue"
    }
    
    private class CameraCompletionWrapper {
        let completion: ((Bool) -> Void)?
        
        init(_ completion: ((Bool) -> Void)?) {
            self.completion = completion
        }
    }
    
    private var activeCameras: NSMutableArray {
        get {
            if let activeCameras = objc_getAssociatedObject(self, &CameraKey.activeCameras) as? NSMutableArray {
                return activeCameras
            } else {
                let activeCameras = NSMutableArray()
                objc_setAssociatedObject(self, &CameraKey.activeCameras, activeCameras, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
                return activeCameras
            }
        }
    }
    
    private var queue: NSMutableArray {
        get {
            if let queue = objc_getAssociatedObject(self, &CameraKey.queue) as? NSMutableArray {
                return queue
            } else {
                let queue = NSMutableArray()
                objc_setAssociatedObject(self, &CameraKey.queue, queue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
                return queue
            }
        }
    }
    
    // MARK: - Make Camera Methods
    public func makeCameraUpdate(
        _ cameraPosition: CameraPosition,
        animation: NMFCameraUpdateAnimation = .easeOut,
        duration: TimeInterval = 0.5,
        isQueueEnabled: Bool = true,
        completion: ((_ didCameraUpdateFinish: Bool) -> Void)? = nil
    ) {
        let position = NMGLatLng(lat: cameraPosition.latitude, lng: cameraPosition.longitude)
        let zoom: Double = cameraPosition.zoom
        makeCameraUpdate(
            position,
            zoom: zoom,
            animation: animation,
            duration: duration,
            isQueueEnabled: isQueueEnabled,
            completion: completion
        )
    }
    
    public func makeCameraUpdate(_ position: NMGLatLng? = nil, zoom: Double = 17.5, animation: NMFCameraUpdateAnimation = .easeOut, duration: TimeInterval = 2.0, isQueueEnabled: Bool = true, completion: ((_ didCameraUpdateFinish: Bool) -> Void)? = nil) {
        var cameraUpdate: NMFCameraUpdate?
        if let position {
            cameraUpdate = NMFCameraUpdate(position: NMFCameraPosition(position, zoom: zoom))
        } else {
            cameraUpdate = NMFCameraUpdate(zoomTo: zoom)
        }
        
        guard let cameraUpdate else { return }
        
        cameraUpdate.animation = animation
        cameraUpdate.animationDuration = duration
        
        objc_setAssociatedObject(
            cameraUpdate,
            &CameraKey.completion,
            CameraCompletionWrapper(completion),
            .OBJC_ASSOCIATION_RETAIN_NONATOMIC
        );
        
        moveCamera(cameraUpdate, isQueueEnabled: isQueueEnabled)
    }
    
    
    public func makeCameraUpdate(
        _ bounds: NMGLatLngBounds? = nil,
        paddingInset: UIEdgeInsets = UIEdgeInsets(top: 50, left: 30, bottom: 50, right: 30),
        animation: NMFCameraUpdateAnimation = .fly,
        duration: TimeInterval = 1,
        isQueueEnabled: Bool = true,
        completion: ((_ didCameraUpdateFinish: Bool) -> Void)? = nil
    ) {
        guard let bounds else { return }
        
        let cameraUpdate = NMFCameraUpdate(fit: bounds, paddingInsets: paddingInset)
        cameraUpdate.animation = animation
        cameraUpdate.animationDuration = duration
        
        objc_setAssociatedObject(
            cameraUpdate,
            &CameraKey.completion,
            CameraCompletionWrapper(completion),
            .OBJC_ASSOCIATION_RETAIN_NONATOMIC
        );
        
        moveCamera(cameraUpdate, isQueueEnabled: isQueueEnabled)
    }
    
    internal func moveCamera(_ cameraUpdate: NMFCameraUpdate, isQueueEnabled: Bool = true) {
        if isQueueEnabled && activeCameras.count > 0 {
            queue.add(cameraUpdate)
        } else {
            activeCameras.add(cameraUpdate)
            self.mapView.moveCamera(cameraUpdate)
            let timer = Timer(
                timeInterval: cameraUpdate.animationDuration,
                target: self,
                selector: #selector(Maps.cameraUpdateDidFinish(_:)),
                userInfo: cameraUpdate,
                repeats: false
            )
            RunLoop.main.add(timer, forMode: .common)
            objc_setAssociatedObject(
                cameraUpdate,
                &CameraKey.timer,
                timer,
                .OBJC_ASSOCIATION_RETAIN_NONATOMIC
            )
        }
    }
    
    @objc
    private func cameraUpdateDidFinish(_ timer: Timer) {
        guard let cameraUpdate = timer.userInfo as? NMFCameraUpdate else { return }
        
        self.activeCameras.remove(cameraUpdate)
        
        if let wrapper = objc_getAssociatedObject(cameraUpdate, &CameraKey.completion) as? CameraCompletionWrapper,
           let completion = wrapper.completion {
            completion(false)
        }
        
        if let nextCameraUpdate = self.queue.firstObject as? NMFCameraUpdate {
            self.queue.removeObject(at: 0)
            self.moveCamera(nextCameraUpdate)
        }
    }
}

extension NMFMapView {
    public func isDraggedLocationOutOfVisibleRange(mapView: NMFMapView) -> Bool {
        // 현재 지도 중심 위치
        let mapCenter = self.cameraPosition.target
        let centerLocation = NMGLatLng(lat: mapCenter.lat, lng: mapCenter.lng)
        
        // 드래그한 위치
        let draggedLocationPoint = mapView.cameraPosition.target
        
        // 실제 거리 계산 (현재 위치와 드래그한 위치 사이)
        
        let actualDistance = centerLocation.distance(to: draggedLocationPoint)
        
        // 지도에서 화면에 표시되는 최대 거리 계산 (지도 대각선)
        let bounds = mapView.contentBounds
        let topLeft = bounds.boundsLatLngs[0]
        let bottomRight = bounds.boundsLatLngs[1]
        let mapDiagonalDistance = topLeft.distance(to: bottomRight)
        
        // 실제 거리가 화면의 최대 거리보다 크면 화면을 벗어난 것으로 판단
        return actualDistance > mapDiagonalDistance
    }
}
