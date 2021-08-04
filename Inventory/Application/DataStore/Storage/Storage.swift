//
//  Storage.swift
//  Inventory
//
//  Created by Mikael Weiss on 2/15/21.
//  Copyright © 2021 Fifty6 Incorporated. All rights reserved.
//

import Foundation

enum Storage {
    struct Item: Codable {
        let id: UUID?
        let name: String?
        let count: Int64?
    }
    struct Project: Codable {
        let id: UUID?
        let name: String?
        let itemIDs: [UUID]?
    }
}
