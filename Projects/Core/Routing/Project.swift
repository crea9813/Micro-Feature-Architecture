import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.module(
    name: Module.Core.Routing.rawValue,
    targets: [
        .implements(
            module: .core(.Routing),
            dependencies: [
                .external(name: "Swinject"),
                .core(target: .Maps),
                .foundation(target: .RxPackage),
                .foundation(target: .Logger),
                .foundation(target: .PanelNavigationController)
            ]
        )
    ]
)
 
