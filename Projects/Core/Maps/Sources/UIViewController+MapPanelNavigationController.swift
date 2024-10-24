//
//  UIViewController+MapPanelNavigationController.swift
//  Maps
//
//  Created by Supermove on 10/15/24.
//  Copyright © 2024 kr.co.supermove.rush. All rights reserved.
//

import UIKit

public extension UIViewController {
    struct PanelNavigationKey {
        static var mapPanelNavigationController = "kr.co.supermove.panel.mapPanelNavigationController"
    }
    
    public var mapPanelNavigationController: MapPanelNavigationController? {
        get {
            (objc_getAssociatedObject(self, &PanelNavigationKey.mapPanelNavigationController) as? MapPanelNavigationController)
        }
        set {
            objc_setAssociatedObject(self, &PanelNavigationKey.mapPanelNavigationController, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
}
