//
//  Maps+Path.swift
//  Maps
//
//  Created by Supermove on 10/16/24.
//  Copyright © 2024 kr.co.supermove.rush. All rights reserved.
//

import Foundation
import Then
import NMapsMap
import Extensions
import DesignSystem
import MapDomainInterface

extension Maps {
    internal struct PathKeys {
        static var activeWalkPath = "kr.co.supermove.path.activeWalkPath"
        static var activePath = "kr.co.supermove.path.activePath"
        static var activePathBounds = "kr.co.supermove.path.activePathBounds"
    }
}

extension Maps {
    public func makeCameraUpdateActivePath(
        paddingInset: UIEdgeInsets = UIEdgeInsets(top: 50, left: 30, bottom: 50, right: 30),
        animation: NMFCameraUpdateAnimation = .fly,
        duration: TimeInterval = 1,
        isQueueEnabled: Bool = true,
        completion: ((_ didCameraUpdateFinish: Bool) -> Void)? = nil
    ) {
        guard let bounds = objc_getAssociatedObject(self, &PathKeys.activePathBounds) as? NMGLatLngBounds else { return }
        self.makeCameraUpdate(
            bounds,
            paddingInset: paddingInset,
            animation: animation,
            duration: duration,
            isQueueEnabled: isQueueEnabled,
            completion: completion
        )
    }
}

extension Maps {
    public func makeMultipartPath(
        with paths: [Path],
        pathIds: String? = nil,
        width: CGFloat = 8,
        outlineWidth: CGFloat = 0.5,
        colors: [UIColor] = [.black],
        outlineColors: [UIColor] = [.clear],
        patternIcon: UIImage = DesignSystemAsset.arrowUpMap.image,
        patternInterval: CGFloat = 15,
        completion: ((NMGLatLngBounds) -> Void)? = nil
    ) {
        let paths = paths
            .reversed()
            .compactMap(self.pathForRoute(with:))
            .enumerated()
            .map { index, passedPath in
                let passedPath = passedPath
                passedPath.color = colors.reversed()[safe: paths.count - index - 1] ?? UIColor(red: 0.729, green: 0.745, blue: 0.812, alpha: 1)
                passedPath.outlineColor = outlineColors.reversed()[safe: paths.count - index - 1] ?? UIColor(red: 0.443, green: 0.452, blue: 0.538, alpha: 1)
                return passedPath
            }
        
        guard let multipartPath = pathsToMultipartPath(with: paths) else { return }
        let patternIcon = NMFOverlayImage(image: patternIcon)
        multipartPath.width = width
        multipartPath.outlineWidth = outlineWidth
        multipartPath.patternIcon = patternIcon
        multipartPath.patternInterval = UInt(patternInterval)
        multipartPath.userInfo["id"] = pathIds
        drawPath(with: multipartPath)
        
        let bounds = self.bounds(with: multipartPath)
        objc_setAssociatedObject(self, &PathKeys.activePathBounds, bounds, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        completion?(bounds)
    }
    
    public func makePath(
        with route: Path,
        pathId: String? = nil,
        width: CGFloat = 8,
        outlineWidth: CGFloat = 0.5,
        color: UIColor = .black,
        outlineColor: UIColor = .clear,
        patternIcon: UIImage = DesignSystemAsset.arrowUpMap.image,
        patternInterval: CGFloat = 15,
        completion: ((NMGLatLngBounds?) -> Void)? = nil
    ) {
        guard let path = self.pathForRoute(with: route) else { return }
        
        let patternIcon = NMFOverlayImage(image: patternIcon)
        path.width = width
        path.outlineWidth = outlineWidth
        path.color = color
        path.outlineColor = outlineColor
        path.patternIcon = patternIcon
        path.patternInterval = 9
        path.globalZIndex = 99
        
        drawPath(with: path)
        
        let bounds = self.bounds(with: path)
        objc_setAssociatedObject(self, &PathKeys.activePathBounds, bounds, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        completion?(bounds)
    }
    
    internal func pathForRoute(with path: Path) -> NMFPath? {
        let features = path.features
        if features.count != 0 {
            var array: [NMGLatLng] = []
            
            for feature in features {
                let coordinates = feature.geometry.coordinates
                var lng : Double?
                
                for coord in 0..<coordinates.count {
                    switch coordinates[coord] {
                    case .double(let position):
                        if coord == 0 {
                            lng = position
                        } else {
                            let latlng = NMGLatLng(lat: position, lng: lng!)
                            array.append(latlng)
                        }
                    case .doubleArray(let point):
                        let latlng = NMGLatLng(lat: point[1], lng: point[0])
                        array.append(latlng)
                    case .multiPolygon(_), .doublePolygon(_):
                        break;
                    }
                }
//                if feature.geometry.coordType == "wcongnamul" {
//                    let coordinates = feature.geometry.coordinates
//                    var y : Double = 0
//                    
//                    for coord in 0..<coordinates.count {
//                        switch coordinates[coord] {
//                        case .double(let position):
//                            if coord == 0 {
//                                y = position
//                            } else {
//                                let point = MTMapPoint.init(wcong: MTMapPointPlain(x: position, y: y)).mapPointGeo()
//                                let latlng = NMGLatLng(lat: point.latitude, lng: point.longitude)
//                                array.append(latlng)
//                            }
//                        case .doubleArray(let point):
//                            let point = MTMapPoint.init(wcong: MTMapPointPlain(x: point[0], y: point[1])).mapPointGeo()
//                            
//                            let latlng = NMGLatLng(lat: point.latitude, lng: point.longitude)
//                            array.append(latlng)
//                        case .multiPolygon(_), .doublePolygon(_):
//                            break;
//                        }
//                    }
//                } else {
//                    
//                }
            }
            
            var pathOverlay = NMFPath()
            
            if !array.isEmpty {
                pathOverlay = NMFPath(points: array)!
            }
            
            return pathOverlay
        } else { return nil }
    }
    
    internal func pathsToMultipartPath(with paths: [NMFPath]) -> NMFMultipartPath? {
        var multipartPath = NMFMultipartPath()
        multipartPath.lineParts = paths.map { $0.path }
        multipartPath.colorParts = paths.map { NMFPathColor(color: $0.color, outlineColor: $0.outlineColor)}
        return multipartPath
    }
    
    public func removePath() {
        guard let activePath = objc_getAssociatedObject(self, &PathKeys.activePath) as? NMFOverlay else { return }
        DispatchQueue.main.async {
            activePath.mapView = nil
        }
        objc_setAssociatedObject(self, &PathKeys.activePath, nil, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
    
    internal func drawPath(with path: NMFOverlay) {
        DispatchQueue.main.async {
            path.mapView = self.mapView
        }
        objc_setAssociatedObject(self, &PathKeys.activePath, path, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
}


// MARK: Bounds Methods
extension Maps {
    internal func bounds(with path: NMFMultipartPath) -> NMGLatLngBounds {
        let points = Array(path.lineParts.compactMap { $0.points as? [NMGLatLng] }.joined())
        var minLat: Double = 90.0
        var maxLat: Double = -90.0
        var minLng: Double = 180.0
        var maxLng: Double = -180.0
        
        let latitudes = points.sorted(by: { $0.lat > $1.lat })
        let longitudes = points.sorted(by: { $0.lng > $1.lng })
        
        minLat = latitudes.last?.lat ?? 90.0
        maxLat = latitudes.first?.lat ?? -90.0
        minLng = longitudes.last?.lng ?? 180.0
        maxLng = longitudes.first?.lng ?? -180.0
        
        return NMGLatLngBounds(southWestLat: minLat, southWestLng: minLng, northEastLat: maxLat, northEastLng: maxLng)
    }
    
    internal func bounds(with path: NMFPath) -> NMGLatLngBounds? {
        guard let points = path.path.points as? [NMGLatLng] else { return nil }
        var minLat: Double = 90.0
        var maxLat: Double = -90.0
        var minLng: Double = 180.0
        var maxLng: Double = -180.0
        
        let latitudes = points.sorted(by: { $0.lat > $1.lat })
        let longitudes = points.sorted(by: { $0.lng > $1.lng })
        
        minLat = latitudes.last?.lat ?? 90.0
        maxLat = latitudes.first?.lat ?? -90.0
        minLng = longitudes.last?.lng ?? 180.0
        maxLng = longitudes.first?.lng ?? -180.0
        
        return NMGLatLngBounds(southWestLat: minLat, southWestLng: minLng, northEastLat: maxLat, northEastLng: maxLng)
    }

}

//public func makeBusPath(with routePath: BusRoutePath, busRoute: BusRoute, completion: ((NMGLatLngBounds) -> Void)? = nil) {
//    if let activePath = objc_getAssociatedObject(self, &PathKeys.activePath) as? NMFOverlay,
//       activePath.userInfo["busRouteId"] as? String == routePath.busRouteId { return }
//    
//    guard let path = self.pathForRoute(with: routePath.path),
//          let busType = BusType(rawValue: busRoute.routeType) else { return }
//    let patternIcon = NMFOverlayImage(name: "ic_route_arrow")
//    
//    path.color = busType.color
//    path.outlineColor = .black
//    
//    var passedPaths = routePath.passedPath
//        .compactMap(self.pathForRoute(with:))
//        .map { passedPath in
//            var passedPath = passedPath
//            passedPath.color = UIColor(red: 0.729, green: 0.745, blue: 0.812, alpha: 1)
//            passedPath.outlineColor = UIColor(red: 0.443, green: 0.452, blue: 0.538, alpha: 1)
//            return passedPath
//        }
//    
//    passedPaths.append(path)
//    
//    guard let multipartPath = pathsToMultipartPath(with: passedPaths) else { return }
//    multipartPath.width = 12
//    multipartPath.outlineWidth = 0.5
//    multipartPath.patternIcon = patternIcon
//    multipartPath.patternInterval = 15
//    multipartPath.globalZIndex = 1
//    multipartPath.userInfo["busRouteId"] = routePath.busRouteId
//    drawPath(with: multipartPath)
//    
//    let bounds = bounds(with: multipartPath)
//    self.busPathBounds = bounds
//    completion?(bounds)
//}
