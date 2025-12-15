//
//  BenjiConnectErrorEventData.swift
//  
//
//  Created by Marta Wilgan on 12/12/25.
//

import Foundation

public struct BenjiConnectErrorEventData: Codable, Sendable, Equatable {
    public let error: BenjiConnectTransportError

    public init(error: BenjiConnectTransportError) {
        self.error = error
    }
}
