//
//  BenjiConnectOnExitMetadata.swift
//  
//
//  Created by Marta Wilgan on 12/12/25.
//

import Foundation

public struct BenjiConnectOnExitMetadata: BenjiConnectMetadataProtocol, Equatable {
    public let base: BenjiConnectMetadata
    public let trigger: String?
    public let step: String?

    public var context: BenjiConnectMetadata.Context { base.context }
    public var extras: [String: JSONValue] { base.extras }

    public init(
        base: BenjiConnectMetadata,
        trigger: String? = nil,
        step: String? = nil
    ) {
        self.base = base
        self.trigger = trigger
        self.step = step
    }
}
