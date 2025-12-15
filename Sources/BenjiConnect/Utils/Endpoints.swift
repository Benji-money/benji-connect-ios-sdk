//
//  Endpoints.swift
//  
//
//  Created by Marta Wilgan on 12/15/25.
//

import Foundation

public enum Endpoints {

    private static let devAuthURL = URL(string: "http://localhost:3000")!
    private static let sandboxAuthURL = URL(string: "https://verifyapp-staging.withbenji.com")!
    private static let prodAuthURL = URL(string: "https://verifyapp.withbenji.com")!

    public static func benjiConnectAuthURL(for env: BenjiConnectEnvironment) -> URL {
        switch env {
        case .development: return devAuthURL
        case .sandbox: return sandboxAuthURL
        case .production: return prodAuthURL
        }
    }

    public static func expectedOrigin(for env: BenjiConnectEnvironment) -> String {
        benjiConnectAuthURL(for: env).originString ?? ""
    }
}


