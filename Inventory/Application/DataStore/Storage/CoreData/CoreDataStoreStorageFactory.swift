//
//  CoreDataStorageFactory.swift
//  Inventory
//
//  Created by Mikael Weiss on 2/15/21.
//  Copyright © 2021 Fifty6 Incorporated. All rights reserved.
//

import Foundation
import Persistence

protocol CoreDataStoreStorage {
    // Core Data Store -> Storage
    func item(from storeItem: Persistence.Item) -> Storage.Item
    func project(from storeProject: Persistence.Project) -> Storage.Project
    
    // Storage -> Core Data Store
    // The store does the actual creation. We just copy values here.
    func copyItemValues(from item: Storage.Item, to storeItem: Persistence.Item)
    func copyProjectValues(from project: Storage.Project, to storeProject: Persistence.Project)
}

class CoreDataStoreStorageFactory: CoreDataStoreStorage {
    // MARK: - Core Data Store - Storage
    
    func item(from storeItem: Persistence.Item) -> Storage.Item {
        Storage.Item(
            id: storeItem.id,
            name: storeItem.name,
            count: storeItem.count)
    }
    
    func project(from storeProject: Persistence.Project) -> Storage.Project {
        let stringIDs = storeProject.itemIDs
        let arrayOfStrings = stringIDs?.components(separatedBy: ",")
        let itemIDs = arrayOfStrings?.map { UUID(uuidString: $0)! }
        return Storage.Project(
            id: storeProject.id,
            name: storeProject.name,
            itemIDs: itemIDs)
    }
    
    // MARK: - Storage -> Core Data Store
    func copyItemValues(from item: Storage.Item, to storeItem: Persistence.Item) {
        storeItem.id = item.id
        storeItem.name = item.name
        storeItem.count = item.count ?? 0
    }
    
    func copyProjectValues(from project: Storage.Project, to storeProject: Persistence.Project) {
        storeProject.id = project.id
        storeProject.name = project.name
        storeProject.itemIDs = project.itemIDs?.map { $0.uuidString }.joined(separator: ",")
    }
}
