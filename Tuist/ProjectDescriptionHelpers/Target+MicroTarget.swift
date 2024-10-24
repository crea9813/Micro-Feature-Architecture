//
//  Target+MicroTarget.swift
//  Packages
//
//  Created by Supermove on 6/20/24.
//

import Foundation
import ProjectDescription

public extension SourceFilesList {
    static let example: SourceFilesList = "Example/Sources/**"
    static let interface: SourceFilesList = "Interface/**"
    static let sources: SourceFilesList = "Sources/**"
    static let testing: SourceFilesList = "Testing/**"
    static let unitTests: SourceFilesList = "Tests/**"
}

// MARK: - Interface
public extension Target {
    static func interface(module: Module, spec: TargetFactory) -> Target {
        spec.with {
            $0.sources = .interface
        }
        .toTarget(with: module.targetName(type: .interface), product: .framework)
    }

    static func interface(module: Module, dependencies: [TargetDependency] = []) -> Target {
        TargetFactory(sources: .interface, dependencies: dependencies)
            .toTarget(with: module.targetName(type: .interface), product: .framework)
    }

    static func interface(name: String, spec: TargetFactory) -> Target {
        spec.with {
            $0.sources = .interface
        }
        .toTarget(with: "\(name)Interface", product: .framework)
    }

    static func interface(name: String, dependencies: [TargetDependency] = []) -> Target {
        TargetFactory(sources: .interface, dependencies: dependencies)
            .toTarget(with: "\(name)Interface", product: .framework)
    }
}

// MARK: - Implements
public extension Target {
    static func implements(
        module: Module,
        product: Product = .staticLibrary,
        spec: TargetFactory
    ) -> Target {
        spec.with {
            $0.sources = .sources
        }
        .toTarget(with: module.targetName(type: .sources), product: product)
    }

    static func implements(
        module: Module,
        product: Product = .staticLibrary,
        dependencies: [TargetDependency] = []
    ) -> Target {
        TargetFactory(sources: .sources, dependencies: dependencies)
            .toTarget(with: module.targetName(type: .sources), product: product)
    }

    static func implements(
        name: String,
        product: Product = .staticLibrary,
        spec: TargetFactory
    ) -> Target {
        spec.with {
            $0.sources = .sources
        }
        .toTarget(with: name, product: product)
    }

    static func implements(
        name: String,
        product: Product = .staticLibrary,
        dependencies: [TargetDependency] = []
    ) -> Target {
        TargetFactory(sources: .sources, dependencies: dependencies)
            .toTarget(with: name, product: product)
    }
}

// MARK: - Testing
public extension Target {
    static func testing(module: Module, spec: TargetFactory) -> Target {
        spec.with {
            $0.sources = .testing
        }
        .toTarget(with: module.targetName(type: .testing), product: .framework)
    }

    static func testing(module: Module, dependencies: [TargetDependency] = []) -> Target {
        TargetFactory(sources: .testing, dependencies: dependencies)
            .toTarget(with: module.targetName(type: .testing), product: .framework)
    }

    static func testing(name: String, spec: TargetFactory) -> Target {
        spec.with {
            $0.sources = .testing
        }
        .toTarget(with: "\(name)Testing", product: .framework)
    }

    static func testing(name: String, dependencies: [TargetDependency] = []) -> Target {
        TargetFactory(sources: .testing, dependencies: dependencies)
            .toTarget(with: "\(name)Testing", product: .framework)
    }
}

// MARK: - Tests
public extension Target {
    static func tests(module: Module, spec: TargetFactory) -> Target {
        spec.with {
            $0.sources = .unitTests
        }
        .toTarget(with: module.targetName(type: .tests), product: .unitTests)
    }

    static func tests(module: Module, dependencies: [TargetDependency] = []) -> Target {
        TargetFactory(sources: .unitTests, dependencies: dependencies)
            .toTarget(with: module.targetName(type: .tests), product: .unitTests)
    }

    static func tests(name: String, spec: TargetFactory) -> Target {
        spec.with {
            $0.sources = .unitTests
        }
        .toTarget(with: "\(name)Tests", product: .unitTests)
    }

    static func tests(name: String, dependencies: [TargetDependency] = []) -> Target {
        TargetFactory(sources: .unitTests, dependencies: dependencies)
            .toTarget(with: "\(name)Tests", product: .unitTests)
    }
}

// MARK: - example
public extension Target {
    static func example(module: Module, spec: TargetFactory) -> Target {
        spec.with {
            $0.sources = .example
            $0.settings = .settings(
                base: (spec.settings?.base ?? [:])
                    .merging(["OTHER_LDFLAGS": "$(inherited) -Xlinker -interposable",
                              "CODE_SIGN_STYLE": "Automatic",
                              "DEVELOPMENT_TEAM": "PDVB5YP5F7"]),
                configurations: .default,
                defaultSettings: spec.settings?.defaultSettings ?? .recommended
            )
            $0.dependencies = spec.dependencies
            $0.infoPlist = spec.infoPlist ?? .extendingDefault(with: [
                "UIMainStoryboardFile": "",
                "UILaunchStoryboardName": "LaunchScreen",
                "ENABLE_TESTS": .boolean(true),
            ])
        }
        .toTarget(with: module.targetName(type: .example), product: .app)
    }

    static func example(module: Module, dependencies: [TargetDependency] = []) -> Target {
        TargetFactory(
            infoPlist: .extendingDefault(with: [
                "UIMainStoryboardFile": "",
                "UILaunchStoryboardName": "LaunchScreen",
                "ENABLE_TESTS": .boolean(true),
                "API_URL": "$(BASE_URL)"
            ]),
            sources: .example,
            dependencies: dependencies,
            settings: .settings(
                base: ["OTHER_LDFLAGS": "$(inherited) -Xlinker -interposable",
                       "CODE_SIGN_STYLE": "Automatic",
                       "DEVELOPMENT_TEAM": "PDVB5YP5F7"],
                configurations: .default
            )
        )
        .toTarget(with: module.targetName(type: .example), product: .app)
    }

    static func example(name: String, spec: TargetFactory) -> Target {
        spec.with {
            $0.sources = .example
            $0.settings = .settings(
                base: (spec.settings?.base ?? [:])
                    .merging(["OTHER_LDFLAGS": "$(inherited) -Xlinker -interposable",
                              "CODE_SIGN_STYLE": "Automatic",
                              "DEVELOPMENT_TEAM": "PDVB5YP5F7"]),
                configurations: .default,
                defaultSettings: spec.settings?.defaultSettings ?? .recommended
            )
            $0.dependencies = spec.dependencies
            $0.infoPlist = spec.infoPlist ?? .extendingDefault(with: [
                "UIMainStoryboardFile": "",
                "UILaunchStoryboardName": "LaunchScreen",
                "ENABLE_TESTS": .boolean(true),
            ])
        }
        .toTarget(with: "\(name)example", product: .app)
    }

    static func example(name: String, dependencies: [TargetDependency] = []) -> Target {
        TargetFactory(
            infoPlist: .extendingDefault(with: [
                "UIMainStoryboardFile": "",
                "UILaunchStoryboardName": "LaunchScreen",
                "ENABLE_TESTS": .boolean(true),
            ]),
            sources: .example,
            dependencies: dependencies,
            settings: .settings(
                base: ["OTHER_LDFLAGS": "$(inherited) -Xlinker -interposable"],
                configurations: .default
            )
        )
        .toTarget(with: "\(name)example", product: .app)
    }
}

