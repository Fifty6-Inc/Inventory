//
//  RepositoryRoot.swift
//  Inventory
//
//  Created by Mikael Weiss on 8/17/21.
//  Copyright © 2021 Fifty6, Inc. All rights reserved.
//

import Foundation

typealias StorageReadable = ItemRepositoryReadable & ProjectRepositoryReadable
typealias StorageWritable = ItemRepositoryWritable & ProjectRepositoryWritable

class RepositoryRoot {
    static private var storage: CoreDataStorage {
        InventoryApp.storage
    }
    static private let storageRead = storage
    static private let storageWrite = storage
    
    static var shared = RepositoryRoot()
    private init() {}
    
    var itemRepository = MainItemRepository(
        storageRead: storageRead,
        storageWrite: storageWrite)
    var projectRepository = MainProjectRepository(
        storageRead: storageRead,
        storageWrite: storageWrite)
}
