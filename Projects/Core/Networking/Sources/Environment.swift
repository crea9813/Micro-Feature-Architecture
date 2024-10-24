//
//  Environment.swift
//  Network
//
//  Created by Supermove on 6/25/24.
//  Copyright © 2024 kr.co.supermove.rush. All rights reserved.
//

import Foundation
import UIKit
import TAKUUID
import Extensions
import UserStore

public class Environment {
    public static let sharedInstance = Environment()
    
    enum Keys {
        enum Plist {
            static let BaseURL = "API_URL"
            static let SubURL = "SUB_URL"
        }
    }
    
    public static var isBaseURLFailure: Bool = false
    
    private static let infoDictionary: [String: Any] = {
        guard let dict = Bundle.main.infoDictionary else {
            fatalError("Plist file not found")
        }
        return dict
    }()
    
    public static var baseURL: URL {
        guard let url = URL(string: Environment.baseURLString) else { fatalError("Base URL is invalid.") }
        return url
    }
    
    public static var baseURLString: String {
        guard let baseURLString = Environment.infoDictionary[Keys.Plist.BaseURL] as? String else {
            fatalError("Base URL is Not Found.")
        }
        return baseURLString
    }
    
    public static var deviceID: String {
        guard let deviceIDString = TAKUUIDStorage.sharedInstance().findOrCreate() else {
            fatalError("Cannot Create Or Find Device UUID.")
        }
        return deviceIDString
    }
    
    public var header: [String : String] {
        get {
            var versionStr = "0.0.1"
            var buildVersionStr = "0"
            if let dict = Bundle.main.infoDictionary {
                if let version = dict["CFBundleShortVersionString"] as? String {
                    versionStr = version
                }
                
                buildVersionStr = dict["CFBundleVersion"] as? String ?? "0"
            }
            
            let deviceName = UIDevice.modelName
            
            #if DEBUG
            let authorization = "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoyMTA3NywicGhvbmUiOiIwMTAwMDAwNTAxNCIsImRldmljZV9pZCI6IjUzN0I0MDRBLTA4NjMtNDA0Mi04MTRDLUJBQTMyMzFDNjQyOSIsImV4cCI6MTc4MzYwOTQ5Mn0.LYKLfQtTlVc-CJXbZo7yWxMwmZPgEDDy4i1PNVa1iw8"
            #else
            let authorization = Defaults.jwtToken ?? "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoyNjcyOSwicGhvbmUiOiIwMTAwMDAwNTAxNCIsImRldmljZV9pZCI6IkZEODE0NkM1LUQ3OUUtNDQyRi04QjhFLTcxQjhCMzcwNTg4MCIsImV4cCI6MTc4Mzg1NDUxMH0.g31apRmGr6HCo_Kt9dpLeD5x7HYYUGhb6B1s9uhHsJ8"
            #endif
            
            return ["Content-Type" : "application/json",
                    "OS" : "I",
                    "User-Agent" : "iOS",
                    "Version" : versionStr,
                    "VERSIONCODE" : buildVersionStr,
                    "DeviceNm" : deviceName,
                    "DeviceID" : Environment.deviceID,
                    "Authorization" : authorization
            ]
        }
    }
}

