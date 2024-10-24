//
//  Path+XCConfig.swift
//  Packages
//
//  Created by Supermove on 6/20/24.
//

import Foundation
import ProjectDescription

public extension ProjectDescription.Path {
    static func relativeToXCConfig(type: BuildTarget, name: String) -> Self {
        return .relativeToRoot("Configuration/\(type.rawValue).xcconfig")
    }
    
    static var shared: Self {
        return .relativeToRoot("Configuration/Shared.xcconfig")
    }
}
