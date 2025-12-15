//
//  BenjiConnectMetadata.swift
//  
//
//  Created by Marta Wilgan on 12/12/25.
//

import Foundation

public struct BenjiConnectMetadata: BenjiConnectMetadataProtocol, Equatable {
    
    public struct Context: Sendable, Equatable {
        public let namespace: String
        public let version: String

        public init(namespace: String, version: String) {
            self.namespace = namespace
            self.version = version
        }
    }

    public let context: Context
    public let extras: [String: JSONValue]

    public init(context: Context, extras: [String: JSONValue] = [:]) {
        self.context = context
        self.extras = extras
    }
}
