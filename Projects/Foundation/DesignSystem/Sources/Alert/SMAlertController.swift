//
//  SMAlertController.swift
//  DesignSystem
//
//  Created by Supermove on 6/26/24.
//  Copyright © 2024 kr.co.supermove.rush. All rights reserved.
//

import UIKit
import RxSwift
import Extensions

protocol RxSMAlertActionType {
    associatedtype Result
    
    var title: String? { get }
    var style: UIAlertAction.Style { get }
    var result: Result { get }
}

struct RxSMAlertAction<R>: RxSMAlertActionType {
    typealias Result = R
    
    let title: String?
    let style: UIAlertAction.Style
    let result: R
}

struct RxSMDefaultAlertAction: RxSMAlertActionType {
    typealias Result = RxSMAlertControllerResult
    
    let title: String?
    let style: UIAlertAction.Style
    let result: RxSMAlertControllerResult
}

enum RxSMAlertControllerResult {
    case ok
    case cancel
}

public class SMAlertAction: UIButton {
    
    public var style: UIAlertAction.Style!
    public var title: String!
    
    private let disposeBag = DisposeBag()
    
    public init(title: String, style: UIAlertAction.Style, handler: ((SMAlertAction) -> Void)? = nil) {
        self.style = style
        self.title = title
        super.init(frame: CGRect(x: 0, y: 0, width: 0, height: 48))
        
        self.setTitle(title, for: .normal)
        self.titleLabel?.font = .spoqaFont(size: 16, weight: .medium)
        self.setTitleColor(style == .default ? UIColor(hex: "333333") : UIColor(hex: "E92F2F"), for: .normal)
        self.contentHorizontalAlignment = .leading
        
        self.rx.tap.asDriver().drive(onNext: {
            [unowned self] in
            handler?(self)
        }).disposed(by: disposeBag)
    }
    
    public func updateUIToAlert() {
        self.layer.cornerRadius = 8
        self.backgroundColor = style == .default ? .sm(.primary) : .sm(.subtle)
        self.setTitleColor(style == .default ? .white : .sm(.primary), for: .normal)
        self.titleLabel?.font = .spoqaFont(size: 16, weight: .bold)
        self.contentHorizontalAlignment = .center
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}


extension SMAlertController {
    public enum Style : Int, @unchecked Sendable {
        case actionSheet = 0
        case alert = 1
        case html = 2
    }
}

public class SMAlertController: UIViewController {
    public var preferredStyle: SMAlertController.Style!
    
    private let scrollView = UIScrollView()
    
    private let backgroundView = UIView().then {
        $0.backgroundColor = UIColor(hex: "292937").withAlphaComponent(0.6)
    }
    
    private let containerView = UIView().then {
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 12
    }
    
    private let stackView = UIStackView()
    
    private let titleLabel = UILabel().then {
        $0.font = .spoqaFont(size: 20, weight: .bold)
        $0.textColor = .black
        $0.textAlignment = .left
        $0.numberOfLines = 0
    }
    
    private let subTitleLabel = UILabel().then {
        $0.font = .spoqaFont(size: 14, weight: .regular)
        $0.textColor = UIColor(hex: "333333")
        $0.textAlignment = .left
        $0.numberOfLines = 0
        $0.lineBreakMode = .byWordWrapping
    }
    
    public init(title: String?, _ subTitle: String?, style: SMAlertController.Style) {
        self.preferredStyle = style
        super.init(nibName: nil, bundle: nil)
        
        self.modalPresentationStyle = .overFullScreen
        self.modalTransitionStyle = .crossDissolve
        
        switch style {
        case .alert:
            self.titleLabel.text = title
            self.subTitleLabel.text = subTitle
            self.stackView.axis = .horizontal
            self.stackView.distribution = .fillEqually
            self.stackView.spacing = 8
        case .html:
            self.titleLabel.text = title
            let htmlToAttributedText = subTitle?.convertToAttributedFromHTML()
            htmlToAttributedText?.addAttribute(.font,
                                               value: UIFont.spoqaFont(size: 14, weight: .regular),
                                               range: NSMakeRange(0, htmlToAttributedText?.length ?? 0))
            self.subTitleLabel.attributedText = htmlToAttributedText
            self.stackView.axis = .horizontal
            self.stackView.distribution = .fillEqually
            self.stackView.spacing = 8
        case .actionSheet:
            self.stackView.axis = .vertical
            self.stackView.spacing = 0
        }
    }
    
    public init(title: String?, attributedContents: NSMutableAttributedString?, style: SMAlertController.Style) {
        self.preferredStyle = style
        super.init(nibName: nil, bundle: nil)
        
        self.modalPresentationStyle = .overFullScreen
        self.modalTransitionStyle = .crossDissolve
        
        switch style {
        case .alert:
            self.titleLabel.text = title
            self.subTitleLabel.attributedText = attributedContents
            self.stackView.axis = .horizontal
            self.stackView.distribution = .fillEqually
            self.stackView.spacing = 8
        case .html:
            self.titleLabel.text = title
            attributedContents?.addAttribute(.font,
                                   value: UIFont.spoqaFont(size: 14, weight: .regular),
                                   range: NSMakeRange(0, attributedContents?.length ?? 0))
            self.subTitleLabel.attributedText = attributedContents
            self.stackView.axis = .horizontal
            self.stackView.distribution = .fillEqually
            self.stackView.spacing = 8
        case .actionSheet:
            self.stackView.axis = .vertical
            self.stackView.spacing = 0
        }
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        self.setupView()
    }
    
    public func addAction(_ action: SMAlertAction) {
        if preferredStyle != .actionSheet { action.updateUIToAlert() }
        action.snp.makeConstraints { $0.height.equalTo(56) }
        
        if action.style == .cancel {
            let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissView))
            action.addGestureRecognizer(tap)
        }
        
        self.stackView.addArrangedSubview(action)
    }
    
    @objc private func dismissView() {
        self.dismiss(animated: true)
    }
    
    private func setupView() {
        self.view.addSubview(backgroundView)
        
        backgroundView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        if self.preferredStyle == .actionSheet {
            self.setupActionSheetView()
        }
        
        if self.preferredStyle == .alert {
            self.setupAlertView()
        }
        
        if self.preferredStyle == .html {
            self.setupHTMLView()
        }
    }
    
    private func setupAlertView() {
        self.view.addSubview(containerView)
        
        containerView.addSubviews(
            titleLabel,
            subTitleLabel,
            stackView
        )
        
        containerView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(24)
            $0.height.lessThanOrEqualTo(420)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview().inset(24)
        }
        
        subTitleLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(16)
            $0.leading.trailing.equalToSuperview().inset(24)
        }
        
        stackView.snp.makeConstraints {
            $0.top.equalTo(subTitleLabel.snp.bottom).offset(24)
            $0.leading.trailing.bottom.equalToSuperview().inset(24)
        }
    }
    
    private func setupHTMLView() {
        self.view.addSubview(containerView)
        containerView.addSubviews(
            titleLabel,
            scrollView,
            stackView
        )
        
        scrollView.addSubview(subTitleLabel)
        
        containerView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(24)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview().inset(24)
        }
        
        scrollView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(16)
            $0.leading.trailing.equalToSuperview().inset(24)
            $0.height.equalTo(0)
        }
        
        subTitleLabel.snp.makeConstraints {
            $0.width.edges.equalToSuperview().priority(.required)
        }
        
        stackView.snp.makeConstraints {
            $0.top.equalTo(scrollView.snp.bottom).offset(24)
            $0.leading.trailing.bottom.equalToSuperview().inset(24)
        }
    }
    
    private func setupActionSheetView() {
        self.view.addSubview(scrollView)
        self.scrollView.addSubview(containerView)
        
        scrollView.snp.makeConstraints {
            $0.height.equalTo(0)
            $0.leading.trailing.bottom.equalToSuperview()
        }
        
        containerView.snp.makeConstraints {
            $0.width.edges.equalToSuperview()
        }
        containerView.addSubview(stackView)
        
        stackView.snp.makeConstraints {
            if self.preferredStyle == .alert {
                $0.top.equalTo(subTitleLabel.snp.bottom).offset(102)
            } else {
                $0.top.equalToSuperview().inset(20)
            }
            $0.leading.trailing.equalToSuperview().inset(18)
            $0.bottom.equalToSuperview().inset(34)
        }
    }
    
    public override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if self.preferredStyle == .html {
            scrollView.snp.updateConstraints {
                $0.height.equalTo(self.subTitleLabel.intrinsicContentSize.height > 250 ? 250 : self.subTitleLabel.intrinsicContentSize.height)
            }
        }
        
        if self.preferredStyle == .actionSheet {
            self.scrollView.snp.updateConstraints {
                $0.height.equalTo((self.stackView.arrangedSubviews.count * 56) + 20 + 34)
            }
            self.view.layoutIfNeeded()
        }
    }
    
    private func updateScrollViewConstraints() {
        UIView.animate(withDuration: 0.3, delay: .zero, options: .curveEaseOut, animations: {
            self.scrollView.snp.updateConstraints {
                if self.containerView.bounds.height >= 500 {
                    $0.height.equalTo(500)
                } else {
                    $0.height.equalTo(self.containerView.bounds.height)
                }
            }
            self.view.layoutIfNeeded()
        })
    }
}
