//
//  Constants.swift
//  
//
//  Created by Marta Wilgan on 12/11/25.
//

import Foundation

enum BenjiConnectConstants {

    /// Namespace used for metadata.context.namespace
    static let namespace: String = "benji-connect-ios"

    /// SDK version — automatically pulled from the Swift package’s Info.plist
    static let version: String = {
        // Try to read version from bundle metadata
        if let version = Bundle.module.infoDictionary?["CFBundleShortVersionString"] as? String {
            return version
        }
        // Fallback if not found
        return "0.0.0"
    }()
}
