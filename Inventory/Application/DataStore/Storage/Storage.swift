//
//  Storage.swift
//  Inventory
//
//  Created by Mikael Weiss on 2/15/21.
//

import Foundation

enum Storage {
    struct Item: Codable {
        let id: UUID?
        let name: String?
        let count: Int64?
    }
}
