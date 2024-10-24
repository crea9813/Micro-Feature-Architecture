import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.module(
    name: Module.Foundation.Extensions.rawValue,
    targets: [
        .implements(
            module: .foundation(.Extensions),
            product: .framework,
            dependencies: [
                .foundation(target: .RxPackage),
            ]
        )
    ]
)
