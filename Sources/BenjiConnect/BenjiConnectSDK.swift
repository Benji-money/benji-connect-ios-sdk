//
//  BenjiConnectSDK.swift
//  
//
//  Created by Marta Wilgan on 12/12/25.
//

import UIKit

public final class BenjiConnectSDK: NSObject, Sendable {
    private let config: BenjiConnectConfig
    @MainActor private weak var presentedVC: BenjiConnectViewController?

    public init(config: BenjiConnectConfig) {
        self.config = config
        super.init()
    }

    /// Presents the Connect modal.
    @MainActor
    public func open(from presenter: UIViewController, animated: Bool = true) {
        // Basic validation (Swift-friendly). You can hard-fail or just call onError.
        guard !config.token.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            let err = NSError(
                domain: "BenjiConnectSDK",
                code: 1001,
                userInfo: [NSLocalizedDescriptionKey: "BenjiConnectConfig.token is empty"]
            )
            let md = BenjiConnectMetadata(
                context: .init(namespace: BenjiConnectConstants.namespace, version: BenjiConnectConstants.version),
                extras: [:]
            )
            config.onError?(err, "400", md)
            return
        }

        // Avoid presenting twice
        if presentedVC != nil { return }

        let vc = BenjiConnectViewController(config: config) { [weak self] in
            Task { @MainActor in
                self?.close(animated: animated)
            }
        }

        presentedVC = vc
        presenter.present(vc, animated: animated)
    }

    /// Dismisses the Connect modal.
    @MainActor
    public func close(animated: Bool = true) {
        presentedVC?.dismiss(animated: animated)
        presentedVC = nil
    }
}

