import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.module(
    name: Module.Core.SMError.rawValue,
    targets: [
        .implements(module: .core(.SMError))
    ]
)
