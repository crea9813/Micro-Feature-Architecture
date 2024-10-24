import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.module(
    name: Module.Foundation.DesignSystem.rawValue,
    targets: [
        .implements(
            module: .foundation(.DesignSystem),
            product: .framework,
            spec: .init(
                resources: ["Resources/**"],
                dependencies: [
                    .external(name: "Then"),
                    .external(name: "SnapKit"),
                    .foundation(target: .Extensions)
                ]
            )
        )
    ]
)
