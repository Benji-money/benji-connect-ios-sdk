//
//  BenjiConnectCallbackType.swift
//  
//
//  Created by Marta Wilgan on 12/11/25.
//

import Foundation

/// Single source of truth for WebKit message handler names.
/// These must stay in sync with the JS `BenjiNativeHandlerNames`.
enum NativeCallbackType: String {
    case success = "benjiConnectSuccess"
    case exit    = "benjiConnectExit"
    case error   = "benjiConnectError"
    case event   = "benjiConnectEvent"
}
