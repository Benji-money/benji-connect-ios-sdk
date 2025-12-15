//
//  BenjiConnectAuthToken.swift
//  
//
//  Created by Marta Wilgan on 12/12/25.
//

import Foundation

public struct BenjiConnectAuthToken: Codable, Sendable, Equatable {
    public let accessToken: String
    public let refreshToken: String
    public let expiresAt: JSONValue?

    private enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case refreshToken = "refresh_token"
        case expiresAt = "expires_at"
    }

    public init(
        accessToken: String,
        refreshToken: String,
        expiresAt: JSONValue? = nil
    ) {
        self.accessToken = accessToken
        self.refreshToken = refreshToken
        self.expiresAt = expiresAt
    }
}
