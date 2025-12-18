//
//  BenjiConnectEventType.swift
//  
//
//  Created by Marta Wilgan on 12/12/25.
//

import Foundation

public enum BenjiConnectEventType: String, Codable, Sendable {
    case authSuccess = "AUTH_SUCCESS"
    case flowExit = "FLOW_EXIT"
    case flowSuccess = "FLOW_SUCCESS"
    case event = "EVENT"
    case error = "ERROR"
}
