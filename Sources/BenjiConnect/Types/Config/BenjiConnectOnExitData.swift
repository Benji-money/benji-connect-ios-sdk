//
//  BenjiConnectOnExitData.swift
//  
//
//  Created by Marta Wilgan on 12/12/25.
//

import Foundation

public struct BenjiConnectOnExitData: Sendable, Equatable {
    public let metadata: BenjiConnectOnExitMetadata

    public init(metadata: BenjiConnectOnExitMetadata) {
        self.metadata = metadata
    }
}
