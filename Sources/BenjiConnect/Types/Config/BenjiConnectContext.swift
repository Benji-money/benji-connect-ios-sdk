//
//  BenjiConnectContext.swift
//  
//
//  Created by Marta Wilgan on 12/12/25.
//

import Foundation

public struct BenjiConnectContext: Sendable, Equatable {
    public let namespace: String?
    public let version: String?

    public init(namespace: String? = nil, version: String? = nil) {
        self.namespace = namespace
        self.version = version
    }
}
