//
//  CoreDataStorage.swift
//  Inventory
//
//  Created by Mikael Weiss on 2/15/21.
//  Copyright © 2021 Fifty6 Incorporated. All rights reserved.
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
