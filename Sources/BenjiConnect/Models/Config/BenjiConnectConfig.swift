//
//  BenjiConnectConfig.swift
//  
//
//  Created by Marta Wilgan on 12/12/25.
//

import Foundation

public struct BenjiConnectConfig: Sendable {

    public typealias OnSuccess = @Sendable (_ token: String, _ metadata: BenjiConnectOnSuccessMetadata) -> Void
    public typealias OnError   = @Sendable (_ error: Error, _ errorID: String, _ metadata: BenjiConnectMetadata) -> Void
    public typealias OnExit    = @Sendable (_ metadata: BenjiConnectOnExitMetadata) -> Void
    public typealias OnEvent   = @Sendable (_ type: BenjiConnectEventType, _ metadata: BenjiConnectMetadata) -> Void

    public let environment: BenjiConnectEnvironment
    public let token: String

    public let onSuccess: OnSuccess?
    public let onError: OnError?
    public let onExit: OnExit?
    public let onEvent: OnEvent?

    public init(
        environment: BenjiConnectEnvironment,
        token: String,
        onSuccess: OnSuccess? = nil,
        onError: OnError? = nil,
        onExit: OnExit? = nil,
        onEvent: OnEvent? = nil
    ) {
        self.environment = environment
        self.token = token
        self.onSuccess = onSuccess
        self.onError = onError
        self.onExit = onExit
        self.onEvent = onEvent
    }
    
    /// Convenience overload: allow String environment input but normalize immediately.
    public init?(
        environment: String,
        token: String,
        onSuccess: OnSuccess? = nil,
        onError: OnError? = nil,
        onExit: OnExit? = nil,
        onEvent: OnEvent? = nil
    ) {
        guard let validEnvironment = BenjiConnectEnvironment(rawValue: environment.lowercased()) else {
            return nil // or throw, see below
        }
        self.init(
            environment: validEnvironment,
            token: token,
            onSuccess: onSuccess,
            onError: onError,
            onExit: onExit,
            onEvent: onEvent
        )
    }
}
