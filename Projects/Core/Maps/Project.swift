import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.module(
    name: Module.Core.Maps.rawValue,
    targets: [
        .implements(
            module: .core(.Maps),
            dependencies: [
                .external(name: "Then"),
                .external(name: "SnapKit"),
                .domain(target: .MapDomain, type: .interface),
                .xcframework(path: .relativeToRoot("Tuist/LocalPackage/NMapsMap.xcframework"), status: .optional),
                .xcframework(path: .relativeToRoot("Tuist/LocalPackage/NMapsGeometry.xcframework"), status: .optional),
                .foundation(target: .RxPackage),
                .foundation(target: .Logger),
                .foundation(target: .DesignSystem),
                .foundation(target: .PanelNavigationController)
            ]
        )
    ]
)
