//
//  UITableView+CellIdentifier.swift
//  Util
//
//  Created by Supermove on 3/5/24.
//  Copyright © 2024 kr.co.supermove.rush. All rights reserved.
//

import UIKit

extension UITableViewCell {
    static public var cellIdentifier: String {
        return String(describing: self)
    }
}
