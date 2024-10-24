import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.module(
    name: Module.Core.UserStore.rawValue,
    targets: [
        .implements(
            module: .core(.UserStore),
            dependencies: [
                .external(name: "SwiftyUserDefaults")
            ]
        )
    ]
)
