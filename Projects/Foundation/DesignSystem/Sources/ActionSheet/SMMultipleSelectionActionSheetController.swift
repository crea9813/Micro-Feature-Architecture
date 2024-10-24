//
//  SMMultipleSelectionActionSheetController.swift
//  DesignSystem
//
//  Created by Supermove on 7/2/24.
//  Copyright © 2024 kr.co.supermove.rush. All rights reserved.
//

import UIKit

public class SMMultipleSelectionAction: SMAction {
    
    public override func updateActionView(isSelected: Bool) {
        self.iconButton.isSelected = isSelected
        self.userInfo["isSelected"] = isSelected
    }
    
    private let iconButton = UIButton().then {
        $0.setImage(DesignSystemAsset.checkmarkSquareFill.image, for: .normal)
        $0.setImage(DesignSystemAsset.checkmarkSquareFillBlack.image, for: .selected)
        $0.setTitleColor(.black, for: .normal)
        $0.titleLabel?.font = .spoqaFont(size: 14, weight: .regular)
        
        let intervalSpacing = 8.0
        let halfIntervalSpacing = intervalSpacing / 2
        $0.contentEdgeInsets = .init(top: 0, left: halfIntervalSpacing, bottom: 0, right: halfIntervalSpacing)
        $0.imageEdgeInsets = .init(top: 0, left: -halfIntervalSpacing, bottom: 0, right: halfIntervalSpacing)
        $0.titleEdgeInsets = .init(top: 0, left: halfIntervalSpacing, bottom: 0, right: -halfIntervalSpacing)
        $0.isUserInteractionEnabled = false
    }
    
    public override init(title: String!,
                         subTitle: String? = nil,
                         imageAlignment: ContentHorizontalAlignment = .right,
                         isSelected: Bool = false,
                         isEnabled: Bool = true,
                         userInfo: [String : Any] = [:],
                         handler: ((SMAction) -> Void)? = nil) {
        super.init()
        self.title = title
        self.subTitle = subTitle
        self.handler = handler
        self.userInfo = userInfo
        self.imageAlignment = imageAlignment
        
        self.isSelected = isSelected
        
        self.iconButton.setTitle(title, for: .normal)
        
        self.addSubviews(iconButton)
        
        self.iconButton.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(10)
            $0.leading.equalToSuperview()
        }
        self.addTarget(self, action: #selector(handleAction), for: .touchUpInside)
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

public class SMMultipleSelectionActionSheetController: SMActionSheetController {
    
    private let allSelectionAction = SMMultipleSelectionAction(title: "전체")
    public var handleMultipleSelection: (([[String:Any]]) -> Void)?
    
    public override var actions: [SMAction] {
        didSet {
            allSelectionAction.isSelected = actions.count == actions.filter({ $0.isSelected }).count
        }
    }
    
    public override var selectedAction: SMAction? {
        didSet {
            allSelectionAction.isSelected = actions.count == actions.filter({ $0.isSelected }).count
            let actions = actions.compactMap({ $0 as? SMMultipleSelectionAction })
            let firstActions = firstActions.compactMap({ $0 as? SMMultipleSelectionAction })
            self.submitButton.isEnabled = !self.actions.elementsEqual(firstActions) {
                guard let firstItem = $0.userInfo.first(where: { $0.key == "isSelected" })?.value as? Bool,
                      let secondItem = $1.userInfo.first(where: { $0.key == "isSelected" })?.value as? Bool
                else { return false }
                return firstItem == secondItem
            }
        }
    }
    
    private var firstActions: [SMAction] = []
    
    public override func addAction(_ action: SMAction) {
        self.stackView.addArrangedSubview(action)
        
        self.firstActions.append(action)
        
        if action.isSelected {
            self.selectedAction = action
        }
        
        action.handler = { [unowned self] action in
            action.isSelected = !action.isSelected
            self.selectedAction = action
            self.submitButton.isEnabled = self.actions.filter({ $0.isSelected }).count > 0
            self.submitButton.backgroundColor = self.submitButton.isEnabled ? UIColor(hex: "2FC863") : UIColor(hex: "E8E8E8")
        }
        
        self.actions.append(action)
    }
    
    public override func handleSubmit() {
        let filterAction = actions.compactMap({ $0 as? SMMultipleSelectionAction })
        print(filterAction.compactMap({ $0.userInfo }))
        self.handleMultipleSelection?(filterAction.compactMap({ $0.userInfo }))
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        self.stackView.insertArrangedSubview(allSelectionAction, at: 0)
        
        allSelectionAction.handler = { [unowned self] allSelectionAction in
            allSelectionAction.isSelected = !allSelectionAction.isSelected
            self.actions.forEach({ action in
                action.isSelected = allSelectionAction.isSelected
            })
            self.submitButton.isEnabled = self.actions.filter({ $0.isSelected }).count > 0
            self.submitButton.backgroundColor = self.submitButton.isEnabled ? UIColor(hex: "2FC863") : UIColor(hex: "E8E8E8")
        }
    }
}
