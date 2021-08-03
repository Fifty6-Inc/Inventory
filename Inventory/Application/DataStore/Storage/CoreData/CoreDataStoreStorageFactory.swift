//
//  CoreDataStorageFactory.swift
//  Inventory
//
//  Created by Mikael Weiss on 2/15/21.
//

import Foundation
import Persistence

protocol CoreDataStoreStorage {
    // Core Data Store -> Storage
    func item(from storeItem: Persistence.Item) -> Storage.Item
    
    // Storage -> Core Data Store
    // The store does the actual creation. We just copy values here.
    func copyItemValues(from item: Storage.Item, to storeItem: Persistence.Item)
}

class CoreDataStoreStorageFactory: CoreDataStoreStorage {
    // MARK: - Core Data Store - Storage
    
    func item(from storeItem: Persistence.Item) -> Storage.Item {
        Storage.Item(
            id: storeItem.id,
            name: storeItem.name,
            count: storeItem.count)
    }
    
    // MARK: - Storage -> Core Data Store
    func copyItemValues(from item: Storage.Item, to storeItem: Persistence.Item) {
        storeItem.id = item.id
    }
}
