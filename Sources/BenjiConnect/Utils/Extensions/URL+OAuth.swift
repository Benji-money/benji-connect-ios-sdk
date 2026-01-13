//
//  URL+OAuth.swift
//  BenjiConnect
//
//  Created by Marta Wilgan on 12/16/25.
//

import Foundation

extension URL {
    var isOAuthURL: Bool {
        // Customize for providers / routes:
        // e.g. /oauth/authorize, /auth/redirect, accounts.google.com, etc.
        let hostStandardized = host?.lowercased() ?? ""
        let pathStandardized = path.lowercased()

        if hostStandardized.contains("accounts.google.com") { return true }
        if pathStandardized.contains("/oauth") || pathStandardized.contains("/authorize") { return true }
        return false
    }
}
