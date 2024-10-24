import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.module(
    name: Module.Foundation.Logger.rawValue,
    targets: [
        .implements(
            module: .foundation(.Logger),
            product: .framework,
            dependencies: []
        )
    ]
)
