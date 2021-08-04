//
//  CoreDataStorage+Write.swift
//  Inventory
//
//  Created by Mikael Weiss on 2/15/21.
//  Copyright © 2021 Fifty6 Incorporated. All rights reserved.
//

import Foundation
import Persistence

extension CoreDataStorage: StorageWritable {
    
    // MARK: - Items
    
    func addItem(_ storageItem: Storage.Item) throws {
        let storeItem = store.newItem()
        factory.copyItemValues(from: storageItem, to: storeItem)
        try store.save()
    }
    
    func updateItem(_ storageItem: Storage.Item) throws {
        guard let itemID = storageItem.id else {
            throw StorageError.missingID
        }
        
        guard let storeItem = try store.getItem(with: itemID) else {
            throw StorageError.objectNotFound(itemID.uuidString)
        }
        
        factory.copyItemValues(from: storageItem, to: storeItem)
        try store.save()
    }
    
    func deleteItem(with id: UUID) throws {
        try store.deleteItem(with: id)
        try store.save()
    }
}
