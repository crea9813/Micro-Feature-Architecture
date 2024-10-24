//
//  DeeplinkRouter.swift
//  rush
//
//  Created by Supermove on 2/28/24.
//

import Foundation
import UIKit

public class DeeplinkRouter: DefaultRouter {}

//extension DeeplinkRouter: Deeplinkable {
//    @discardableResult
//    public func route(to url: URL, as transition: Transition) -> Bool {
//        guard let route = DeeplinkRoutes(url: url) else { return false }
//        let queryItems = queryItems(url: url)
//        
//        switch route {
//        case .airUsageDetail:
//            guard let tripID = queryItems.first?.value else { return false }
//            openAirUsageDetail(with: tripID)
//        case .pmUsageDetail: return false
//        case .trainTicket: return false
//        case .coupons: openCoupons()
//        }
//        
//        return true
//    }
//    
//    private func queryItems(url: URL) -> [URLQueryItem] {
//        guard let components = URLComponents(string: url.absoluteString) else { return [] }
//        return components.queryItems ?? []
//    }
//}

enum DeeplinkRoutes: String {
    case airMain = "air_main"
    case airUsageDetail = "air_trip"
    
    case pmMain = "pm_main"
    case pmUsageDetail = "pm_trip"
    
    case trainMain = "train_main"
    case trainTicket = "train_ticket"
    
    case busMain = "bus_main"
    case busTicket = "bus_ticket"
    
    case pass = "mypass"
    case coupons = "coupon_list"
    
    case direction = "route_search"
    
    case stepCounter = "pedometer"
    case ecoPoint = "ecopoint"
    case point = "point"
    case event = "event"
    case notice = "notice"
    
    case externalWeb = "externalWeb"
    case internalWeb = "internalWeb"
    
    case kakaoRentCar = "kakaoRentCar"
    case kakaoT = "kakaot"
    
    init?(url: URL) {
        // 'supermove://air_trip?tripId=T0000000710' URL을 'airUsageDetail' 로 변환
        guard
            url.scheme == "supermove",
            let host = url.host,
            let routes = DeeplinkRoutes(rawValue: host)
        else {
            UIApplication.shared.open(url)
            return nil
        }
        self = routes
    }
}
