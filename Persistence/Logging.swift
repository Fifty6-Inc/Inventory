//
//  Logging.swift
//  Persistence
//
//  Created by Mikael Weiss on 2/15/21.
//

import os.log

extension OSLog {
    static let persistence = OSLog(
        subsystem: "io.fifty6.persistence",
        category: "Persistence")
}
