//
//  CoreDataStorage+ReadTests.swift
//  InventoryTests
//
//  Created by Mikael Weiss on 2/17/21.
//

import XCTest
@testable import Inventory
import Persistence

class CoreDataStorageReadTests: XCTestCase {
    
    var store: CoreDataStore!
    var storage: CoreDataStorage!
    
    // MARK: - Items
    
    func testGetItem() throws {
        // Given
        let id = UUID()
        let item = store.newItem()
        item.id = id
        
        // When
        let storageItem = try storage.getItem(with: id)
        
        // Then
        XCTAssertEqual(storageItem?.id, id)
    }
    
    func testGetItemObjectNotFound() throws {
        // When/Then
        XCTAssertThrowsError(try storage.getItem(with: UUID()))
    }
    
    func testGetAllItem() throws {
        // Given
        _ = store.newItem()
        _ = store.newItem()
        _ = store.newItem()
        
        // When
        let storageItems = try storage.getAllItems()
        
        // Then
        XCTAssertEqual(storageItems.count, 3)
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
