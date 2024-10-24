//
//  MapPanelNavigationController.swift
//  Maps
//
//  Created by Supermove on 10/15/24.
//  Copyright © 2024 kr.co.supermove.rush. All rights reserved.
//

import Foundation
import UIKit
import Logger
import FloatingPanel
import DesignSystem

open class MapPanelNavigationController: UIViewController {
//    weak var rootViewController: UIViewController!
    open var topViewController: UIViewController? { viewControllers.last }
    open var viewControllers: [UIViewController] = []
    
    open var topFloatingPanelController: FloatingPanelController? { floatingPanelControllers.last }
    open var floatingPanelControllers: [FloatingPanelController] = []
    
    internal let mapManager: Maps!
    private let appearance = SurfaceAppearance()
    
    public init(rootViewController: UIViewController!) {
        self.mapManager = Maps()
        super.init(nibName: nil, bundle: nil)
        self.hidesBottomBarWhenPushed = true
        self.appearance.backgroundColor = .white
        self.appearance.cornerRadius = 16
        rootViewController.mapPanelNavigationController = self
    }
    
    open override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    deinit {
        SMLogger.log(category: .ui, level: .fault, message: "DEINIT : \(String(describing: self))")
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open override func viewDidLoad() {
        super.viewDidLoad()
//        let backButtonItem = UIButton(frame: CGRect(x: 0, y: 0, width: 44, height: 44))
//        backButtonItem.setImage(DesignSystemAsset.arrowLeftCircleBlack.image, for: .normal)
//        backButtonItem.contentMode = .scaleAspectFit
//        navigationItem.backBarButtonItem = UIBarButtonItem(customView: backButtonItem)
        self.view.addSubview(self.mapManager.mapView)
        self.mapManager.mapView.frame = view.frame
    }
    
    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
}

extension MapPanelNavigationController {
    public func pushViewController(_ viewController: UIViewController, animated: Bool) {
        if let topViewController,
           let floatingPanelController = topFloatingPanelController {
            floatingPanelController.hide(animated: animated) {
                topViewController.panelNavigationController = nil
                topViewController.mapPanelNavigationController = nil
                floatingPanelController.willMove(toParent: nil)
                floatingPanelController.view.removeFromSuperview()
                floatingPanelController.removeFromParent()
            }
        }
        
        let floatingPanelController = FloatingPanelController()
        viewController.mapPanelNavigationController = self
//        viewController.floatingPanelController = floatingPanelController
        
        if let panelViewController = viewController as? MapPanelViewController {
            panelViewController.maps = self.mapManager
            floatingPanelController.delegate = panelViewController.delegate
            floatingPanelController.layout = panelViewController.layout
            floatingPanelController.surfaceView.appearance = appearance
            floatingPanelController.surfaceView.grabberHandle.isHidden = !panelViewController.isSwipeEnabled
        }
        floatingPanelController.set(contentViewController: viewController)
        floatingPanelController.addPanel(toParent: self, animated: animated)
        self.viewControllers.append(viewController)
        self.floatingPanelControllers.append(floatingPanelController)
    }
    
    @discardableResult
    public func popViewController(animated: Bool, isPushing: Bool = false,  completion: ((()) -> Void)? = nil) -> UIViewController? {
        if let topViewController = self.viewControllers.popLast(),
           let floatingPanelController = self.floatingPanelControllers.popLast() {
            floatingPanelController.hide(animated: animated) {
//                topViewController.floatingPanelController = nil
                topViewController.mapPanelNavigationController = nil
                topViewController.removeFromParent()
                floatingPanelController.willMove(toParent: nil)
                floatingPanelController.view.removeFromSuperview()
                floatingPanelController.removeFromParent()
            }
            
            if let lastViewController = self.topViewController,
               let floatingPanelController = self.topFloatingPanelController {
                lastViewController.mapPanelNavigationController = self
//                lastViewController.floatingPanelController = floatingPanelController
                
                if let panelViewController = lastViewController as? MapPanelViewController {
                    floatingPanelController.delegate = panelViewController.delegate
                    floatingPanelController.layout = panelViewController.layout
                    floatingPanelController.surfaceView.grabberHandle.isHidden = !panelViewController.isSwipeEnabled
                }

                floatingPanelController.set(contentViewController: lastViewController)
                floatingPanelController.addPanel(toParent: self, animated: animated)
            } else {
                guard !isPushing else { return topViewController }
                self.navigationController?.popViewController(animated: animated)
            }
            return topViewController
        }
        return nil
    }
    
    @discardableResult
    public func popAllViewController(animated: Bool) -> [UIViewController?] {
        var popedViewControllers: [UIViewController?] = []
        for _ in 0 ..< viewControllers.count {
            popedViewControllers.append(popViewController(animated: animated))
        }
        return popedViewControllers
    }
}
