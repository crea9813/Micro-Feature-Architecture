import Foundation
import UIKit
import Routing
import Swinject
import DesignSystem

import AirFeature
import AirDomain
import AirData

import TransportFeature
import TransportDomain
import TransportData

import UserFeature
import UserDomain
import UserData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    private let container = Container()
    lazy var assembler = Assembler(container: container)
    
    internal func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        DesignSystemFontFamily.registerAllCustomFonts()
        
        assembler.apply(
            assemblies: [
                AirFeatureAssembly(),
                AirDomainAssembly(),
                AirDataAssembly(),
                TransportFeatureAssembly(),
                TransportDomainAssembly(),
                TransportDataAssembly(),
                UserFeatureAssembly(),
                UserDomainAssembly(),
                UserDataAssembly()
            ]
        )
        
        let router = DefaultRouter(rootTransition: PushTransition(), container: container)
        let viewModel = container.resolve(AirMainViewModel.self, argument: router)!
        let rootViewController = AirMainViewController(with: viewModel)
        router.root = rootViewController
        
        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window?.rootViewController = UINavigationController(rootViewController: rootViewController)
        self.window?.makeKeyAndVisible()

        return true
    }
}
