//
//  Transition.swift
//  rush
//
//  Created by Supermove on 2/22/24.
//

import UIKit

public protocol Transition: AnyObject {
    var isAnimated: Bool { get set }
    
    func open(_ viewController: UIViewController, from: UIViewController, completion: (() -> Void)?)
    func close(_ viewController: UIViewController, completion: (() -> Void)?)
    func close<V:UIViewController>(_ viewController: UIViewController, to targetController: V.Type, completion: (() -> Void)?)
}
