//
//  BenjiConnectError.swift
//  
//
//  Created by Marta Wilgan on 12/11/25.
//

import Foundation

public enum BenjiConnectErrorName: String, Codable {
    case unexpectedError      = "unexpected_error"
    case partnerConnectError  = "partner_connect_error"
}

/// Mirrors your placeholder `'400' | '500'`
public enum BenjiConnectErrorID: String, Codable {
    case badRequest  = "400"
    case serverError = "500"
}
