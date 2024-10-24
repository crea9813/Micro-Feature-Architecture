//
//  Environment.swift
//  Environment
//
//  Created by Supermove on 6/20/24.
//

import Foundation
import ProjectDescription

public struct Environment {
    public let name: String
    public let organizationName: String
    public let platform: Platform
    public let deploymentTarget: DeploymentTargets
    public let baseSetting: SettingsDictionary
    
    static public let environment = Environment(
        name: "SM",
        organizationName: "kr.co.supermove.rush",
        platform: .iOS,
        deploymentTarget: .iOS("14.0"),
        baseSetting: .baseSetting
    )
}

public extension SettingsDictionary {
    static let baseSetting = SettingsDictionary()
        .automaticCodeSigning(devTeam: "PDVB5YP5F7")
}
