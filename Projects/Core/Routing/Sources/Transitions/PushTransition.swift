//
//  PushTransition.swift
//  rush
//
//  Created by Supermove on 2/22/24.
//

import UIKit

public final class PushTransition: NSObject {
    public var isAnimated: Bool = true
    
    private weak var from: UIViewController?
    
    private var openCompletionHandler: (() -> Void)?
    private var closeCompletionHandler: (() -> Void)?
    
    private var navigationController: UINavigationController? {
        guard let navigation = from as? UINavigationController else { return from?.navigationController }
        return navigation
    }
    
    public init(isAnimated: Bool = true) {
        self.isAnimated = isAnimated
    }
}

extension PushTransition: Transition {
    public func open(_ viewController: UIViewController, from: UIViewController, completion: (() -> Void)?) {
        self.from = from
        openCompletionHandler = completion
        navigationController?.delegate = self
        navigationController?.pushViewController(viewController, animated: isAnimated)
    }
    
    public func close(_ viewController: UIViewController, completion: (() -> Void)?) {
        closeCompletionHandler = completion
        navigationController?.popViewController(animated: isAnimated)
    }
    
    public func close<V>(
        _ viewController: UIViewController,
        to targetController: V.Type,
        completion: (() -> Void)?
    ) where V: UIViewController {
        
        closeCompletionHandler = completion
        if let targetIndex = navigationController?.viewControllers.lastIndex(where: { $0 is V }),
           let targetController = navigationController?.viewControllers[targetIndex] {
            let popedViewController = navigationController?.popToViewController(targetController, animated: isAnimated)
//            popedViewController?.compactMap { $0.panelNavigationController }.forEach { $0.pop}
        }
        
//        if let targetIndex = navigationController.viewControllers.lastIndex(where: { $0 is V }) {
//            let targetController = navigationController.viewControllers[targetIndex]
//            let popedViewController = navigationController.popToViewController(targetController, animated: isAnimated)
//            popedViewController?
//                .compactMap { $0 as? MapPanelNavigationController }
//                .forEach { $0.popAllViewController(animated: isAnimated) }
//            
//            completion?(true)
//        } else if let targetIndex = navigationController
//            .viewControllers
//            .map { $0.panelNavigationController }
//            .firstIndex(where: { $0?.viewControllers.contains(where: { $0.contentViewController is V }) ?? false }) {
//                
//            
//            if let panel = targetController as? BaseMapPanelViewController.Type {
//                targetViewController.panelNavigationController?.popPanelController(type: panel, animated: isAnimated)
//            } else {
//                targetViewController.panelNavigationController?.popToRootPanelController(animated: isAnimated)
//            }
//            completion?(true)
//        } else {
//            completion?(false)
//            return
//        }
    }
}

extension PushTransition: UINavigationControllerDelegate {
    // MARK: - UINavigationControllerDelegate
    
    public func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        guard let transitionCoordinator = navigationController.transitionCoordinator,
              let fromVC = transitionCoordinator.viewController(forKey: .from),
              let toVC = transitionCoordinator.viewController(forKey: .to) else { return }
        
        if fromVC == from {
            openCompletionHandler?()
            openCompletionHandler = nil
        } else if toVC == from {
            closeCompletionHandler?()
            closeCompletionHandler = nil
        }
    }
}
