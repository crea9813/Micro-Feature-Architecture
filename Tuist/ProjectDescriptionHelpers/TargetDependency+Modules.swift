//
//  TargetDependency+Modules.swift
//  ProjectDescriptionHelpers
//
//  Created by Supermove on 6/21/24.
//

import Foundation
import ProjectDescription

public extension TargetDependency {
    static func feature(
        target: Module.Feature,
        type: MicroTarget = .sources
    ) -> TargetDependency {
        .project(
            target: target.targetName(type: type),
            path: .feature(implementation: target)
        )
    }

    static func domain(
        target: Module.Domain,
        type: MicroTarget = .sources
    ) -> TargetDependency {
        .project(
            target: target.targetName(type: type),
            path: .domain(implementation: target)
        )
    }

    static func data(
        target: Module.Data,
        type: MicroTarget = .sources
    ) -> TargetDependency {
        .project(
            target: target.targetName(type: type),
            path: .data(implementation: target)
        )
    }

    static func core(
        target: Module.Core,
        type: MicroTarget = .sources
    ) -> TargetDependency {
        .project(
            target: target.targetName(type: type),
            path: .core(implementation: target)
        )
    }
    
    static func foundation(
        target: Module.Foundation,
        type: MicroTarget = .sources
    ) -> TargetDependency {
        .project(
            target: target.targetName(type: type),
            path: .foundation(implementation: target)
        )
    }
}
