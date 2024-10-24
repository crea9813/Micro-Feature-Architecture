//
//  Configuration.swift
//  Packages
//
//  Created by Supermove on 6/20/24.
//

import Foundation
import ProjectDescription

public extension ConfigurationName {
    static var development: ConfigurationName { configuration(BuildTarget.development.rawValue) }
    static var staging: ConfigurationName { configuration(BuildTarget.staging.rawValue) }
    static var production: ConfigurationName { configuration(BuildTarget.production.rawValue) }
}

public extension Array where Element == Configuration {
    static let `default`: [Configuration] = [
        .debug(name: .development, xcconfig: .relativeToXCConfig(type: .development, name: "Development")),
        .debug(name: .staging, xcconfig: .relativeToXCConfig(type: .staging, name: "Staging")),
        .release(name: .production, xcconfig: .relativeToXCConfig(type: .production, name: "Production")),
    ]
}
