//
//  BenjiConnectOnSuccessMetadata.swift
//  
//
//  Created by Marta Wilgan on 12/12/25.
//

import Foundation

public struct BenjiConnectOnSuccessMetadata: BenjiConnectMetadataProtocol, Equatable {
    public let base: BenjiConnectMetadata
    public let action: BenjiConnectAuthAction?
    public let userData: BenjiConnectUserData?

    public var context: BenjiConnectMetadata.Context { base.context }
    public var extras: [String: JSONValue] { base.extras }

    public init(
        base: BenjiConnectMetadata,
        action: BenjiConnectAuthAction? = nil,
        userData: BenjiConnectUserData? = nil
    ) {
        self.base = base
        self.action = action
        self.userData = userData
    }
}
