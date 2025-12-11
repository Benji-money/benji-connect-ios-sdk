//
//  NativeCallbackEnvelope.swift
//  
//
//  Created by Marta Wilgan on 12/11/25.
//

import Foundation

/// Lightweight envelope used for routing: we first decode this
/// to know which event type we’re dealing with.
struct BasicCallbackEnvelope: Decodable {
    let type: BenjiConnectEventType
}

/// Fully typed envelope for a particular payload type.
struct NativeCallbackEnvelope<Payload: Decodable>: Decodable {
    let type: BenjiConnectEventType
    let data: Payload
}

/// Payload for FLOW_SUCCESS (and FLOW_SUCCESS-like) events:
/// mirrors the JS `BenjiConnectOnSuccessData` structure:
/// { token: string, metadata: BenjiConnectOnSuccessMetadata }
struct OnSuccessPayload: Decodable {
    let token: String
    let metadata: BenjiConnectOnSuccessMetadata
}

/// Payload for FLOW_EXIT:
/// { metadata: BenjiConnectOnExitMetadata }
struct OnExitPayload: Decodable {
    let metadata: BenjiConnectOnExitMetadata
}

/// Payload for ERROR:
/// { error_id: string, error_message: string, metadata: BenjiConnectMetadata }
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

/// Payload for generic EVENT / AUTH_SUCCESS propagation:
/// { metadata: BenjiConnectMetadata }
struct OnEventPayload: Decodable {
    let metadata: BenjiConnectMetadata
}
