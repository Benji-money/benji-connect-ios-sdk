//
//  BenjiConnectTransportError.swift
//  
//
//  Created by Marta Wilgan on 12/12/25.
//

import Foundation

/// JSON-friendly representation of an error coming over transport.
/// TODO: Adjust fields to match what Connect repo sends?
public struct BenjiConnectTransportError: Codable, Sendable, Equatable {
    public let name: String?
    public let message: String?
    public let stack: String?

    public init(name: String? = nil, message: String? = nil, stack: String? = nil) {
        self.name = name
        self.message = message
        self.stack = stack
    }
}
