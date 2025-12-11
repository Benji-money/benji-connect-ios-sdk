//
//  BenjiConnect.swift
//  
//
//  Created by Marta Wilgan on 12/11/25.
//

import UIKit

/// Main entry point for the Benji Connect iOS SDK
public final class BenjiConnect {

    public enum BenjiConnectError: Swift.Error {
        case missingToken
    }

    private let config: BenjiConnectConfig

    public init(config: BenjiConnectConfig) throws {
        guard !config.token.isEmpty else {
            throw BenjiConnectError.missingToken
        }
        self.config = config
    }

    /// Presents the Benji Connect flow from a given view controller.
    public func open(from presentingViewController: UIViewController) {
        let vc = BenjiConnectViewController(config: config)
        vc.modalPresentationStyle = .overFullScreen
        presentingViewController.present(vc, animated: true, completion: nil)
    }
}
