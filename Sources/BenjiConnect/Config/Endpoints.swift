//
//  Endpoints.swift
//  
//
//  Created by Marta Wilgan on 12/11/25.
//

import Foundation

enum Endpoints {

    // TODO: update these to match your real connect URLs
    private static let developmentBaseURL = "https://dev.benji-money.com/connect"
    private static let sandboxBaseURL     = "https://sandbox.benji-money.com/connect"
    private static let productionBaseURL  = "https://benji.money/connect"

    static func benjiConnectAuthURL(for environment: BenjiConnectEnvironment) -> URL {
        let base: String
        switch environment {
        case .development:
            base = developmentBaseURL
        case .sandbox:
            base = sandboxBaseURL
        case .production:
            base = productionBaseURL
        }
        return URL(string: base)!
    }
}
