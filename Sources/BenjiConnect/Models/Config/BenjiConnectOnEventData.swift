//
//  BenjiConnectOnEventData.swift
//  
//
//  Created by Marta Wilgan on 12/12/25.
//

import Foundation

public struct BenjiConnectOnEventData: Sendable, Equatable {
    public let type: BenjiConnectEventType
    public let metadata: BenjiConnectMetadata

    public init(type: BenjiConnectEventType, metadata: BenjiConnectMetadata) {
        self.type = type
        self.metadata = metadata
    }
}
