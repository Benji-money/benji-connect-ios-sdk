//
//  BenjiConnectAuthAction.swift
//  
//
//  Created by Marta Wilgan on 12/12/25.
//

import Foundation

public enum BenjiConnectAuthAction: String, Codable, Sendable {
    case connect = "connect"
    case transfer = "transfer"
    case redeem = "redeem"
}
