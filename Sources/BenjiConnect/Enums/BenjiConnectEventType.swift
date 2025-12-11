//
//  BenjiConnectEventType.swift
//  
//
//  Created by Marta Wilgan on 12/11/25.
//

import Foundation

public enum BenjiConnectEventType: String, Codable {
    case authSuccess = "AUTH_SUCCESS"
    case flowExit    = "FLOW_EXIT"
    case flowSuccess = "FLOW_SUCCESS"
    case event       = "EVENT"
    case error       = "ERROR"
}
