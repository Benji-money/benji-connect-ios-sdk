//
//  BenjiConnectOAuthCoordinator.swift
//  BenjiConnect
//
//  Created by Marta Wilgan on 12/16/25.
//

import AuthenticationServices
import UIKit

@MainActor
final class BenjiConnectOAuthCoordinator: NSObject {

    private var authSession: ASWebAuthenticationSession?
    private let presentationAnchor: () -> UIWindow?

    init(presentationAnchor: @escaping () -> UIWindow?) {
        self.presentationAnchor = presentationAnchor
    }

    func start(
        url: URL,
        callbackScheme: String,
        prefersEphemeralSession: Bool = false,
        completion: @escaping (Result<URL, Error>) -> Void
    ) {
        authSession = ASWebAuthenticationSession(
            url: url,
            callbackURLScheme: callbackScheme
        ) { callbackURL, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            guard let callbackURL else {
                completion(.failure(OAuthError.missingCallbackURL))
                return
            }
            completion(.success(callbackURL))
        }

        authSession?.presentationContextProvider = self
        authSession?.prefersEphemeralWebBrowserSession = prefersEphemeralSession
        authSession?.start()
    }
}

// MARK: - Presentation context
extension BenjiConnectOAuthCoordinator: ASWebAuthenticationPresentationContextProviding {
    func presentationAnchor(for session: ASWebAuthenticationSession) -> ASPresentationAnchor {
        presentationAnchor() ?? ASPresentationAnchor()
    }
}

// MARK: - Errors
enum OAuthError: Error {
    case missingCallbackURL
}
