//
//  Constants.swift
//  
//
//  Created by Marta Wilgan on 12/11/25.
//

import Foundation

enum BenjiConnectConstants {
    static let namespace: String = "benji-connect-ios"

    static let version: String = {
        // Works in apps and SwiftPM libs without resources
        let bundle = Bundle(for: BenjiConnectSDK.self)
        if let v = bundle.infoDictionary?["CFBundleShortVersionString"] as? String {
            return v
        }
        return "0.0.0"
    }()
}

