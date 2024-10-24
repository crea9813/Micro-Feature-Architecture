//
//  BuildTarget.swift
//  Packages
//
//  Created by Supermove on 6/20/24.
//

import Foundation
import ProjectDescription

public enum BuildTarget: String {
    case development = "Development"
    case staging = "Staging"
    case production = "Production"

    public var configurationName: ConfigurationName {
        ConfigurationName.configuration(self.rawValue)
    }
}
