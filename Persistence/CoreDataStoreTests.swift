//
//  CoreDataStoreTests.swift
//  Persistence
//
//  Created by Mikael Weiss on 2/18/21.
//

@testable import Persistence
import XCTest

class CoreDataStoreTests: XCTestCase {
    
    var store: CoreDataStore!
    
    override func setUp() {
        super.setUp()
        store = CoreDataStore(storageType: .inMemory)
        try! store.deleteAll()
    }
    
    override func tearDown() {
        try! store.deleteAll()
        super.tearDown()
    }
    
    // MARK: - Save
    
    func testSaveNoChanges() {
        // Given
        
        // When
        XCTAssertNoThrow(try store.save())
        
        // Then
    }
    
    func testSaveHasChanges() {
        // Given
        _ = store.newItem()
        
        // When
        XCTAssertNoThrow(try store.save())
        
        // Then
    }
    
    // MARK: - Delete All
    
    func testDeleteAll() {
        // Given
        var result: Persistence.Item?
        let id = UUID()
        let newEntity = store.newItem()
        newEntity.id = id
        XCTAssertNoThrow(try store.save())
        
        // When
        XCTAssertNoThrow(try store.deleteAll())
        
        // Then
        XCTAssertNoThrow(result = try store.getItem(with: id))
        XCTAssertNil(result)
    }
    
    // MARK: - Item
    
    func testNewItem() {
        // When
        let result = store.newItem()
        
        // Then
        XCTAssertNotNil(result)
    }
    
    func testGetItemWithUnknownID() {
        // Given
        var result: Persistence.Item?
        let randomID = UUID()
        
        // When
        XCTAssertNoThrow(result = try store.getItem(with: randomID))
        
        // Then
        XCTAssertNil(result)
    }
    
    func testGetItemWithKnownID() {
        // Given
        var result: Persistence.Item?
        let id = UUID()
        let newEntity = store.newItem()
        newEntity.id = id
        XCTAssertNoThrow(try store.save())
        
        // When
        XCTAssertNoThrow(result = try store.getItem(with: id))
        
        // Then
        XCTAssertNotNil(result)
        XCTAssertEqual(result?.id, id)
    }
    
    func testDeleteItem() {
        // Given
        var result: Persistence.Item?
        let id = UUID()
        let newEntity = store.newItem()
        newEntity.id = id
        XCTAssertNoThrow(try store.save())
        
        // When
        XCTAssertNoThrow(try store.deleteItem(with: id))
        
        // Then
        XCTAssertNoThrow(result = try store.getItem(with: id))
        XCTAssertNil(result)
    }
    
    func testGetAllItems() throws {
        // Given
        _ = store.newItem()
        _ = store.newItem()
        _ = store.newItem()
        XCTAssertNoThrow(try store.save())
        
        // When
        let entities = try store.getAllItems()
        
        XCTAssertEqual(entities.count, 3)
    }
}
