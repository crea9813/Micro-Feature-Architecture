//
//  String+Localized.swift
//  DesignSystem
//
//  Created by Supermove on 9/5/24.
//  Copyright © 2024 kr.co.supermove.rush. All rights reserved.
//

import Foundation

public extension String {
    func localized(comment: String = "") -> String {
        let format = Bundle.module.localizedString(forKey: self, value: nil, table: "Localizable")
        return String(format: format, locale: Locale.current)
    }
    
    func localized(with arguments: CVarArg..., comment: String = "") -> String {
        let format = Bundle.module.localizedString(forKey: self, value: nil, table: "Localizable")
        return String(format: format, locale: Locale.current, arguments: arguments)
    }
    
    func localized(with arguments: Int..., comment: String = "") -> String {
        let arguments = arguments.map { "\($0)" }.map { $0 as CVarArg}
        let format = Bundle.module.localizedString(forKey: self, value: nil, table: "Localizable")
        return String(format: format, locale: Locale.current, arguments: arguments)
    }
}
