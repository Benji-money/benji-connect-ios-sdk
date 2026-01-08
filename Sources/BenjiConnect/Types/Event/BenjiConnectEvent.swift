//
//  BenjiConnectEvent.swift
//  
//
//  Created by Marta Wilgan on 12/12/25.
//

import Foundation

/// Simple “typed-ish” event envelope (like  TS `BenjiConnectEvent`)
public struct BenjiConnectEvent: Codable, Sendable, Equatable {
    public let type: BenjiConnectEventType
    public let data: BenjiConnectEventData?

    public init(type: BenjiConnectEventType, data: BenjiConnectEventData? = nil) {
        self.type = type
        self.data = data
    }
}
