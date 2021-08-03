//
//  CoreDataStorage.swift
//  Inventory
//
//  Created by Mikael Weiss on 2/15/21.
//

import Foundation
import Persistence

enum StorageError: Error, Equatable {
    case objectNotFound(String)
    case missingID
}

class CoreDataStorage {
    let store: CoreDataStore
    let factory: CoreDataStoreStorage
    
    static var shared = CoreDataStorage()
    
    init(store: CoreDataStore = CoreDataStore.default,
         factory: CoreDataStoreStorage = CoreDataStoreStorageFactory()) {
        self.store = store
        self.factory = factory
    }
}
