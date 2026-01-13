//
//  NSLayoutContraint+Priority.swift
//  BenjiConnect
//
//  Created by Marta Wilgan on 12/19/25.
//

import UIKit

extension NSLayoutConstraint {

    /// Returns the same constraint with an updated priority.
    @discardableResult
    func withPriority(_ priority: UILayoutPriority) -> NSLayoutConstraint {
        self.priority = priority
        return self
    }
}
