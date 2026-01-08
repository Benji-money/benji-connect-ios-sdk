//
//  BenjiConnectExitTrigger.swift
//  
//
//  Created by Marta Wilgan on 12/12/25.
//

import Foundation

public enum BenjiConnectExitTrigger: String, Codable, Sendable {
    case actionButtonClicked = "ACTION_BUTTON_CLICKED"
    case backToMerchantClicked = "BACK_TO_MERCHANT_CLICKED" // deprecated on JS side
    case closeButtonClicked = "CLOSE_BUTTON_CLICKED"
    case tappedOutOfBounds = "TAPPED_OUT_OF_BOUNDS"
}
