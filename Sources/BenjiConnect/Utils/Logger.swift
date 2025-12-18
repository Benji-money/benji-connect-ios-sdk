//
//  Logging.swift.swift
//  
//
//  Created by Marta Wilgan on 12/11/25.
//

import Foundation

func log(_ message: @autoclosure () -> String) {
    #if DEBUG
    print(message())
    #endif
}
