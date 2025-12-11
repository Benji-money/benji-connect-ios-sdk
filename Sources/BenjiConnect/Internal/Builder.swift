//
//  ContextBuilder.swift
//  
//
//  Created by Marta Wilgan on 12/11/25.
//

import Foundation

enum Builder {
    
    static func buildConnectURL(
        environment: BenjiConnectEnvironment,
        token: String
    ) -> URL? {
        let base = Endpoints.benjiConnectAuthURL(for: environment)
        var components = URLComponents(url: base, resolvingAgainstBaseURL: false)

        var queryItems = components?.queryItems ?? []
        queryItems.append(URLQueryItem(name: "connect_token", value: token))
        queryItems.append(
            URLQueryItem(
                name: "t",
                value: String(Int(Date().timeIntervalSince1970))
            )
        )
        queryItems.append(URLQueryItem(name: "platform", value: "ios"))

        components?.queryItems = queryItems
        return components?.url
    }

    /// Base context used for all iOS-originated metadata.
    static func buildContext() -> BenjiConnectMetadataContext {
        return BenjiConnectMetadataContext(
            namespace: BenjiConnectConstants.namespace,
            version: BenjiConnectConstants.version
        )
    }

    /// Convenience for building exit metadata on iOS (e.g., tapped-outside dismiss).
    static func buildExitMetadata(
        step: String? = nil,
        trigger: String?
    ) -> BenjiConnectOnExitMetadata {
        return BenjiConnectOnExitMetadata(
            context: buildContext(),
            step: step,
            trigger: trigger
        )
    }

    /// You can add more helpers as needed later, e.g.:
    /// static func buildSuccessMetadata(...) -> BenjiConnectOnSuccessMetadata { ... }
}
