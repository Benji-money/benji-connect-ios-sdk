//
//  URL+Origin.swift
//  BenjiConnect
//
//  Created by Marta Wilgan on 12/15/25.
//

import Foundation

extension URL {
    var originString: String? {
        guard let scheme = scheme, let host = host else { return nil }
        if let port = port {
            return "\(scheme)://\(host):\(port)"
        }
        return "\(scheme)://\(host)"
    }
}

