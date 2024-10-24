import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.module(
    name: Module.Foundation.PanelNavigationController.rawValue,
    targets: [
        .implements(
            module: .foundation(.PanelNavigationController),
            product: .framework,
            dependencies: [
                .foundation(target: .RxPackage),
                .external(name: "FloatingPanel")
            ]
        )
    ]
)
