//
//  DefaultRouter.swift
//  rush
//
//  Created by Supermove on 2/22/24.
//

import UIKit
import OSLog
import Swinject

public class DefaultRouter: NSObject, Router, Closable, Dismissable {
    private let rootTransition: Transition
    
    weak public var root: UIViewController?
    
    public var container: Container
    
    public init(rootTransition: Transition, container: Container) {
        self.rootTransition = rootTransition
        self.container = container
    }
    
    deinit {
        let message = "🗑 Deallocating \(self) with \(String(describing: rootTransition))"
        if #available(iOS 14.0, *) {
//            Logger.ui.info("\(message)")
        } else {
            print(message)
        }
    }
    
    // MARK: - Routable
    
    public func route(to viewController: UIViewController, as transition: Transition) {
        guard let root = root else { return }
        transition.open(viewController, from: root, completion: nil)
    }
    
    public func route(to viewController: UIViewController, as transition: Transition, completion: (() -> Void)?) {
        guard let root = root else { return }
        transition.open(viewController, from: root, completion: completion)
    }
    
    // MARK: - Closable
    
    public func close() {
        close(completion: nil)
    }
    
    public func close(completion: (() -> Void)?) {
        guard let root = root else { return }
        rootTransition.close(root, completion: completion)
    }
    
    public func close<V>(to viewController: V.Type) where V : UIViewController {
        close(to: viewController, completion: nil)
    }
    
    public func close<V>(to viewController: V.Type, completion: (() -> Void)?) where V : UIViewController {
        guard let root = root else { return }
        rootTransition.close(root, to: viewController, completion: completion)
    }
    
    // MARK: - Dismissable
    
    public func dismiss() {
        dismiss(completion: nil)
    }
    
    public func dismiss(completion: (() -> Void)?) {
        root?.dismiss(animated: rootTransition.isAnimated, completion: completion)
    }
}
