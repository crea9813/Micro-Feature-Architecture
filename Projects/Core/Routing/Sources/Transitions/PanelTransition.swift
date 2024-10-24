//
//  PanelTransition.swift
//  rush
//
//  Created by Supermove on 2/22/24.
//

import UIKit
import PanelNavigationController

public class PanelTransition: NSObject, Transition {
    public var isAnimated: Bool = true
    
    private weak var from: UIViewController?
    
    private var openCompletionHandler: (() -> Void)?
    private var closeCompletionHandler: (() -> Void)?
    
    private var panelNavigationController: PanelNavigationController? {
        return from?.panelNavigationController
    }
    
    public init(isAnimated: Bool = true) {
        self.isAnimated = isAnimated
    }
    
    public func open(_ viewController: UIViewController, from: UIViewController, completion: (() -> Void)?) {
        guard let viewController = viewController as? BasePanelViewController else { return }
        self.from = from
        openCompletionHandler = completion
        panelNavigationController?.pushPanelController(viewController, animated: isAnimated)
    }
    
    public func close(_ viewController: UIViewController, completion: (() -> Void)?) {
        guard let panelNavigationController = (self.panelNavigationController ?? viewController.panelNavigationController) else { return }
        closeCompletionHandler = completion
        
        panelNavigationController.popViewController(animated: isAnimated) {
            self.closeCompletionHandler?()
            self.closeCompletionHandler = nil
        }
    }
    
    public func close<V>(_ viewController: UIViewController, to targetController: V.Type, completion: (() -> Void)?) where V : UIViewController {
        guard let panelNavigationController = (self.panelNavigationController ?? viewController.panelNavigationController) else { return }
        closeCompletionHandler = completion
        
        panelNavigationController.popToPanelController(to: viewController as! BasePanelViewController, animated: isAnimated)
    }
}
