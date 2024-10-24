//
//  Workspace.swift
//  Packages
//
//  Created by Supermove on 6/20/24.
//

import Foundation
import Environment
import ProjectDescription

let workspace = Workspace(
    name: Environment.environment.name,
    projects: [
        "Projects/**",
    ]
)
