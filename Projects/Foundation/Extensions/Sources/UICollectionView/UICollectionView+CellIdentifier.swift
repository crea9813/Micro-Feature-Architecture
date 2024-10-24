//
//  UICollectionView+CellIdentifier.swift
//  Extensions
//
//  Created by Supermove on 7/12/24.
//  Copyright © 2024 kr.co.supermove.rush. All rights reserved.
//

import UIKit

extension UICollectionViewCell {
    static public var cellIdentifier: String {
        return String(describing: self)
    }
}
