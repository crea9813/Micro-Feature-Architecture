//
//  ViewModelType.swift
//  ViewModel
//
//  Created by Supermove on 6/26/24.
//  Copyright © 2024 kr.co.supermove.rush. All rights reserved.
//

import Foundation

public protocol ViewModelType {
    associatedtype Input
    associatedtype Output
    
    func transform(input: Input) -> Output
}
