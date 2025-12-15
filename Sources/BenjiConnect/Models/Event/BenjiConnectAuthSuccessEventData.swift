//
//  BenjiConnectAuthSuccessEventData.swift
//  
//
//  Created by Marta Wilgan on 12/12/25.
//

import Foundation

public struct BenjiConnectAuthSuccessEventData: Codable, Sendable, Equatable {
    public let action: BenjiConnectAuthAction
    public let token: BenjiConnectEventToken?
    public let metadata: BenjiConnectEventUserData?

    public init(
        action: BenjiConnectAuthAction,
        token: BenjiConnectEventToken? = nil,
        metadata: BenjiConnectEventUserData? = nil
    ) {
        self.action = action
        self.token = token
        self.metadata = metadata
    }
}
