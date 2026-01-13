//
//  BenjiConnectAuth.swift
//  
//
//  Created by Marta Wilgan on 12/12/25.
//

import Foundation

public struct BenjiConnectAuth: Codable, Sendable, Equatable {
    public let accessToken: String
    public let configToken: String

    public init(accessToken: String, configToken: String) {
        self.accessToken = accessToken
        self.configToken = configToken
    }
}
