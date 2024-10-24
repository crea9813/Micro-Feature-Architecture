// swift-tools-version: 5.9
import PackageDescription

#if TUIST
import ProjectDescription
import ProjectDescriptionHelpers

let packageSettings = PackageSettings(
    // Customize the product types for specific package product
    // Default is .staticFramework
    // productTypes: ["Alamofire": .framework,]
    productTypes: [
        "Gifu": .framework,
        "MarqueeLabel": .framework,
        "RealmSwift": .framework,
        "Realm": .framework,
        "Moya": .framework,
        "RxMoya": .framework,
        "RxSwift": .framework,
        "RxCocoa": .framework,
        "RxCocoaRuntime": .framework,
        "RxRelay": .framework,
        "RxGesture": .framework,
        "RxDataSources": .framework,
        "Differentiator": .framework,
        "Kingfisher": .framework,
        "Then": .framework,
        "TAKUUID": .framework,
        "SnapKit": .framework,
        "Swinject": .framework,
        "FloatingPanel": .framework,
        "Toast": .framework,
        "SwiftyUserDefaults": .framework,
        "SkeletonView": .framework,
    ],
    baseSettings: .settings(configurations: .default)
)
#endif

let package = Package(
    name: "SM_Package",
    dependencies: [
        // Add your own dependencies here:
        // .package(url: "https://github.com/Alamofire/Alamofire", from: "5.0.0"),
        // You can read more about dependencies here: https://docs.tuist.io/documentation/tuist/dependencies
        .package(url: "https://github.com/kaishin/Gifu", from: "3.2.2"),
        .package(url: "https://github.com/cbpowell/MarqueeLabel", from: "4.5.0"),
        .package(url: "https://github.com/realm/realm-swift", exact: "10.52.3"),
        .package(url: "https://github.com/onevcat/Kingfisher", exact: "7.12.0"),
        .package(url: "https://github.com/Moya/Moya", from: "15.0.3"),
        .package(url: "https://github.com/ReactiveX/RxSwift", exact: "6.5.0"),
        .package(url: "https://github.com/RxSwiftCommunity/RxDataSources", from: "5.0.2"),
        .package(url: "https://github.com/devxoul/Then", from: "2.0.0"),
        .package(url: "https://github.com/taka0125/TAKUUID", from: "1.6.0"),
        .package(url: "https://github.com/SnapKit/SnapKit", from: "5.6.0"),
        .package(url: "https://github.com/Swinject/Swinject", from: "2.8.3"),
        .package(url: "https://github.com/scenee/FloatingPanel", from: "2.8.1"),
        .package(url: "https://github.com/scalessec/Toast-Swift", from: "5.1.0"),
        .package(url: "https://github.com/RxSwiftCommunity/RxGesture", from: "4.0.4"),
        .package(url: "https://github.com/sunshinejr/SwiftyUserDefaults", from: "5.3.0"),
        .package(url: "https://github.com/Juanpe/SkeletonView", from: "1.31.0"),
    ]
)

