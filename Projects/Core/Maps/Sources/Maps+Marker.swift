//
//  Maps+Marker.swift
//  Maps
//
//  Created by Supermove on 9/11/24.
//  Copyright © 2024 kr.co.supermove.rush. All rights reserved.
//

import Then
import DesignSystem
import NMapsMap
import Foundation
import MapDomainInterface
import BaseDomainInterface

fileprivate extension TransportType {
    var color : UIColor {
        switch self {
        case .bus: return UIColor(hex: "6DC1FE")
        case .subway: return UIColor(hex: "35608C")
        case .scooter: return UIColor(hex: "FF9431")
        case .bike: return UIColor(hex: "4ED36B")
        case .taxi: return UIColor(hex: "555D66")
        case .carSharing: return UIColor(hex: "7F7CFD")
        case .uam: return UIColor(red: 0.333, green: 0.688, blue: 1, alpha: 1)
        case .train: return UIColor(red: 0.333, green: 0.688, blue: 1, alpha: 1)
        case .intercityBus: return .clear
        case .air: return .clear
        default: return .clear
        }
    }
    
    var borderColor : UIColor {
        switch self {
        case .bus: return UIColor(hex: "5FB3F0")
        case .subway: return UIColor(hex: "27496A")
        case .scooter: return UIColor(hex: "FD862F")
        case .bike: return UIColor(hex: "3FBF5B")
        case .taxi: return UIColor(hex: "3E444A")
        case .carSharing: return UIColor(hex: "5855FF")
        case .uam: return UIColor(red: 0.156, green: 0.536, blue: 0.983, alpha: 1)
        case .train: return .white
        case .intercityBus: return .clear
        case .air: return .clear
        default: return .clear
        }
    }
}


extension NMFMarker {
    public var detail: MarkerItem? {
        self.userInfo["markerItem"] as? MarkerItem
    }
}

@objc public protocol NMFMarkerDelegate {
    @objc optional func marker(_ mapView: NMFMapView, _ didSelectItem: NMFMarker)
}

extension Maps {
    internal struct MarkerKeys {
        static var activeRegionTooltips = "kr.co.supermove.marker.activeTooltips"
        static var activeMarker         = "kr.co.supermove.marker.activeMarker"
        static var previewMarker        = "kr.co.supermove.marker.previewMarker"
        static var hightlightMarker     = "kr.co.supermove.marker.hightlightMarker"
        static var markers              = "kr.co.supermove.marker.markers"
        static var pmMarkers            = "kr.co.supermove.marker.PM"
        static var queue                = "kr.co.supermove.marker.queue"
    }
    
    private enum MarkerError: Error {
        case invalidURL
        case failedMakeMarkerIcon
    }
    
    private var activeRegionTooltips: NSMutableArray {
        get {
            if let activeRegionTooltips = objc_getAssociatedObject(self, &MarkerKeys.activeRegionTooltips) as? NSMutableArray {
                return activeRegionTooltips
            } else {
                let activeRegionTooltips = NSMutableArray()
                objc_setAssociatedObject(self, &MarkerKeys.activeRegionTooltips, activeRegionTooltips, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
                return activeRegionTooltips
            }
        }
    }
    
    private var pmMarkers: NSMutableArray {
        get {
            if let activeRegionTooltips = objc_getAssociatedObject(self, &MarkerKeys.pmMarkers) as? NSMutableArray {
                return activeRegionTooltips
            } else {
                let activeRegionTooltips = NSMutableArray()
                objc_setAssociatedObject(self, &MarkerKeys.pmMarkers, activeRegionTooltips, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
                return activeRegionTooltips
            }
        }
    }
    
    private var markers: NSMutableArray {
        get {
            if let activeRegionTooltips = objc_getAssociatedObject(self, &MarkerKeys.markers) as? NSMutableArray {
                return activeRegionTooltips
            } else {
                let activeRegionTooltips = NSMutableArray()
                objc_setAssociatedObject(self, &MarkerKeys.markers, activeRegionTooltips, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
                return activeRegionTooltips
            }
        }
    }
}

extension Maps {
    
    @discardableResult
    public func updateCameraToActiveMarker() -> Bool {
        guard let activeMarker else { return false }
        self.makeCameraUpdate(activeMarker.position, duration: 0.5, isQueueEnabled: false)
        return true
    }
    
    @discardableResult
    public func updateCameraToPreviewMarker() -> Bool {
        guard let previewMarker else { return false }
        self.makeCameraUpdate(previewMarker.position, duration: 0.5, isQueueEnabled: false)
        return true
    }
    
    public var activeMarker: NMFMarker? {
        guard let activeMarker = objc_getAssociatedObject(self, &MarkerKeys.activeMarker) as? NMFMarker else { return nil }
        return activeMarker
    }
    
    public var hightlightMarker: NMFMarker? {
        guard let hightlightMarker = objc_getAssociatedObject(self, &MarkerKeys.hightlightMarker) as? NMFMarker else { return nil }
        return hightlightMarker
    }
    
    public var previewMarker: NMFMarker? {
        guard let previewMarker = objc_getAssociatedObject(self, &MarkerKeys.previewMarker) as? NMFMarker else { return nil }
        return previewMarker
    }
    
    public func markerById(_ id: String) -> NMFMarker? {
        guard let markers = markers as? [NMFMarker] else { return nil }
        guard let marker = markers.first(where: { $0.detail?.id == id }) else { return nil }
        return marker
    }
}

extension Maps {
    public func makePreviewMarker(with markerItem: MarkerItem) {
        let type = markerItem.transportType
        let iconImage = iconImageForTransportMarker(with: type)!
        let position = NMGLatLng(lat: markerItem.latitude, lng: markerItem.longitude)
        var overlayImage = NMFOverlayImage(image: iconImage, reuseIdentifier: type.rawValue)
        
//        if type == .subway,
//           let detail = markerItem.detail as? SubwayStationDetail,
//           let subwayType = SubwayType(lineId: detail.lineID),
//           let iconImage = self.iconImageForTransportMarker(
//               with: .subway,
//               color: subwayType.color
//           ) {
//            overlayImage = NMFOverlayImage(image: iconImage)
//        }
        
        var marker = NMFMarker(position: position, iconImage: overlayImage)
        marker.userInfo["isSelected"] = false
        marker.userInfo["id"] = markerItem.id
        marker.userInfo["markerItem"] = markerItem
        marker.zIndex = 3
        marker.width = 36
        marker.height = 43
        marker.maxZoom = markerItem.maxLevel
        marker.minZoom = markerItem.minLevel
        marker.anchor = type == .bus ? CGPoint(x: 0.5, y: 0.5) : CGPoint(x: 0.5, y: 1)
        marker.touchHandler = { [unowned self] overlay in
            guard let marker = overlay as? NMFMarker else { return true }
            selectMarker(with: marker)
            return true
        }
        
        marker.mapView = self.mapView
        updateMarker(with: &marker, isSelected: true)
        objc_setAssociatedObject(self, &MarkerKeys.previewMarker, marker, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
    
    public func removePreviewMarker() {
        previewMarker?.mapView = nil
        objc_setAssociatedObject(self, &MarkerKeys.previewMarker, nil, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
}

extension Maps {
    public func makeMarker(_ markerItem: MarkerItem) {
        
        if let hightlightMarker, let activeMarkerID = hightlightMarker.userInfo["id"] as? String,
           activeMarkerID == markerItem.id {
            return
        }
        
        
        let type = markerItem.transportType
        let iconImage = iconImageForTransportMarker(with: type)!
        let position = NMGLatLng(lat: markerItem.latitude, lng: markerItem.longitude)
        var overlayImage = NMFOverlayImage(image: iconImage, reuseIdentifier: type.rawValue)
        
        //            if let detail = markerItem.detail as? SubwayStationDetail,
        //               let subwayType = SubwayType(lineId: detail.lineID) {
        //                let iconImage = self.iconImageForTransportMarker(
        //                    with: .subway,
        //                    color: subwayType.color
        //                )!
        //                overlayImage = NMFOverlayImage(image: iconImage)
        //            }
        
        if let serviceIconImageURL = markerItem.serviceIconImageUrl,
           let iconImage = pmIconImageForMarker(with: serviceIconImageURL) {
            overlayImage = NMFOverlayImage(image: iconImage)
        }
        
        var marker = NMFMarker(position: position, iconImage: overlayImage)
        marker.userInfo["id"] = markerItem.id
        marker.userInfo["markerItem"] = markerItem
        marker.zIndex = 3
        marker.width = 36
        marker.height = 43
        marker.maxZoom = markerItem.maxLevel
        marker.minZoom = markerItem.minLevel
        marker.anchor = type == .bus ? CGPoint(x: 0.5, y: 0.5) : CGPoint(x: 0.5, y: 1)
        marker.touchHandler = { [unowned self] overlay in
            guard let marker = overlay as? NMFMarker else { return true }
            self.markerDelegate?.marker?(self.mapView, marker)
            return true
        }
        
        showMarker(marker)
        
        if let previewMarker, let previewMarkerID = previewMarker.userInfo["id"] as? String, previewMarkerID == markerItem.id {
            removePreviewMarker()
            updateMarker(with: &marker, isSelected: true)
            objc_setAssociatedObject(self, &MarkerKeys.hightlightMarker, marker, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            
            //                if let activeInfoWindow = objc_getAssociatedObject(self, &InfoWindowKeys.activeWalkInfoWindow) as? NMFInfoWindow {
            //                    activeInfoWindow.open(with: marker)
            //                }
        }
    }
    
    public func makeTransportMarkers(_ markerItem: MarkerItem) {
        do {
            
            let type = markerItem.transportType
            let iconImage = iconImageForTransportMarker(with: type)!
            let position = NMGLatLng(lat: markerItem.latitude, lng: markerItem.longitude)
            var overlayImage = NMFOverlayImage(image: iconImage, reuseIdentifier: type.rawValue)
            
//            if let detail = markerItem.detail as? SubwayStationDetail,
//               let subwayType = SubwayType(lineId: detail.lineID) {
//                let iconImage = self.iconImageForTransportMarker(
//                    with: .subway,
//                    color: subwayType.color
//                )!
//                overlayImage = NMFOverlayImage(image: iconImage)
//            }
            
            if let serviceIconImageURL = markerItem.serviceIconImageUrl,
               let iconImage = pmIconImageForMarker(with: serviceIconImageURL) {
                overlayImage = NMFOverlayImage(image: iconImage)
            }
            
            var marker = NMFMarker(position: position, iconImage: overlayImage)
            marker.userInfo["isSelected"] = false
            marker.userInfo["id"] = markerItem.id
            marker.userInfo["markerItem"] = markerItem
            marker.zIndex = 3
            marker.width = 36
            marker.height = 43
            marker.maxZoom = markerItem.maxLevel
            marker.minZoom = markerItem.minLevel
            marker.anchor = type == .bus ? CGPoint(x: 0.5, y: 0.5) : CGPoint(x: 0.5, y: 1)
            marker.touchHandler = { [unowned self] overlay in
                guard let marker = overlay as? NMFMarker else { return true }
                selectMarker(with: marker)
                return true
            }
            
            showMarker(marker)
            
            if let activeMarker, let activeMarkerID = activeMarker.userInfo["id"] as? String,
               activeMarkerID == markerItem.id {
                updateMarker(with: &marker, isSelected: true)
                objc_setAssociatedObject(self, &MarkerKeys.activeMarker, marker, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
                return
            }
            
            if let previewMarker,
                let previewMarkerID = previewMarker.userInfo["id"] as? String,
               previewMarkerID == markerItem.id {
                removePreviewMarker()
                updateMarker(with: &marker, isSelected: true)
                objc_setAssociatedObject(self, &MarkerKeys.activeMarker, marker, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
                
//                if let activeInfoWindow = objc_getAssociatedObject(self, &InfoWindowKeys.activeWalkInfoWindow) as? NMFInfoWindow {
//                    activeInfoWindow.open(with: marker)
//                }
            }
        } catch {
            print(error)
        }
    }
    
    public func showMarker(_ marker: NMFMarker) {
        markers.add(marker)
        marker.mapView = self.mapView
    }
    
    public func removeMarkers() {
        markers.forEach {
            guard let marker = $0 as? NMFMarker else { return }
            if let activeMarker, activeMarker.detail?.id == marker.detail?.id {
                return
            }
            marker.mapView = nil
        }
        
        let saveMarker = markers.first(where: {
            guard let marker = $0 as? NMFMarker else { return false }
            if let activeMarker, activeMarker.detail?.id == marker.detail?.id {
                return true
            }
            return false
        })
        
        markers.removeAllObjects()
        
        if let saveMarker {
            markers.add(saveMarker)
        }
        
        
//        markers.removeAllObjects()
//        (markers
//            .filter {
//                guard let marker = $0 as? NMFMarker, marker.detail?.id == activeMarker?.detail?.id else { return false }
//                return true
//            } as? NSMutableArray)?.removeAllObjects()
//        
//        print("Markers: \(markers)")
    }
    
    public func removeMarker(ignore markerId: String) {
        markers
            .forEach {
                guard let marker = $0 as? NMFMarker, marker.detail?.id != markerId else { return }
                marker.mapView = nil
            }
        
        (markers
            .filter {
                guard let marker = $0 as? NMFMarker, marker.detail?.id != markerId else { return false }
                return true
            } as? NSMutableArray)?.removeAllObjects()
    }
    
    public func removeAllMarkers() {
        self.removeActiceMarker()
        self.removeMarkers()
    }
    
    public func removeActiceMarker() {
        guard let activeMarker = objc_getAssociatedObject(self, &MarkerKeys.activeMarker) as? NMFMarker else { return }
        activeMarker.mapView = nil
        objc_setAssociatedObject(self, &MarkerKeys.activeMarker, nil, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
    
    public func unselectActiveMarker() {
        guard let activeMarker = objc_getAssociatedObject(self, &MarkerKeys.activeMarker) as? NMFMarker else { return }
        self.updateMarker(with: activeMarker, isSelected: false)
        objc_setAssociatedObject(self, &MarkerKeys.activeMarker, nil, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
    
    private func iconImageForTransportMarker(with transportType: TransportType, color: UIColor? = nil, isBorder: Bool = false, isSelected: Bool = false) -> UIImage? {
        var color = color == nil ? transportType.color : color!
        let imageSize = CGSize(width: 30, height: 36)
        
        UIGraphicsBeginImageContextWithOptions(imageSize, false, 0)
        
        let context = UIGraphicsGetCurrentContext()!
        context.saveGState()
        color.set()
        
        if transportType == .bus && !isSelected {
            let baseImage = DesignSystemAsset.busSquareBackground.image
            baseImage.draw(at: CGPoint(x: 6, y: 6))
        } else {
            let baseImage = DesignSystemAsset.mappinLargeFillWhite.image
            baseImage.draw(at: CGPoint(x: 0, y: 0))
        }
        
        if isBorder {
            let border = DesignSystemAsset.mappinBorder.image
            transportType.borderColor.set()
            border.draw(at: CGPoint(x: 0, y: 0))
        }
        
        UIColor.white.set()
        
        switch transportType {
        case .bus:
            if isSelected {
                let icon = DesignSystemAsset.busFillWhite.image
                icon.draw(at: CGPoint(x: 6, y: 5))
            } else {
                let icon = DesignSystemAsset.busFill14.image
                icon.draw(at: CGPoint(x: 8, y: 8))
            }
        case .subway:
            let icon = UIImage(named: "ic_subway_18x18")
            icon?.draw(at: CGPoint(x: 6, y: 6))
        case .scooter:
            let icon = UIImage(named: "ic_scooter_18x18")
            icon?.draw(at: CGPoint(x: 5, y: 5))
        case .bike:
            let icon = UIImage(named: "ic_bike_18x18")
            icon?.draw(at: CGPoint(x: 6, y: 5))
        case .taxi:
            let icon = UIImage(named: "ic_taxi_18x18")
            icon?.draw(at: CGPoint(x: 6, y: 5))
        case .carSharing:
            let icon = UIImage(named: "ic_carsharing_18x18")
            icon?.draw(at: CGPoint(x: 6, y: 5))
        case .uam:
            let icon = UIImage(named: "ic_uam_20x20")
            icon?.draw(at: CGPoint(x: 5, y: 5))
        default: return nil
        }
        
        context.restoreGState()
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage
    }
}


extension Maps {
//    public func makePMMarkers(markerItem: MapItem) {
//        do {
//            let serviceName = markerItem.serviceName
//            let serviceIconImageURL = markerItem.serviceIcon
//            let iconImage = try pmIconImageForMarker(with: serviceIconImageURL)
//            let overlayImage = NMFOverlayImage(image: iconImage, reuseIdentifier: serviceName!)
//            let position = NMGLatLng(lat: markerItem.lat!, lng: markerItem.lng!)
//            var marker = NMFMarker(position: position, iconImage: overlayImage)
//            marker.userInfo["isSelected"] = false
//            marker.userInfo["id"] = markerItem.id!
//            marker.userInfo["markerItem"] = markerItem
//            marker.zIndex = 3
//            marker.width = 36
//            marker.height = 43
//            marker.maxZoom = markerItem.maxLevel
//            marker.minZoom = markerItem.minLevel
//            marker.anchor = CGPoint(x: 0.5, y: 1)
//            marker.touchHandler = { [unowned self] overlay in
//                guard overlay is NMFMarker else { return true }
//                if let activeMarker = objc_getAssociatedObject(self, &MarkerKeys.activeMarker) as? NMFMarker {
//                    self.updateMarker(with: activeMarker, isSelected: false)
//                    objc_setAssociatedObject(self, &MarkerKeys.activeMarker, nil, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
//                }
//                self.markerDelegate?.marker?(self.mapView, marker)
//                self.updateMarker(with: marker, isSelected: true)
//                self.moveCameraToPosition(marker.position)
//                objc_setAssociatedObject(self, &MarkerKeys.activeMarker, marker, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
//                return true
//            }
//            
//            showPMMarker(marker)
//            
//            if let activeMarker = objc_getAssociatedObject(self, &MarkerKeys.activeMarker) as? NMFMarker,
//               let activeMarkerID = activeMarker.userInfo["id"] as? String,
//               activeMarkerID == markerItem.id {
//                updateMarker(with: &marker, isSelected: true)
//                objc_setAssociatedObject(self, &MarkerKeys.activeMarker, marker, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
//                
//                if let activeInfoWindow = objc_getAssociatedObject(self, &InfoWindowKeys.activeWalkInfoWindow) as? NMFInfoWindow {
//                    activeInfoWindow.open(with: marker)
//                }
//            }
//        } catch {
//            print(error)
//        }
//    }
    
    public func deactivateMarker() {
        guard let activeMarker else { return }
        updateMarker(with: activeMarker, isSelected: false)
        objc_setAssociatedObject(self, &MarkerKeys.activeMarker, nil, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
    
    public func deselectMarkers() {
        self.markers.forEach {
            guard let marker = $0 as? NMFMarker, (marker.userInfo["isSelected"] as? Bool ?? false) else { return }
            updateMarker(with: marker, isSelected: false)
        }
    }
    
    public func hightlightMarker(with marker: NMFMarker) {
        self.deactivateMarker()
        self.updateMarker(with: marker, isSelected: true)
        self.makeCameraUpdate(marker.position, duration: 0.5, isQueueEnabled: false)
        objc_setAssociatedObject(self, &MarkerKeys.activeMarker, marker, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
    public func updateToHightlightMarker(with markerId: String) {
        guard
            let markers = markers as? [NMFMarker],
            var marker = markers.first(where: { $0.userInfo["id"] as? String == markerId })
        else { return }
        print("is Map View : \(marker.mapView)")
        self.updateMarker(with: marker, isSelected: true)
        self.makeCameraUpdate(marker.position, duration: 0.5)
        
        objc_setAssociatedObject(self, &MarkerKeys.hightlightMarker, marker, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
    
    public func updateToNormalMarker(with marker: NMFMarker) {
        var marker = marker
        self.updateMarker(with: &marker, isSelected: false)
        objc_setAssociatedObject(self, &MarkerKeys.hightlightMarker, nil, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
    
    public func selectMarker(with marker: NMFMarker) {
        self.deactivateMarker()
        self.updateMarker(with: marker, isSelected: true)
        self.makeCameraUpdate(marker.position, duration: 0.5, isQueueEnabled: false)
        objc_setAssociatedObject(self, &MarkerKeys.activeMarker, marker, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        
        self.markerDelegate?.marker?(self.mapView, marker)
    }
    
    private func updateMarker(with marker: inout NMFMarker, isSelected: Bool) {
        guard let markerItem = marker.userInfo["markerItem"] as? MarkerItem else { return }
        marker.do {
            if markerItem.transportType == .bus {
                let iconImage = self.iconImageForTransportMarker(with: .bus, isSelected: isSelected)!
                $0.iconImage = NMFOverlayImage(image: iconImage)
                $0.anchor = isSelected ? CGPoint(x: 0.5, y: 1) : CGPoint(x: 0.5, y: 0.5)
            }
            
//            if markerItem.transportType == .subway,
//               let detail = markerItem.detail as? SubwayStationDetail,
//               let subwayType = SubwayType(lineId: detail.lineID) {
//                let iconImage = self.iconImageForTransportMarker(with: .subway, color: subwayType.color)!
//                $0.iconImage = NMFOverlayImage(image: iconImage)
//            }
            
            $0.zIndex = isSelected ? 6 : 3
            $0.minZoom = isSelected ? 0 : markerItem.minLevel
            $0.width = isSelected ? 54 : 36
            $0.height = isSelected ? 64 : 43
        }
    }
    
    public func updateMarker(with marker: NMFMarker, isSelected: Bool) {
        guard let markerItem = marker.userInfo["markerItem"] as? MarkerItem else { return }
        DispatchQueue.main.async {
            marker.do {
                if markerItem.transportType == .bus {
                    let iconImage = self.iconImageForTransportMarker(with: .bus, isSelected: isSelected)!
                    $0.iconImage = NMFOverlayImage(image: iconImage)
                    $0.anchor = isSelected ? CGPoint(x: 0.5, y: 1) : CGPoint(x: 0.5, y: 0.5)
                }
                
//                if markerItem.transportType == .subway,
//                   let detail = markerItem.detail as? SubwayStationDetail,
//                   let subwayType = SubwayType(lineId: detail.lineID) {
//                    let iconImage = self.iconImageForTransportMarker(with: .subway, color: subwayType.color)!
//                    $0.iconImage = NMFOverlayImage(image: iconImage)
//                }
                $0.userInfo["isSelected"] = isSelected
                $0.zIndex = isSelected ? 6 : 3
                $0.minZoom = isSelected ? 0 : markerItem.minLevel
                $0.width = isSelected ? 54 : 36
                $0.height = isSelected ? 64 : 43
            }
        }
    }
    
    // MARK: - Show/Hide Methods
    
    public func showPMMarker(_ marker: NMFMarker) {
        pmMarkers.add(marker)
        marker.mapView = self.mapView
    }
    
    public func hideAllPMMarker() {
        pmMarkers.forEach {
            guard let pmMarker = $0 as? NMFMarker else { return }
            pmMarker.mapView = nil
        }
        self.pmMarkers.removeAllObjects()
    }
    
    // MARK: - PM Icon Construction
    
    private func pmIconImageForMarker(with serviceIconImageURL: String?) throws -> UIImage {
        guard let serviceIconImageURL, let serviceIconImageURL = URL(string: serviceIconImageURL) else { throw MarkerError.invalidURL }
        let imageSize = CGSize(width: 34, height: 41)
        let group = DispatchGroup.init()
        let queue = DispatchQueue.global()
        
        UIGraphicsBeginImageContextWithOptions(imageSize, false, 0)
        
        let context = UIGraphicsGetCurrentContext()!
        context.saveGState()
        
        let baseImage = UIImage(named: "marker_back_shadow")
        
        baseImage?.draw(at: CGPoint(x: 0, y: 0))
        
        var image: UIImage?
        
        group.enter()
        
        queue.async {
            let cacheKey = NSString(string: serviceIconImageURL.absoluteString)
            if let cachedImage = ImageCacheManager.shared.object(forKey: cacheKey) {
                image = cachedImage
                group.leave()
            } else
            if let data = try? Data(contentsOf: serviceIconImageURL),
               let icon = UIImage(data: data) {
                ImageCacheManager.shared.setObject(icon, forKey: cacheKey)
                image = icon
                group.leave()
            } else {
                image = UIImage(named: "supermove")
                group.leave()
            }
        }
        
        group.wait()
        
        let icon = image?
            .scalePreservingAspectRatio(targetSize: CGSize(width: 24, height: 24))
            .withRoundedCorners(radius: 12)
        
        icon?.draw(at: CGPoint(x: 5, y: 3))
        
        context.restoreGState()
        
        guard let newImage = UIGraphicsGetImageFromCurrentImageContext() else { throw MarkerError.failedMakeMarkerIcon }
        UIGraphicsEndImageContext()
        
        return newImage
    }
    
    private func pmIconImageForMarker(with serviceIconImageURL: URL) -> UIImage? {
        let imageSize = CGSize(width: 34, height: 41)
        let group = DispatchGroup.init()
        let queue = DispatchQueue.global()
        
        UIGraphicsBeginImageContextWithOptions(imageSize, false, 0)
        
        let context = UIGraphicsGetCurrentContext()!
        context.saveGState()
        
        let baseImage = UIImage(named: "marker_back_shadow")
        
        baseImage?.draw(at: CGPoint(x: 0, y: 0))
        
        var image: UIImage?
        
        group.enter()
        
        queue.async {
            let cacheKey = NSString(string: serviceIconImageURL.absoluteString)
            if let cachedImage = ImageCacheManager.shared.object(forKey: cacheKey) {
                image = cachedImage
                group.leave()
            } else
            if let data = try? Data(contentsOf: serviceIconImageURL),
               let icon = UIImage(data: data) {
                ImageCacheManager.shared.setObject(icon, forKey: cacheKey)
                image = icon
                group.leave()
            } else {
                image = UIImage(named: "supermove")
                group.leave()
            }
        }
        
        group.wait()
        
        let icon = image?
            .scalePreservingAspectRatio(targetSize: CGSize(width: 24, height: 24))
            .withRoundedCorners(radius: 12)
        
        icon?.draw(at: CGPoint(x: 5, y: 3))
        
        context.restoreGState()
        
        guard let newImage = UIGraphicsGetImageFromCurrentImageContext() else { return nil }
        UIGraphicsEndImageContext()
        
        return newImage
    }
}

extension Maps {
    public func makeRegionTooltip(
        title: String,
        subTitle: String? = nil,
        location: Location
    ) {
        do {
            let toolTipView = try tooltipViewForMarker(title: title, subTitle: subTitle)
            let toolTipImage = makeImageFrom(toolTipView)
            let overlayImage = NMFOverlayImage(image: toolTipImage)
            let marker = NMFMarker(position: location.toNMGLatLng(), iconImage: overlayImage)
            showRegionTooltip(marker)
        } catch { }
    }
    
    public func hideRegionTooltip() {
        guard let activeTooltip = activeRegionTooltips.firstObject as? NMFMarker else { return }
        activeTooltip.mapView = nil
        self.activeRegionTooltips.remove(activeTooltip)
    }
    
    private func showRegionTooltip(_ marker: NMFMarker) {
        activeRegionTooltips.add(marker)
        marker.mapView = self.mapView
    }
    
    private func makeImageFrom(_ desiredView: UIView) -> UIImage {
       let size = CGSize(width: desiredView.bounds.width, height: desiredView.bounds.height)
       let renderer = UIGraphicsImageRenderer(size: size)
       let image = renderer.image { (ctx) in
           desiredView.drawHierarchy(in: CGRect(origin: .zero, size: size), afterScreenUpdates: true)
       }
       return image
   }
    
    private func tooltipViewForMarker(title: String, subTitle: String? = nil) throws -> UIView {
        
        let containerView = UIView(frame: CGRect(x: 0, y: 0, width: 120, height: 40))
        let titleLabel = UILabel()
        var subTitleLabel: UILabel?
        
        containerView.layer.cornerRadius = 4
        containerView.backgroundColor = .black
        
        titleLabel.text = title
        titleLabel.font = .spoqaFont(size: 12, weight: .regular)
        titleLabel.textColor = .white
        titleLabel.textAlignment = .center
        titleLabel.sizeToFit()
        containerView.addSubview(titleLabel)
        
        if let subTitle {
            subTitleLabel = UILabel()
            subTitleLabel?.text = subTitle
            subTitleLabel?.font = .spoqaFont(size: 12, weight: .medium)
            subTitleLabel?.textColor = .white
            subTitleLabel?.textAlignment = .center
            subTitleLabel?.sizeToFit()
            containerView.addSubview(subTitleLabel!)
        }
        
        let titleLabelWidth = titleLabel.intrinsicContentSize.width
        let subTitleLabelWidth = subTitleLabel?.intrinsicContentSize.width ?? 0
        let width = titleLabelWidth > subTitleLabelWidth ? titleLabelWidth + 16 : subTitleLabelWidth + 16
        let height = (titleLabel.intrinsicContentSize.height + (subTitleLabel?.intrinsicContentSize.height ?? 0)) + 16
        
        containerView.frame.size.width = width
        containerView.frame.size.height = height
        
        titleLabel.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview().inset(8)
            if subTitle == nil {
                $0.bottom.equalToSuperview().inset(8)
            }
        }
        
        subTitleLabel?.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom)
            $0.bottom.leading.trailing.equalToSuperview().inset(8)
        }
        
        return containerView
    }
}
