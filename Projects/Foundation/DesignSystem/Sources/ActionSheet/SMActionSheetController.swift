//
//  SMActionSheetController.swift
//  DesignSystem
//
//  Created by Supermove on 3/12/24.
//  Copyright © 2024 kr.co.supermove.rush. All rights reserved.
//

import Then
import UIKit
import SnapKit

open class SMActionSheetController: UIViewController {
    
    public var handler: (([String:Any]) -> Void)?
    public var userInfo: [String:Any] = [:]
    
    public var actions: [SMAction] = [] {
        willSet(actions) {
            if !actions.isEmpty {
                self.emptyLabel.removeFromSuperview()
                self.submitButton.isHidden = false
            }
        }
    }
    
    private let backgroundView = UIView().then {
        $0.backgroundColor = .sm(.background(.bg0))
    }
    
    public let containerView = UIView().then {
        $0.backgroundColor = .sm(.background(.bg10))
        $0.layer.cornerRadius = 16
    }
    
    public let scrollView = UIScrollView()
    private let actionView = UIView()
    public let stackView = UIStackView().then {
        $0.distribution = .equalSpacing
        $0.spacing = 8
        $0.axis = .vertical
    }
    
    public let titleLabel = UILabel().then {
        $0.textColor = .sm(.text(.t10))
        $0.font = .spoqaFont(size: 20, weight: .bold)
    }
    
    public let cautionView = UIStackView().then {
        $0.distribution = .equalSpacing
        $0.spacing = 8
        $0.axis = .vertical
    }
    
    public let submitButton = SMBoxButton(with: "적용하기")
    
    private let emptyLabel = SMLabel().then {
        $0.font = .spoqaFont(size: 16, weight: .medium)
        $0.textColor = .sm(.text(.t40))
    }
    
    public var selectedAction: SMAction? {
        willSet(action) {
            guard let action else { return }
            self.userInfo = action.userInfo
        }
    }
    
    public init(title: String) {
        super.init(nibName: nil, bundle: nil)
        self.titleLabel.text = title
    }
    
    required public init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    open func addAction(_ action: SMAction) {
        
        action.frame = CGRect(x: 0, y: 0, width: 0, height: 56)
        self.stackView.addArrangedSubview(action)
        
        action.snp.makeConstraints { $0.height.equalTo(56) }
        
        if action.isSelected {
            self.selectedAction = action
        }
        action.handler = { [weak self] action in
            guard let self = self else { return }
            self.selectedAction?.isSelected = false
            action.isSelected = true
            self.selectedAction = action
        }
        self.actions.append(action)
    }
    
    open func setupEmptyView(with emptyText: String) {
        emptyLabel.text = emptyText
        
        self.containerView.addSubview(emptyLabel)
        
        emptyLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(titleLabel.snp.bottom).offset(54)
            $0.bottom.equalToSuperview().inset(80)
        }
        
        self.submitButton.isHidden = true
    }
    
    open func addCaution(with content: String) {
        cautionView.snp.remakeConstraints {
            $0.top.equalTo(scrollView.snp.bottom).offset(16)
            $0.leading.trailing.equalToSuperview().inset(24)
        }
        
        submitButton.snp.remakeConstraints {
            $0.top.equalTo(cautionView.snp.bottom).offset(40)
            $0.leading.trailing.bottom.equalToSuperview().inset(24)
            $0.height.equalTo(56)
        }
        
        let cautionContentView = UIView()
        let cautionDotView = UIView().then {
            $0.layer.cornerRadius = 1.5
            $0.backgroundColor = .black
        }
        
        let cautionLabel = UILabel().then {
            $0.font = .spoqaFont(size: 10, weight: .regular)
            $0.textColor = .sm(.text(.t10))
            $0.text = "\(content)"
            $0.numberOfLines = 2
        }
        
        cautionContentView.addSubview(cautionDotView)
        cautionContentView.addSubview(cautionLabel)
        
        cautionDotView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(6)
            $0.leading.equalToSuperview()
            $0.width.height.equalTo(3)
        }
        
        cautionLabel.snp.makeConstraints {
            $0.top.trailing.bottom.equalToSuperview()
            $0.leading.equalTo(cautionDotView.snp.trailing).offset(8)
        }
        
        cautionView.addArrangedSubview(cautionContentView)
    }
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        self.setupViews()
        self.setupConstraints()
        self.bind()
    }
    
    open override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.scrollView.snp.updateConstraints {
            if (self.actions.count * (56 + 8)) >= 500 {
                $0.height.equalTo(500)
            } else {
                $0.height.equalTo((self.actions.count * (56 + 8)))
            }
        }
        self.view.layoutIfNeeded()
    }
    
    private func setupViews() {
        self.view.addSubview(backgroundView)
        
        backgroundView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        self.view.addSubview(containerView)
        
        containerView.addSubview(titleLabel)
        containerView.addSubview(scrollView)
        containerView.addSubview(cautionView)
        containerView.addSubview(submitButton)
        
        scrollView.addSubview(actionView)
        actionView.addSubview(stackView)
    }
    
    private func setupConstraints() {
        containerView.snp.makeConstraints {
            $0.leading.trailing.bottom.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.leading.equalToSuperview().inset(24)
        }
        
        scrollView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(20)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(0)
        }
        
        actionView.snp.makeConstraints {
            $0.width.edges.equalToSuperview()
        }
        
        stackView.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(24)
        }
        
        cautionView.snp.makeConstraints {
            $0.top.equalTo(scrollView.snp.bottom).offset(16)
            $0.leading.trailing.equalToSuperview().inset(24)
        }
        
        submitButton.snp.makeConstraints {
            $0.top.equalTo(scrollView.snp.bottom).offset(24)
            $0.leading.trailing.bottom.equalToSuperview().inset(24)
            $0.height.equalTo(56)
        }
    }
    
    private func bind() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissView))
        tap.cancelsTouchesInView = false
        backgroundView.addGestureRecognizer(tap)
        
        self.submitButton.addTarget(self, action: #selector(handleSubmit), for: .touchUpInside)
    }
    
    @objc
    open func handleSubmit() {
        self.handler?(userInfo)
    }
    
    @objc private func dismissView() {
        self.dismiss(animated: true)
    }
}
