//
//  Location+Extension.swift
//  Maps
//
//  Created by Supermove on 9/11/24.
//  Copyright © 2024 kr.co.supermove.rush. All rights reserved.
//

import NMapsMap
import MapDomainInterface

extension Location {
    public func toNMGLatLng() -> NMGLatLng {
        return .init(lat: latitude, lng: longitude)
    }
}
