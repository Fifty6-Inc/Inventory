//
//  Logging.swift
//  Persistence
//
//  Created by Mikael Weiss on 8/15/21.
//  Copyright © 2021 Fifty6, Inc. All rights reserved.
//

import os.log

extension OSLog {
    static let persistence = OSLog(
        subsystem: "io.fifty6.persistence",
        category: "Persistence")
}
