//
//  CoreDataStorage+Read.swift
//  Inventory
//
//  Created by Mikael Weiss on 2/15/21.
//  Copyright © 2021 Fifty6 Incorporated. All rights reserved.
//

import Foundation
import Persistence

extension CoreDataStorage: StorageReadable {
    
    // MARK: - Items
    
    func getItem(with id: UUID) throws -> Storage.Item? {
        guard let persistenceItem = try? store.getItem(with: id)
        else {
            throw StorageError.objectNotFound(id.uuidString)
        }
        return factory.item(from: persistenceItem)
    }
    
    func getAllItems() throws -> [Storage.Item] {
        let storeItems = try store.getAllItems()
        return storeItems.map { factory.item(from: $0) }
    }
}
