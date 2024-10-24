//
//  BaseViewModel.swift
//  ViewModel
//
//  Created by Supermove on 6/26/24.
//  Copyright © 2024 kr.co.supermove.rush. All rights reserved.
//

import Foundation
import RxSwift
import Logger

open class ViewModel: NSObject {
    
    public let toast = PublishSubject<String>()
    public let loading = LoadingTracker()
    public let error = ErrorTracker()
    
    deinit {
        SMLogger.log(category: .ui, level: .info, message: "DEINIT: \(type(of: self))")
    }
}
