//
//  UIViewController+PanelNavigationController.swift
//  PanelNavigationController
//
//  Created by Supermove on 7/9/24.
//  Copyright © 2024 kr.co.supermove.rush. All rights reserved.
//

import UIKit

extension UIViewController {
    struct PanelNavigationKey {
        static var panelNavigationController = "kr.co.supermove.panel.panelNavigationController"
    }
    
    public var panelNavigationController: PanelNavigationController? {
        get {
            (objc_getAssociatedObject(self, &PanelNavigationKey.panelNavigationController) as? PanelNavigationController)
        }
        set {
            objc_setAssociatedObject(self, &PanelNavigationKey.panelNavigationController, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
}
