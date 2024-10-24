import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.module(
    name: Module.Foundation.RxPackage.rawValue,
    targets: [
        .implements(
            module: .foundation(.RxPackage),
            product: .framework,
            dependencies: [
                .external(name: "RxSwift"),
                .external(name: "RxCocoa"),
                .external(name: "RxRelay"),
                .external(name: "RxGesture"),
                .external(name: "RxDataSources"),
                .external(name: "Differentiator")
            ]
        )
    ]
)
