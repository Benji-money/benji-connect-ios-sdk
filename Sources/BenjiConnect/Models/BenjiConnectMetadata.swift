//
//  BenjiConnectMetadats.swift
//  
//
//  Created by Marta Wilgan on 12/11/25.
//

import Foundation

public struct BenjiConnectMetadataContext: Codable {
    public let namespace: String
    public let version: String

    public init(namespace: String, version: String) {
        self.namespace = namespace
        self.version = version
    }
}

public struct BenjiConnectMetadata: Codable {
    public let context: BenjiConnectMetadataContext

    public init(context: BenjiConnectMetadataContext) {
        self.context = context
    }
}

/// Success metadata returned to host app
public struct BenjiConnectOnSuccessMetadata: Codable {
    public let context: BenjiConnectMetadataContext
    public let action: String?
    public let userData: BenjiConnectEventUserData?

    public init(
        context: BenjiConnectMetadataContext,
        action: String?,
        userData: BenjiConnectEventUserData?
    ) {
        self.context = context
        self.action = action
        self.userData = userData
    }
}

/// Exit metadata returned to host app
public struct BenjiConnectOnExitMetadata: Codable {
    public let context: BenjiConnectMetadataContext
    public let step: String?
    public let trigger: String?

    public init(
        context: BenjiConnectMetadataContext,
        step: String?,
        trigger: String?
    ) {
        self.context = context
        self.step = step
        self.trigger = trigger
    }
}
