//
//  LogHelper.swift
//  UserManagement
//
//  Created by Thanh Tri on 06/04/2025.
//

import Foundation

import os

struct LogHelper {
    private static let subsystem = "com.userManagement"
    
    static func logInfo(category: String, message: String) {
        let logger = Logger(subsystem: subsystem, category: category)
        logger.info("\(message, privacy: .public)")
    }

    static func logError(category: String, message: String) {
        let logger = Logger(subsystem: subsystem, category: category)
        logger.error("\(message, privacy: .public)")
    }

    static func logDebug(category: String, message: String) {
        let logger = Logger(subsystem: subsystem, category: category)
        logger.debug("\(message, privacy: .public)")
    }
}
