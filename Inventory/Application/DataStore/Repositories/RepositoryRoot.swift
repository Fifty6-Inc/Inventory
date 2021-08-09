//
//  RepositoryRoot.swift
//  Inventory
//
//  Created by Mikael Weiss on 2/17/21.
//  Copyright © 2021 Fifty6 Incorporated. All rights reserved.
//

import Foundation

typealias StorageReadable = ItemRepositoryReadable & ProjectRepositoryReadable & ProjectItemRepositoryReadable
typealias StorageWritable = ItemRepositoryWritable & ProjectRepositoryWritable & ProjectItemRepositoryWritable

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
