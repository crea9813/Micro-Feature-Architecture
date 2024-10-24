import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.module(
    name: Module.Data.AirData.rawValue,
    targets: [
        .interface(
            module: .data(.AirData),
            dependencies: [
                .data(target: .BaseData, type: .interface),
                .data(target: .UserData, type: .interface),
                .data(target: .TransportData, type: .interface),
                .domain(target: .UserDomain, type: .interface),
                .domain(target: .TransportDomain, type: .interface),
                .domain(target: .AirDomain, type: .interface),
            ]
        ),
        .implements(
            module: .data(.AirData),
            dependencies: [
                .data(target: .BaseData),
                .data(target: .AirData, type: .interface),
                .data(target: .TransportData, type: .interface),
                .domain(target: .TransportDomain, type: .interface),
                .domain(target: .AirDomain, type: .interface),
            ]
        )
    ]
)
