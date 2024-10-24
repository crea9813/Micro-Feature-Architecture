//
//  Font+SM.swift
//  DesignSystem
//
//  Created by Supermove on 3/4/24.
//  Copyright © 2024 kr.co.supermove.rush. All rights reserved.
//

import UIKit

public extension UIFont {
    enum Spoqa: String, CaseIterable {
        case regular = "SpoqaHanSansNeo-Regular"
        case medium = "SpoqaHanSansNeo-Medium"
        case bold = "SpoqaHanSansNeo-Bold"
        
        var path: String {
            switch self {
            case .regular: return "spoqa_han_sans_neo_regular.ttf"
            case .medium: return "spoqa_han_sans_neo_medium.ttf"
            case .bold: return "spoqa_han_sans_neo_bold.ttf"
            }
        }
    }
   
    enum Gmarket: String, CaseIterable {
        case light = "GmarketSansTTFLight"
        case medium = "GmarketSansTTFMedium"
        case bold = "GmarketSansTTFBold"
        
        var path: String {
            switch self {
            case .light: return "GmarketSans-Light.ttf"
            case .medium: return "GmarketSans-Medium.ttf"
            case .bold: return "GmarketSans-Bold.ttf"
            }
        }
    }
}

public extension UIFont {
    static let multiplier : CGFloat = 1.1
    
    class func systemFont(size ofSize: CGFloat, weight: Weight) -> UIFont {
        return UIFont.systemFont(ofSize: ofSize * UIFont.multiplier, weight: weight)
    }
    
    static func spoqaFont(size ofSize: CGFloat, weight: Spoqa) -> UIFont {
        return DesignSystemFontConvertible(name: weight.rawValue, family: "Spoqa Han Sans Neo", path: weight.path).font(size: ofSize * multiplier)
    }
    
    class func gmarketSansFont(size ofSize: CGFloat, weight: Gmarket) -> UIFont {
        return DesignSystemFontConvertible(name: weight.rawValue, family: "Gmarket Sans TTF", path: weight.path).font(size: ofSize * multiplier)
    }
    
    static private func customFont(size: CGFloat, weight: String) -> UIFont? {
        return UIFont(name: weight, size: size * multiplier)
    }
    
    static func registerFont() {
        for family in UIFont.familyNames.sorted() {
            let names = UIFont.fontNames(forFamilyName: family)
            print("Family: \(family) Font names: \(names)")
        }
        
        UIFont.Spoqa.allCases.forEach {
            guard let url = Bundle(identifier: "kr.co.supermove.rush.DesignSystem")?.url(forResource: "\($0.rawValue)", withExtension: ".ttf"),
                  CTFontManagerRegisterFontsForURL(url as CFURL, .process, nil) else {
                print("fail register font")
                return
            }
        }
        
        UIFont.Gmarket.allCases.forEach {
            guard let url = Bundle(identifier: "kr.co.supermove.rush.DesignSystem")?.url(forResource: "\($0.rawValue)", withExtension: ".ttf"),
                  CTFontManagerRegisterFontsForURL(url as CFURL, .process, nil) else {
                print("fail register font")
                return
            }
        }
    }
}
