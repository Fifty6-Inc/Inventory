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
    
    func testUpdateItem() throws {
        // Given
        let givenID = UUID()
        let storageItem = makeStorageItem(id: givenID, name: "Name", count: nil)
        try storage.addItem(storageItem)
        let newItem = makeStorageItem(id: givenID, name: "New Name", count: 5)
        
        // When
        try storage.updateItem(newItem)
        
        // Then
        let storeItem = try store.getItem(with: givenID)
        XCTAssertEqual(storeItem?.id, givenID)
        XCTAssertEqual(storeItem?.name, "New Name")
        XCTAssertEqual(storeItem?.count, 5)
    }
    
    func testUpdateItemMissingID() {
        // Given
        let storageItem = makeStorageItem(id: nil)
        
        // When/Then
        XCTAssertThrowsError(try storage.updateItem(storageItem))
    }
    
    func testUpdateItemObjectNotFound() {
        // Given
        let randomID = UUID()
        let storageItem = makeStorageItem(id: randomID)
        
        // When/Then
        XCTAssertThrowsError(try storage.updateItem(storageItem)) { error in
            XCTAssertEqual(error as? StorageError, .objectNotFound(randomID))
        }
    }
    
    func testDeleteItem() throws {
        // Given
        let givenID = UUID()
        let storageItem = makeStorageItem(id: givenID)
        try storage.addItem(storageItem)
        XCTAssertNoThrow(try storage.getItem(with: givenID))
        
        // When
        try storage.deleteItem(with: givenID)
        
        // Then
        XCTAssertThrowsError(try storage.getItem(with: givenID))
    }
    
    // MARK: - Helpers
    func makeStorageItem(
        id: UUID? = nil,
        name: String? = nil,
        count: Int64? = nil) -> Storage.Item {
        
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
