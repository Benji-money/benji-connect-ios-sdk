//
//  BenjiConnectExitTrigger.swift
//  
//
//  Created by Marta Wilgan on 12/11/25.
//

import Foundation

/// Mirrors `BenjiConnectExitTrigger` in TS
public enum BenjiConnectExitTrigger: String, Codable {
    case actionButtonClicked     = "ACTION_BUTTON_CLICKED"
    case backToMerchantClicked   = "BACK_TO_MERCHANT_CLICKED" // deprecated
    case closeButtonClicked      = "CLOSE_BUTTON_CLICKED"
    case tappedOutOfBounds       = "TAPPED_OUT_OF_BOUNDS"
}
