//
//  Router.swift
//  rush
//
//  Created by Supermove on 2/22/24.
//

import UIKit
import Swinject

public protocol Closable: AnyObject {
    func close()
    
    func close(completion: (() -> Void)?)
    
    func close<V>(to viewController: V.Type) where V: UIViewController
    
    func close<V>(to viewController: V.Type, completion: (() -> Void)?) where V: UIViewController
}

public protocol Dismissable: AnyObject {
    func dismiss()
    
    func dismiss(completion: (() -> Void)?)
}

public protocol Deeplinkable: AnyObject {
    @discardableResult
    func route(to url: URL, as transition: Transition) -> Bool
}

public protocol Routable: AnyObject {
    
    func route(to viewController: UIViewController, as transition: Transition)
    
    func route(to viewController: UIViewController, as transition: Transition, completion: (() -> Void)?)
}

public protocol Router: Routable {
    
    var root: UIViewController? { get set }
    
    var container: Container { get set }
}
