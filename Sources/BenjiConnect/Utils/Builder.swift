//
//  ContextBuilder.swift
//  
//
//  Created by Marta Wilgan on 12/11/25.
//

import Foundation

enum Builder {

    static func buildConnectURL(environment: BenjiConnectEnvironment, token: String) -> URL? {
        let base = Endpoints.benjiConnectAuthURL(for: environment)
        var components = URLComponents(url: base, resolvingAgainstBaseURL: false)

        var queryItems = components?.queryItems ?? []
        queryItems.append(URLQueryItem(name: "connect_token", value: token))
        queryItems.append(URLQueryItem(name: "t", value: String(Int(Date().timeIntervalSince1970))))
        queryItems.append(URLQueryItem(name: "platform", value: "ios"))

        components?.queryItems = queryItems
        return components?.url
    }

    static func buildContext() -> BenjiConnectMetadata.Context {
        .init(namespace: BenjiConnectConstants.namespace, version: BenjiConnectConstants.version)
    }
}
