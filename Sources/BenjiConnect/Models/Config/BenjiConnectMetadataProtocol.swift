//
//  BenjiConnectMetadataProtocol.swift
//
//
//  Created by Marta Wilgan on 12/12/25.
//

import Foundation

public protocol BenjiConnectMetadataProtocol: Sendable {
    var context: BenjiConnectMetadata.Context { get }
    var extras: [String: JSONValue] { get }
}
