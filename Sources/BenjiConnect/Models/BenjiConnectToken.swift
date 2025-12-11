//
//  BenjiConnectToken.swift
//  
//
//  Created by Marta Wilgan on 12/11/25.
//

import Foundation

/// Mirrors TypeScript `BenjiConnectEventToken`
public struct BenjiConnectEventToken: Codable {
    public let accessToken: String
    public let refreshToken: String
    public let expiresAt: String?

    public init(
        accessToken: String,
        refreshToken: String,
        expiresAt: String?
    ) {
        self.accessToken = accessToken
        self.refreshToken = refreshToken
        self.expiresAt = expiresAt
    }
}
