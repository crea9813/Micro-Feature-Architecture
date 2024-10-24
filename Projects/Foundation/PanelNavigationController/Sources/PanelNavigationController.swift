import Foundation
import UIKit
import FloatingPanel

extension PanelNavigationController {
    public struct PanelViewController {
        let panelController: FloatingPanelController
        let contentViewController: BasePanelViewController
    }
}

public class PanelNavigationController {
    
    public var parent: UIViewController!
    public var panelViewControllers: [PanelViewController] = []
    
    private let appearance = SurfaceAppearance()
    
    public init() {
        self.appearance.backgroundColor = .white
        self.appearance.cornerRadius = 16
    }
    
    public init(rootViewController: UIViewController) {
        self.parent = rootViewController
    }
}

extension PanelNavigationController {
    public func move(_ state: FloatingPanelState) {
        if let panelViewController = self.panelViewControllers.last {
            panelViewController.panelController.move(to: state, animated: true)
        }
    }
    
    public func present(_ viewController: BasePanelViewController, animated: Bool = false) {
        let panelController = FloatingPanelController()
        panelController.layout = viewController.layout
        panelController.delegate = viewController.delegate
        panelController.surfaceView.appearance = viewController.surfaceAppearance
        panelController.panGestureRecognizer.isEnabled = viewController.isSwipeEnabled
        panelController.surfaceView.grabberHandle.isHidden = true
        panelController.set(contentViewController: viewController)
        
        panelController.backdropView.dismissalTapGestureRecognizer.isEnabled = viewController.isDismissWhenBackdropViewTapped
        self.parent.present(panelController, animated: true)
        viewController.panelNavigationController = self
        let panelViewController = PanelViewController(panelController: panelController, contentViewController: viewController)
        
        self.panelViewControllers.append(panelViewController)
    }
    
    public func pushPanelController(_ viewController: BasePanelViewController, animated: Bool) {
        self.hideCurrentController(animated: true)
        viewController.panelNavigationController = self
        
        let panelController = FloatingPanelController()
        panelController.layout = viewController.layout
        panelController.delegate = viewController.delegate
        panelController.surfaceView.appearance = viewController.surfaceAppearance
        panelController.panGestureRecognizer.isEnabled = viewController.isSwipeEnabled
        panelController.surfaceView.grabberHandle.isHidden = true
        panelController.set(contentViewController: viewController)
        panelController.backdropView.dismissalTapGestureRecognizer.isEnabled = viewController.isDismissWhenBackdropViewTapped
        panelController.addPanel(toParent: parent, animated: animated)
        let panelViewController = PanelViewController(panelController: panelController, contentViewController: viewController)
        
        self.panelViewControllers.append(panelViewController)
    }
    
    @discardableResult
    public func popViewController(animated: Bool, completion: (() -> Void)? = nil) -> PanelViewController? {
//        if self.viewControllers.count == 1 { return nil }
        
        if let panelViewController = self.panelViewControllers.popLast() {
            panelViewController.panelController.willMove(toParent: nil)
            panelViewController.panelController.hide(animated: animated) {
                panelViewController.panelController.view.removeFromSuperview()
                panelViewController.panelController.removeFromParent()
            }
            panelViewController.panelController.removePanelFromParent(animated: animated)
            self.showLastController(animated: animated)
            return panelViewController
        }
        
        completion?()
        return nil
    }
    
    public func popToPanelController(to panel: BasePanelViewController, animated: Bool) {
        let targetIndex = self.panelViewControllers
            .map { $0.contentViewController }
            .lastIndex(of: panel)
        
        let currentIndex = self.panelViewControllers.count
        
        guard let targetIndex = targetIndex else { return }
        
        for _ in targetIndex..<currentIndex {
            self.popViewController(animated: animated)
        }
    }
    
    private func hideCurrentController(animated: Bool) {
        if let panelViewController = self.panelViewControllers.last {
            panelViewController.panelController.hide(animated: animated)
            panelViewController.panelController.view.isHidden = true
        }
    }
    
    private func showLastController(animated: Bool) {
        if let panelViewController = self.panelViewControllers.last {
            panelViewController.panelController.show(animated: animated)
            panelViewController.panelController.view.isHidden = false
        }
    }
}
