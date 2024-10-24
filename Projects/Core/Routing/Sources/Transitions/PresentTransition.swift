//
//  PresentTransition.swift
//  rush
//
//  Created by Supermove on 2/26/24.
//

import UIKit

public final class PresentTransition: NSObject {
    public var isAnimated: Bool = true
    
    public var modalTransitionStyle: UIModalTransitionStyle
    public var modalPresentationStyle: UIModalPresentationStyle
    
    public init(isAnimated: Bool = true,
                modalTransitionStyle: UIModalTransitionStyle = .coverVertical,
                modalPresentationStyle: UIModalPresentationStyle = .automatic) {
        self.isAnimated = isAnimated
        self.modalTransitionStyle = modalTransitionStyle
        self.modalPresentationStyle = modalPresentationStyle
    }
}

extension PresentTransition: Transition {
    public func open(_ viewController: UIViewController, from: UIViewController, completion: (() -> Void)?) {
        viewController.modalPresentationStyle = modalPresentationStyle
        viewController.modalTransitionStyle = modalTransitionStyle
        from.present(viewController, animated: isAnimated, completion: completion)
    }
    
    public func close(_ viewController: UIViewController, completion: (() -> Void)?) {
        viewController.dismiss(animated: isAnimated, completion: completion)
    }
    
    public func close<V>(_ viewController: UIViewController, to targetController: V.Type, completion: (() -> Void)?) where V : UIViewController {
        viewController.dismiss(animated: isAnimated, completion: completion)
    }
}
