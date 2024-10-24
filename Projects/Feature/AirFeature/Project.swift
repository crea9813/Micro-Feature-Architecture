import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.module(
    name: Module.Feature.AirFeature.rawValue,
    targets: [
        .interface(
            module: .feature(.AirFeature),
            dependencies: [
                .core(target: .Routing),
                .domain(target: .BaseDomain, type: .interface),
                .domain(target: .UserDomain, type: .interface),
                .domain(target: .TransportDomain, type: .interface),
                .domain(target: .AirDomain, type: .interface),
        ]),
        .implements(
            module: .feature(.AirFeature),
            dependencies: [
                .external(name: "Kingfisher"),
                .foundation(target: .Loading),
                .foundation(target: .DesignSystem),
                .foundation(target: .Extensions),
                .foundation(target: .PanelNavigationController),
                
                .core(target: .UserStore),
                .core(target: .SMError),
                .core(target: .Routing),
                .core(target: .ViewModel),
                
                .feature(target: .BaseFeature),
                .feature(target: .TransportFeature),
                .feature(target: .UserFeature),
                .feature(target: .AirFeature, type: .interface),
            ]
        ),
        .example(
            module: .feature(.AirFeature),
            dependencies: [
                .feature(target: .AirFeature),
                
                .domain(target: .AirDomain),
                .domain(target: .UserDomain),
                .domain(target: .TransportDomain),
                
                .data(target: .AirData),
                .data(target: .UserData),
                .data(target: .TransportData),
            ]
        )
    ]
//    additionalFiles: [
//        "../../Foundation/DesignSystem/Resources/Localizable.xcstrings",
//    ]
)
