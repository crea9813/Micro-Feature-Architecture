import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.module(
    name: Module.Domain.AirDomain.rawValue,
    targets: [
        .interface(
            module: .domain(.AirDomain),
            dependencies: [
                .domain(target: .MapDomain, type: .interface),
                .domain(target: .BaseDomain, type: .interface),
                .domain(target: .UserDomain, type: .interface),
                .domain(target: .TransportDomain, type: .interface),
            ]
        ),
        .implements(
            module: .domain(.AirDomain),
            dependencies: [
                .domain(target: .BaseDomain),
                .domain(target: .MapDomain, type: .interface),
                .domain(target: .AirDomain, type: .interface),
                .domain(target: .TransportDomain, type: .interface),
            ]
        )
    ]
)
