//
//  Project+Module.swift
//  ProjectDescriptionHelpers
//
//  Created by Supermove on 6/20/24.
//

import Foundation
import Environment
import ProjectDescription

public extension Project {
    static func module(
        name: String,
        options: Options = .options(),
        packages: [Package] = [],
        settings: Settings = .settings(configurations: .default),
        targets: [Target],
        fileHeaderTemplate: FileHeaderTemplate? = nil,
        additionalFiles: [FileElement] = [],
        resourceSynthesizers: [ResourceSynthesizer] = .default
    ) -> Project {
        
        return Project(
            name: name,
            organizationName: Environment.environment.organizationName,
            options: options,
            packages: packages,
            settings: settings,
            targets: targets,
            schemes: targets.contains { $0.product == .app } ?
                [.makeScheme(target: .development, name: name), .makeExampleScheme(target: .development, name: name)] :
                [.makeScheme(target: .development, name: name)],
            fileHeaderTemplate: fileHeaderTemplate,
            additionalFiles: additionalFiles,
            resourceSynthesizers: resourceSynthesizers
        )
    }
}
