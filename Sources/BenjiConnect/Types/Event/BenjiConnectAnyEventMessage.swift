//
//  BenjiConnectAnyEventMessage.swift
//  
//
//  Created by Marta Wilgan on 12/12/25.
//

import Foundation

public enum BenjiConnectEventMessage: Codable, Sendable, Equatable {
    case authSuccess(BenjiConnectAuthSuccessEventData)
    case flowExit(BenjiConnectFlowExitEventData)
    case flowSuccess(BenjiConnectAuthSuccessEventData)
    case event(BenjiConnectEventData)
    case error(BenjiConnectErrorEventData)

    private enum CodingKeys: String, CodingKey {
        case type
        case data
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let type = try container.decode(BenjiConnectEventType.self, forKey: .type)

        switch type {
        case .authSuccess:
            let data = try container.decode(BenjiConnectAuthSuccessEventData.self, forKey: .data)
            self = .authSuccess(data)

        case .flowExit:
            let data = try container.decode(BenjiConnectFlowExitEventData.self, forKey: .data)
            self = .flowExit(data)

        case .flowSuccess:
            let data = try container.decode(BenjiConnectAuthSuccessEventData.self, forKey: .data)
            self = .flowSuccess(data)

        case .event:
            let data = try container.decode(BenjiConnectEventData.self, forKey: .data)
            self = .event(data)

        case .error:
            let data = try container.decode(BenjiConnectErrorEventData.self, forKey: .data)
            self = .error(data)
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        switch self {
        case .authSuccess(let data):
            try container.encode(BenjiConnectEventType.authSuccess, forKey: .type)
            try container.encode(data, forKey: .data)

        case .flowExit(let data):
            try container.encode(BenjiConnectEventType.flowExit, forKey: .type)
            try container.encode(data, forKey: .data)

        case .flowSuccess(let data):
            try container.encode(BenjiConnectEventType.flowSuccess, forKey: .type)
            try container.encode(data, forKey: .data)

        case .event(let data):
            try container.encode(BenjiConnectEventType.event, forKey: .type)
            try container.encode(data, forKey: .data)

        case .error(let data):
            try container.encode(BenjiConnectEventType.error, forKey: .type)
            try container.encode(data, forKey: .data)
        }
    }
}
