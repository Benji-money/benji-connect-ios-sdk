//
//  Callback.swift
//  
//
//  Created by Marta Wilgan on 12/11/25.
//

import Foundation

/// { token, metadata }
struct OnSuccessPayload: Decodable {
    let token: String
    let metadata: BenjiConnectOnSuccessMetadata
}

/// { metadata }
struct OnExitPayload: Decodable {
    let metadata: BenjiConnectOnExitMetadata
}

/// { error_id, error_message, metadata }
struct OnErrorPayload: Decodable {
    let errorId: BenjiConnectErrorID
    let errorMessage: String
    let metadata: BenjiConnectMetadata

    private enum CodingKeys: String, CodingKey {
        case errorId       = "error_id"
        case errorMessage  = "error_message"
        case metadata
    }
}

/// { type, metadata }
struct OnEventPayload: Decodable {
    let type: BenjiConnectEventType
    let metadata: BenjiConnectMetadata
}
