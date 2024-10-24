import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.module(
    name: Module.Foundation.Loading.rawValue,
    targets: [
        .implements(
            module: .foundation(.Loading),
            product: .framework,
            dependencies: [
                .external(name: "Gifu"),
                .external(name: "Then"),
                .external(name: "SnapKit"),
                .foundation(target: .DesignSystem),
            ]
        )
    ]
)
