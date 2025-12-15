//
//  BenjiConnectOnErrorData.swift
//  
//
//  Created by Marta Wilgan on 12/12/25.
//

import Foundation

public struct BenjiConnectOnErrorData: Sendable {
    public let error: Error
    public let errorID: String
    public let metadata: BenjiConnectMetadata

    public init(error: Error, errorID: String, metadata: BenjiConnectMetadata) {
        self.error = error
        self.errorID = errorID
        self.metadata = metadata
    }
}
