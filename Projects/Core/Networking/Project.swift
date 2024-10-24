import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.module(
    name: Module.Core.Networking.rawValue,
    targets: [ .implements(
        module: .core(.Networking),
        dependencies: [
            .external(name: "RxMoya"),
            .external(name: "TAKUUID"),
            .foundation(target: .Logger),
            .foundation(target: .Extensions),
            .core(target: .SMError),
            .core(target: .UserStore)
        ]
    )]
)
