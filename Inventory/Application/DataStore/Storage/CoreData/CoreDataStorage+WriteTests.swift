//
//  CoreDataStorage+WriteTests.swift
//  InventoryTests
//
//  Created by Mikael Weiss on 2/17/21.
//  Copyright © 2021 Fifty6 Incorporated. All rights reserved.
//

import XCTest
@testable import Inventory
import Persistence

class CoreDataStorageWriteTests: XCTestCase {
    
    var store: CoreDataStore!
    var storage: CoreDataStorage!
    
    // MARK: - Items
    
    func testAddItem() throws {
        // Given
        let id = UUID()
        let date = Date()
        let storageItem = makeStorageItem(
            id: id,
            name: "Some name",
            count: 54)
        
        // When
        try storage.addItem(storageItem)
        
        // Then
        let storeItems = try store.getAllItems()
        let storeItem = try store.getItem(with: id)
        XCTAssertEqual(storeItem?.id, id)
        XCTAssertEqual(storeItem?.name, "Some name")
        XCTAssertEqual(storeItem?.count, 54)
        XCTAssertEqual(storeItems.count, 1)
    }
    
    func testUpdateItemMissingID() {
        // Given
        let storageItem = makeStorageItem(id: nil)
        
        // When/Then
        XCTAssertThrowsError(try storage.updateItem(storageItem))
    }
    
    // MARK: - Helpers
    func makeStorageItem(
        id: UUID? = nil,
        name: String? = nil,
        count: Int? = nil) -> Storage.Item {
        
        Storage.Item(
            id: id,
            name: name,
            count: count)
    }
    
    // MARK: - setUp / tearDown
    
    override func setUp() {
        super.setUp()
        store = CoreDataStore(storageType: .inMemory)
        storage = CoreDataStorage(store: store)
        try? store.deleteAll()
    }
    
    override func tearDown() {
        try? store.deleteAll()
        super.tearDown()
    }
}
