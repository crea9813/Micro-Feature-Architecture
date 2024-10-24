//
//  MapableView.swift
//  Maps
//
//  Created by Supermove on 9/24/24.
//  Copyright © 2024 kr.co.supermove.rush. All rights reserved.
//

import Then
import UIKit
import SnapKit
import RxSwift
import RxCocoa
import NMapsMap
import Logger
import Extensions
import DesignSystem
import FloatingPanel
import PanelNavigationController

open class MapPanelViewController: BasePanelViewController {
    public var maps: Maps!
    
    override public init(
        layout: FloatingPanelLayout = BasePanelLayout(),
        surfaceAppearance: SurfaceAppearance = SurfaceAppearance()
    ) {
        super.init(layout: layout, surfaceAppearance: surfaceAppearance)
    }
    
    @MainActor required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        SMLogger.log(category: .ui, level: .fault, message: "DEINIT : \(String(describing: self))")
    }
    
    public let currentPositionButton = UIButton().then {
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 8
        $0.layer.shadowColor = UIColor.sm(.background(.bg0)).cgColor
        $0.layer.shadowOpacity = 0.2
        $0.layer.shadowRadius = 4
        $0.layer.shadowOffset = CGSize(width: 0, height: 1)
        $0.setImage(DesignSystemAsset.mapNormal.image, for: .normal)
    }
    
    public let backButton = UIButton().then {
        $0.setImage(DesignSystemAsset.arrowLeftCircleBlack.image, for: .normal)
        $0.tintColor = .sm(.background(.bg0))
        $0.layer.zPosition = 1
    }
    
    public let reloadButton = UIButton().then {
        $0.setTitle("map_near_searching".localized(), for: .normal)
        $0.titleLabel?.font = .spoqaFont(size: 12, weight: .regular)
        $0.backgroundColor = .white
        $0.setImage(UIImage(), for: .selected)
        $0.layer.cornerRadius = 22
        $0.layer.shadowColor = UIColor(red: 0.546, green: 0.546, blue: 0.546, alpha: 0.25).cgColor
        $0.layer.shadowOpacity = 1.0
        $0.layer.shadowOffset = CGSize(width: 0, height: 4)
        $0.layer.shadowRadius = 10
        $0.imageView?.tintColor = UIColor(red: 0.375, green: 0.375, blue: 0.375, alpha: 1)
        $0.imageEdgeInsets = UIEdgeInsets(top: 0, left: -2, bottom: 0, right: 0)
        $0.titleEdgeInsets = UIEdgeInsets(top: 3, left: 29 , bottom: 0, right: 0)
        $0.setTitleColor(UIColor(red: 0.375, green: 0.375, blue: 0.375, alpha: 1), for: .normal)
        $0.isHidden = true
    }
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        self.maps.mapView.addOptionDelegate(delegate: self)
    }
    
    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    open override func floatingPanel(_ fpc: FloatingPanelController, animatorForPresentingTo state: FloatingPanelState) -> UIViewPropertyAnimator {
        fpc.view.addSubview(backButton)
        fpc.view.addSubview(reloadButton)
        fpc.surfaceView.addSubview(currentPositionButton)
        
        backButton.snp.makeConstraints {
            $0.top.equalTo(fpc.view.safeAreaLayoutGuide)
            $0.leading.equalToSuperview().inset(7)
            $0.width.height.equalTo(56)
        }
        
        currentPositionButton.snp.makeConstraints {
            $0.width.height.equalTo(48)
            $0.trailing.equalToSuperview().inset(18)
            $0.bottom.equalTo(fpc.surfaceView.snp.top).offset(-18)
        }
        
        reloadButton.snp.makeConstraints {
            $0.centerY.equalTo(backButton)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(44)
            $0.width.equalTo(100)
        }
        
        let timingParameters = UISpringTimingParameters(
            decelerationRate: UIScrollView.DecelerationRate.fast.rawValue,
            frequencyResponse: 0.25
        )
        return UIViewPropertyAnimator(duration: 0.0, timingParameters: timingParameters)
    }
}

extension MapPanelViewController {
    public var didMapBackTapped: Driver<Void> {
        return backButton.rx.tap.asDriver()
    }
}

extension MapPanelViewController: NMFMapViewOptionDelegate {
    private func mapViewOptionChanged(_ positionMode: NMFMyPositionMode) {
        switch positionMode {
        case .compass:
            currentPositionButton.setImage(DesignSystemAsset.mapCompass.image, for: .normal)
        case .direction:
            currentPositionButton.setImage(DesignSystemAsset.mapFocus.image, for: .normal)
        case .disabled, .normal:
            currentPositionButton.setImage(DesignSystemAsset.mapNormal.image, for: .normal)
        default: break
        }
    }
}
