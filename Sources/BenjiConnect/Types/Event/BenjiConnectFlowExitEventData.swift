//
//  BenjiConnectFlowExitEventData.swift
//  
//
//  Created by Marta Wilgan on 12/12/25.
//

import Foundation

public struct BenjiConnectFlowExitEventData: Codable, Sendable, Equatable {
    public let step: String
    public let trigger: BenjiConnectExitTrigger

    public init(step: String, trigger: BenjiConnectExitTrigger) {
        self.step = step
        self.trigger = trigger
    }
}
