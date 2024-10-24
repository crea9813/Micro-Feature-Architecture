//
//  BasePanelViewController.swift
//  PanelNavigationController
//
//  Created by Supermove on 7/9/24.
//  Copyright © 2024 kr.co.supermove.rush. All rights reserved.
//

import UIKit
import FloatingPanel

public protocol BaseFloatingPanel {
    var layout: FloatingPanelLayout { get }
    var surfaceAppearance: SurfaceAppearance { get }
    var isDismissWhenBackdropViewTapped: Bool { get set }
    var isSwipeEnabled: Bool { get }
}

open class BasePanelLayout: FloatingPanelLayout {
    public init() { }
    public let position: FloatingPanelPosition = .bottom
    public let initialState: FloatingPanelState = .full
    public let anchors: [FloatingPanelState: FloatingPanelLayoutAnchoring] = [
        .full: FloatingPanelIntrinsicLayoutAnchor(absoluteOffset: 0, referenceGuide: .superview)
    ]
}

extension BasePanelViewController: FloatingPanelControllerDelegate {
    open func floatingPanelDidRemove(_ fpc: FloatingPanelController) { }
    open func floatingPanelDidChangeState(_ fpc: FloatingPanelController) { }
    open func floatingPanelDidEndAttracting(_ fpc: FloatingPanelController) { }
    open func floatingPanelWillBeginDragging(_ fpc: FloatingPanelController) { }
    open func floatingPanelWillEndDragging(_ fpc: FloatingPanelController, withVelocity velocity: CGPoint, targetState: UnsafeMutablePointer<FloatingPanelState>) { }
    open func floatingPanel(_ fpc: FloatingPanelController, animatorForPresentingTo state: FloatingPanelState) -> UIViewPropertyAnimator { return .init() }
    open func floatingPanel(_ fpc: FloatingPanelController, animatorForDismissingWith velocity: CGVector) -> UIViewPropertyAnimator { return .init() }
}

open class BasePanelViewController: UIViewController, BaseFloatingPanel {
    
    public var layout: FloatingPanelLayout
    public var surfaceAppearance: SurfaceAppearance
    public var delegate: FloatingPanelControllerDelegate!
    public var isDismissWhenBackdropViewTapped: Bool = true
    public var isSwipeEnabled: Bool = false
    
    public init(
        layout: FloatingPanelLayout = BasePanelLayout(),
        surfaceAppearance: SurfaceAppearance = SurfaceAppearance()
    ) {
        self.layout = layout
        self.surfaceAppearance = surfaceAppearance
        surfaceAppearance.backgroundColor = .white
        surfaceAppearance.cornerRadius = 16
        super.init(nibName: nil, bundle: nil)
        self.delegate = self
    }
    
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        setupViews()
        setupConstraints()
        bind()
    }
    
    open func setupViews() { }
    
    open func setupConstraints() { }
    
    open func bind() { }
}
