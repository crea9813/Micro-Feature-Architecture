//
//  Target+Templates.swift
//  Packages
//
//  Created by Supermove on 6/20/24.
//

import Foundation
import ProjectDescription
import Environment

public struct TargetFactory {
    var name: String
    var destinations: Destinations
    var product: Product
    var productName: String?
    var bundleId: String?
    var deploymentTarget: DeploymentTargets?
    var infoPlist: InfoPlist?
    var sources: SourceFilesList?
    var resources: ResourceFileElements?
    var copyFiles: [CopyFilesAction]?
    var headers: Headers?
    var entitlements: Entitlements?
    var scripts: [TargetScript]
    var dependencies: [TargetDependency]
    var settings: Settings?
    var coreDataModels: [CoreDataModel]
    var environmentVariable: [String: EnvironmentVariable]
    var launchArguments: [LaunchArgument]
    var additionalFiles: [FileElement]
    var buildRules: [BuildRule]
    
    public init(
        name: String = "",
        destinations: Destinations = [.iPhone],
        product: Product = .staticLibrary,
        productName: String? = nil,
        bundleId: String? = nil,
        deploymentTarget: DeploymentTargets? = .iOS("14.0"),
        infoPlist: InfoPlist? = .default,
        sources: SourceFilesList? = nil,
        resources: ResourceFileElements? = nil,
        copyFiles: [CopyFilesAction]? = nil,
        headers: Headers? = nil,
        entitlements: Entitlements? = nil,
        scripts: [TargetScript] = [],
        dependencies: [TargetDependency] = [],
        settings: Settings? = .settings(base: .baseSetting, configurations: .default),
        coreDataModels: [CoreDataModel] = [],
        environmentVariable: [String: EnvironmentVariable] = [:],
        launchArguments: [LaunchArgument] = [],
        additionalFiles: [FileElement] = [],
        buildRules: [BuildRule] = []
    ) {
            self.name = name
            self.destinations = destinations
            self.product = product
            self.productName = productName
            self.deploymentTarget = deploymentTarget
            self.bundleId = bundleId
            self.infoPlist = infoPlist
            self.sources = sources
            self.resources = resources
            self.copyFiles = copyFiles
            self.headers = headers
            self.entitlements = entitlements
            self.scripts = scripts
            self.dependencies = dependencies
            self.settings = settings
            self.coreDataModels = coreDataModels
            self.environmentVariable = environmentVariable
            self.launchArguments = launchArguments
            self.additionalFiles = additionalFiles
            self.buildRules = buildRules
        }
    
    func toTarget(with name: String, product: Product? = nil) -> Target {
        Target.target(
            name: name,
            destinations: destinations,
            product: product ?? self.product,
            productName: productName,
            bundleId: bundleId ?? "\(Environment.environment.organizationName).\(name)",
            deploymentTargets: deploymentTarget,
            infoPlist: infoPlist,
            sources: sources,
            resources: resources,
            copyFiles: copyFiles,
            headers: headers,
            entitlements: entitlements,
            scripts: scripts,
            dependencies: dependencies,
            settings: settings,
            coreDataModels: coreDataModels,
            environmentVariables: environmentVariable,
            launchArguments: launchArguments,
            additionalFiles: additionalFiles,
            buildRules: buildRules
        )
    }
}

extension TargetFactory {
    public func with(_ block: (inout Self) throws -> Void) rethrows -> Self {
        var copy = self
        try block(&copy)
        return copy
    }
}

extension Target {
    public static func makeTarget(_ factory: TargetFactory) -> Self {
        return Target.target(name: factory.name, destinations: factory.destinations, product: factory.product, productName: factory.productName, bundleId: factory.bundleId ?? Environment.environment.organizationName + ".\(factory.name)", deploymentTargets: factory.deploymentTarget, infoPlist: factory.infoPlist, sources: factory.sources, resources: factory.resources, copyFiles: factory.copyFiles, headers: factory.headers, entitlements: factory.entitlements, scripts: factory.scripts, dependencies: factory.dependencies, settings: factory.settings, coreDataModels: factory.coreDataModels, environmentVariables: factory.environmentVariable, launchArguments: factory.launchArguments, additionalFiles: factory.additionalFiles)
    }
}

public extension Target {
    static func feature(factory: TargetFactory) -> Self {
        var newFactory = factory
        newFactory.name = Module.Feature.name
        
        return makeTarget(newFactory)
    }
    
    static func feature(implements module: Module.Feature, factory: TargetFactory) -> Self {
        var newFactory = factory
        newFactory.name = module.rawValue
        newFactory.sources = "Sources/**"
        
        return makeTarget(newFactory)
    }
    
    static func feature(tests module: Module.Feature, factory: TargetFactory) -> Self {
        var newFactory = factory
        newFactory.name = module.rawValue + "Tests"
        newFactory.sources = "Tests/**"
        newFactory.product = .unitTests
        
        return makeTarget(newFactory)
    }
    
    static func feature(testing module: Module.Feature, factory: TargetFactory) -> Self {
        var newFactory = factory
        newFactory.name = module.rawValue + "Testing"
        newFactory.sources = "Testing/**"
        
        return makeTarget(newFactory)
    }
    
    static func feature(interface module: Module.Feature, factory: TargetFactory) -> Self {
        var newFactory = factory
        newFactory.name = module.rawValue + "Interface"
        newFactory.sources = "Interface/**"
        
        return makeTarget(newFactory)
    }
    
    static func feature(example module: Module.Feature, factory: TargetFactory) -> Self {
        var newFactory = factory
        newFactory.name = module.rawValue + "Example"
        newFactory.sources = "Example/**"
        newFactory.product = .app
        newFactory.dependencies += [.target(name: module.rawValue)]
        newFactory.infoPlist = .extendingDefault(with: [
            "UIMainStoryboardFile": "",
            "UILaunchStoryboardName": "LaunchScreen",
            "LSSupportsOpeningDocumentsInPlace": true,
            "UIFileSharingEnabled": true,
        ])
        return makeTarget(newFactory)
    }
}


public extension Target {
    static func domain(factory: TargetFactory) -> Self {
        var newFactory = factory
        newFactory.name = Module.Domain.name
        
        return makeTarget(newFactory)
    }
    
    static func domain(implements module: Module.Domain, factory: TargetFactory) -> Self {
        var newFactory = factory
        newFactory.name = module.rawValue + Module.Domain.name
        newFactory.sources = "Sources/**"
        
        return makeTarget(newFactory)
    }
    
    static func domain(tests module: Module.Domain, factory: TargetFactory) -> Self {
        var newFactory = factory
        newFactory.name = module.rawValue + Module.Domain.name + "Tests"
        newFactory.product = .unitTests
        newFactory.sources = "Tests/**"
        
        return makeTarget(newFactory)
    }
    
    static func domain(testing module: Module.Domain, factory: TargetFactory) -> Self {
        var newFactory = factory
        newFactory.name = module.rawValue + Module.Domain.name + "Testing"
        newFactory.sources = "Testing/**"
        
        return makeTarget(newFactory)
    }
    
    static func domain(interface module: Module.Domain, factory: TargetFactory) -> Self {
        var newFactory = factory
        newFactory.name = module.rawValue + Module.Domain.name + "Interface"
        newFactory.sources = "Interface/**"
        
        return makeTarget(newFactory)
    }
}

// MARK: Target + Core
public extension Target {
    static func data(factory: TargetFactory) -> Self {
        var newFactory = factory
        newFactory.name = Module.Data.name
        
        return makeTarget(newFactory)
    }
    
    static func data(implements module: Module.Data, factory: TargetFactory) -> Self {
        var newFactory = factory
        newFactory.name = module.rawValue + Module.Data.name
        newFactory.sources = "Sources/**"
        
        return makeTarget(newFactory)
    }
    
    static func data(tests module: Module.Data, factory: TargetFactory) -> Self {
        var newFactory = factory
        newFactory.name = module.rawValue + Module.Data.name + "Tests"
        newFactory.product = .unitTests
        newFactory.sources = "Tests/**"
        
        return makeTarget(newFactory)
    }
    
    static func data(testing module: Module.Data, factory: TargetFactory) -> Self {
        var newFactory = factory
        newFactory.name = module.rawValue + Module.Data.name + "Testing"
        newFactory.sources = "Testing/**"
        
        return makeTarget(newFactory)
    }
    
    static func data(interface module: Module.Data, factory: TargetFactory) -> Self {
        var newFactory = factory
        newFactory.name = module.rawValue + Module.Data.name + "Interface"
        newFactory.sources = "Interface/**"
        
        return makeTarget(newFactory)
    }
}

// MARK: Target + Foundation
public extension Target {
    static func foundation(factory: TargetFactory) -> Self {
        var newFactory = factory
        newFactory.name = Module.Foundation.name
        
        return makeTarget(newFactory)
    }
    
    static func foundation(implements module: Module.Foundation, factory: TargetFactory) -> Self {
        var newFactory = factory
        newFactory.name = module.rawValue
        
//        if module == .DesignSystem {
//            newFactory.sources = "Sources/**"
//            newFactory.resources = ["Resources/**"]
//            newFactory.product = .staticFramework
//        }
        
        return makeTarget(newFactory)
    }
    
    static func foundation(interface module: Module.Foundation, factory: TargetFactory) -> Self {
        var newFactory = factory
        newFactory.name = module.rawValue + "Interface"
        newFactory.sources = "Interface/**"
        
        return makeTarget(newFactory)
    }
}
