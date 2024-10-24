//
//  Config.swift
//  Packages
//
//  Created by Supermove on 6/20/24.
//

import Foundation
import ProjectDescription

let config = Config(
    plugins: [
        .local(path: .relativeToRoot("Plugins/Environment"))
    ]
)
    
