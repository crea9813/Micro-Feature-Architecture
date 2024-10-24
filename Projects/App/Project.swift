import ProjectDescription

let project = Project(
    name: "SM",
    targets: [
        .target(
            name: "SM",
            destinations: .iOS,
            product: .app,
            bundleId: "io.tuist.SM",
            infoPlist: .extendingDefault(
                with: [
                    "UILaunchScreen": [
                        "UIColorName": "",
                        "UIImageName": "",
                    ],
                ]
            ),
            sources: ["Sources/**"],
            resources: ["Resources/**"],
            dependencies: [
            ]
        ),
        .target(
            name: "SMTests",
            destinations: .iOS,
            product: .unitTests,
            bundleId: "io.tuist.SMTests",
            infoPlist: .default,
            sources: ["Tests/**"],
            resources: [],
            dependencies: [.target(name: "SM")]
        ),
    ]
)

