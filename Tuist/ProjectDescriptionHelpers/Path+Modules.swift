//
//  Path+Modules.swift
//  Packages
//
//  Created by Supermove on 6/20/24.
//

import Foundation
import ProjectDescription

// MARK: ProjectDescription.Path + App
public extension ProjectDescription.Path {
    static var app: Self {
        return .relativeToRoot("Projects/\(Module.App.name)")
    }
}

// MARK: ProjectDescription.Path + Feature
public extension ProjectDescription.Path {
    static var feature: Self {
        return .relativeToRoot("Projects/\(Module.Feature.name)")
    }
    
    static func feature(implementation module: Module.Feature) -> Self {
        return .relativeToRoot("Projects/\(Module.Feature.name)/\(module.rawValue)")
    }
}

// MARK: ProjectDescription.Path + Domain
public extension ProjectDescription.Path {
    static var domain: Self {
        return .relativeToRoot("Projects/\(Module.Domain.name)")
    }
    
    static func domain(implementation module: Module.Domain) -> Self {
        print("Projects/\(Module.Domain.name)/\(module.rawValue)")
        return .relativeToRoot("Projects/\(Module.Domain.name)/\(module.rawValue)")
    }
}

// MARK: ProjectDescription.Path + Data
public extension ProjectDescription.Path {
    static var data: Self {
        return .relativeToRoot("Projects/\(Module.Data.name)")
    }
    
    static func data(implementation module: Module.Data) -> Self {
        return .relativeToRoot("Projects/\(Module.Data.name)/\(module.rawValue)")
    }
}

// MARK: ProjectDescription.Path + Core
public extension ProjectDescription.Path {
    static var core: Self {
        return .relativeToRoot("Projects/\(Module.Core.name)")
    }
    
    static func core(implementation module: Module.Core) -> Self {
        return .relativeToRoot("Projects/\(Module.Core.name)/\(module.rawValue)")
    }
}


// MARK: ProjectDescription.Path + Foundation
public extension ProjectDescription.Path {
    static var foundation: Self {
        return .relativeToRoot("Projects/\(Module.Foundation.name)")
    }
    
    static func foundation(implementation module: Module.Foundation) -> Self {
        return .relativeToRoot("Projects/\(Module.Foundation.name)/\(module.rawValue)")
    }
}
