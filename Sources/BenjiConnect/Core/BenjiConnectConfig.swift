//
//  BenjiConnectConfig.swift
//  
//
//  Created by Marta Wilgan on 12/11/25.
//

import Foundation

/// Public config passed by host app (similar to web `BenjiConnectConfig`)
public struct BenjiConnectConfig {

    public let environment: BenjiConnectEnvironment
    public let token: String

    public let onSuccess: ((String, BenjiConnectOnSuccessMetadata) -> Void)?
    public let onError: ((Error, String, BenjiConnectMetadata) -> Void)?
    public let onExit: ((BenjiConnectOnExitMetadata) -> Void)?
    public let onEvent: ((BenjiConnectEventType, BenjiConnectMetadata) -> Void)?

    public init(
        environment: BenjiConnectEnvironment,
        token: String,
        onSuccess: ((String, BenjiConnectOnSuccessMetadata) -> Void)? = nil,
        onError: ((Error, String, BenjiConnectMetadata) -> Void)? = nil,
        onExit: ((BenjiConnectOnExitMetadata) -> Void)? = nil,
        onEvent: ((BenjiConnectEventType, BenjiConnectMetadata) -> Void)? = nil
    ) {
        self.environment = environment
        self.token = token
        self.onSuccess = onSuccess
        self.onError = onError
        self.onExit = onExit
        self.onEvent = onEvent
    }
}
