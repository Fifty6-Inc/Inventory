//
//  RepositoryRoot.swift
//  Inventory
//
//  Created by Mikael Weiss on 2/17/21.
//

import Foundation

typealias StorageReadable = ItemRepositoryReadable
typealias StorageWritable = ItemRepositoryWritable

class RepositoryRoot {
    static private var storage: CoreDataStorage {
        InventoryApp.storage
    }
    static private let storageRead = storage
    static private let storageWrite = storage
    
    static var shared = RepositoryRoot()
    
    var ItemRepository = MainItemRepository(
        storageRead: storageRead,
        storageWrite: storageWrite)
}
