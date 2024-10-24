//
//  MapTransition.swift
//  Routing
//
//  Created by Supermove on 10/15/24.
//  Copyright © 2024 kr.co.supermove.rush. All rights reserved.
//

import UIKit
import Maps

public final class MapTransition: NSObject {
    public var isAnimated: Bool = true
    
    private weak var from: UIViewController?
    
    private var navigationController: UINavigationController? {
        guard let navigation = from as? UINavigationController else { return from?.navigationController }
        return navigation
    }
    
    private var panelNavigationController: MapPanelNavigationController? {
        guard let navigation = from as? MapPanelNavigationController else { return from?.mapPanelNavigationController }
        return navigation
    }
    
    public init(isAnimated: Bool = true) {
        self.isAnimated = isAnimated
    }
}

extension MapTransition: Transition {
    public func close<V>(_ viewController: UIViewController, to targetController: V.Type, completion: (() -> Void)?) where V : UIViewController {
        
    }
    
    public func open(_ viewController: UIViewController, from: UIViewController, completion: (() -> Void)?) {
        self.from = from
        if !(navigationController?.viewControllers.last is MapPanelNavigationController) {
            let panelNavigationController = MapPanelNavigationController(rootViewController: viewController)
            
            navigationController?.pushViewController(panelNavigationController, animated: true)
            panelNavigationController.pushViewController(viewController, animated: true)
        } else {
            panelNavigationController?.pushViewController(viewController, animated: true)
        }
        
        completion?()
    }
    
    public func close(_ viewController: UIViewController, completion: (() -> Void)?) {
        guard let panelNavigationController = viewController.mapPanelNavigationController else { return }
        panelNavigationController.popViewController(animated: isAnimated)
        completion?()
    }
}
