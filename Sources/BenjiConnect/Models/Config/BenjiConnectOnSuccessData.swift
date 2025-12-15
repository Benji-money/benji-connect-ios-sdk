//
//  BenjiConnectOnSuccessData.swift
//  
//
//  Created by Marta Wilgan on 12/12/25.
//

import Foundation

public struct BenjiConnectOnSuccessData: Sendable, Equatable {
    public let token: String
    public let metadata: BenjiConnectOnSuccessMetadata

    public init(token: String, metadata: BenjiConnectOnSuccessMetadata) {
        self.token = token
        self.metadata = metadata
    }
}
