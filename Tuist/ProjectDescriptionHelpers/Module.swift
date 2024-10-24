//
//  Module.swift
//  Packages
//
//  Created by Supermove on 6/20/24.
//

import Foundation
import ProjectDescription

public enum Module {
    case core(Module.Core)
    case feature(Module.Feature)
    case domain(Module.Domain)
    case data(Module.Data)
    case foundation(Module.Foundation)
}

public extension Module {
    func targetName(type: MicroTarget) -> String {
        switch self {
        case let .feature(module as any MicroTargetPathConvertable),
            let .domain(module as any MicroTargetPathConvertable),
            let .data(module as any MicroTargetPathConvertable),
            let .core(module as any MicroTargetPathConvertable),
            let .foundation(module as any MicroTargetPathConvertable):
            return module.targetName(type: type)
        }
    }
}

public extension Module {
    enum App: String, CaseIterable, MicroTargetPathConvertable {
        case iOS
        
        public static let name: String = "App"
    }
}

public extension Module {
    enum Feature: String, CaseIterable, MicroTargetPathConvertable {
        case IntercityBusFeature
        case TransportFeature
        case TrainFeature
        case MapFeature
        case BusFeature
        case AirFeature
        case UserFeature
        case BaseFeature
        case MenuFeature
        case MainTabFeature
        
        public static let name: String = "Feature"
    }
}

public extension Module {
    enum Domain: String, CaseIterable, MicroTargetPathConvertable {
        case IntercityBusDomain
        case TransportDomain
        case TrainDomain
        case AirDomain
        case UserDomain
        case MapDomain
        case BaseDomain
        case BusDomain
        case SubwayDomain
        
        public static let name: String = "Domain"
    }
}

public extension Module {
    enum Data: String, CaseIterable, MicroTargetPathConvertable {
        case BaseData
        case MapData
        case BusData
        case AirData
        case UserData
        case TrainData
        case TransportData
        case IntercityBusData
        
        public static let name: String = "Data"
    }
}

public extension Module {
    enum Core: String, CaseIterable, MicroTargetPathConvertable {
        case Maps
        case SMError
        case Networking
        case Routing
        case UserStore
        case ViewModel
        
        public static let name: String = "Core"
    }
}

public extension Module {
    enum Foundation: String, CaseIterable, MicroTargetPathConvertable {
        case Logger
        case Loading
        case RxPackage
        case Extensions
        case DesignSystem
        case PanelNavigationController
        
        public static let name: String = "Foundation"
    }
}

public enum MicroTarget: String {
    case interface = "Interface"
    case sources = ""
    case testing = "Testing"
    case tests = "Tests"
    case example = "Example"
}

public protocol MicroTargetPathConvertable {
    func targetName(type: MicroTarget) -> String
}

public extension MicroTargetPathConvertable where Self: RawRepresentable {
    func targetName(type: MicroTarget) -> String {
        "\(self.rawValue)\(type.rawValue)"
    }
}
