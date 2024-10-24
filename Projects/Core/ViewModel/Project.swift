import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.module(
    name: Module.Core.ViewModel.rawValue,
    targets: [
        .implements(
            module: .core(.ViewModel),
            dependencies: [
                .foundation(target: .RxPackage),
                .foundation(target: .Logger),
                .foundation(target: .Extensions)
            ]
        )
    ]
)
