//
//  ItemRepositoryTests.swift
//  InventoryTests
//
//  Created by Mikael Weiss on 8/15/21.
//  Copyright © 2021 Fifty6, Inc. All rights reserved.
//

import XCTest
@testable import Inventory
import Combine

class ItemRepositoryTests: XCTestCase {
    
    var repository: ItemRepository!
    var storageRead: ItemRepositoryReadableDouble!
    var storageWrite: ItemRepositoryWritableDouble!
    var toDomain: StorageToDomainTransformer!
    var toStorage: DomainToStorageTransformer!
    
    func testFetchAllItems() throws {
        // Given
        let id = UUID()
        let date = Date()
        let storageItem = makeStorageItem(
            id: id,
            date: date,
            description: "Something",
            type: "income",
            category: "Some category",
            value: 55)
        storageRead.itemsToReturn = [storageItem]
        
        // When
        let allItems = try? repository.allItems()
        
        // Then
        let item = allItems?.first
        XCTAssertEqual(item?.id, id)
        XCTAssertEqual(item?.date, date)
        XCTAssertEqual(item?.description, "Something")
        XCTAssertEqual(item?.type, .income)
        XCTAssertEqual(item?.category, "Some category")
        XCTAssertEqual(item?.value, 55)
        XCTAssertEqual(allItems?.count, 1)
    }
    
    func testFetchItem() throws {
        // Given
        let id = UUID()
        storageRead.itemToReturn = makeStorageItem(id: id, description: "Something")
        
        // When
        let item = try? repository.item(withID: id)
        
        // Then
        XCTAssertEqual(item?.id, id)
        XCTAssertEqual(item?.description, "Something")
    }
    
    func testAddItem() throws {
        // Given
        let id = UUID()
        let item = makeItem(id: id)
        
        // When
        try repository.addItem(item)
        
        // Then
        let storageItem = storageWrite.addItem
        XCTAssertEqual(storageItem?.id, id)
    }
    
    func testAddItemPublishes() throws {
        // Given
        let expectation = self.expectation(description: "Publisher called")
        let id = UUID()
        let item = makeItem(id: id)
        let cancelable =
            repository.updatePublisher
            .delay(for: .milliseconds(1), scheduler: RunLoop.main)
            .sink { action in
                if case .add(let itemID) = action {
                    XCTAssertEqual(itemID, id)
                }
                expectation.fulfill()
            }
        
        // When
        try repository.addItem(item)
        
        // Then
        waitForExpectations(timeout: 1)
        cancelable.cancel()
    }
    
    
    func testUpdateItem() throws {
        // Given
        let id = UUID()
        storageWrite.updateItem = makeStorageItem(id: id, description: "Some old description")
        let item = makeItem(id: id, description: "Some new description")
        
        // When
        try repository.updateItem(item)
        
        // Then
        let storageItem = storageWrite.updateItem
        XCTAssertEqual(storageItem?.id, id)
        XCTAssertEqual(storageItem?.description, "Some new description")
    }
    
    func testUpdateItemPublishes() throws {
        // Given
        let expectation = self.expectation(description: "Publisher called")
        let id = UUID()
        let item = makeItem(id: id)
        let cancelable =
            repository.updatePublisher
            .delay(for: .milliseconds(1), scheduler: RunLoop.main)
            .sink { action in
                if case .update(let itemID) = action {
                    XCTAssertEqual(itemID, id)
                }
                expectation.fulfill()
            }
        
        // When
        try repository.updateItem(item)
        
        // Then
        waitForExpectations(timeout: 1)
        cancelable.cancel()
    }
    
    func testDeleteItem() throws {
        // Given
        let id = UUID()
        
        // When
        try repository.deleteItem(id)
        
        // Then
        XCTAssertEqual(storageWrite.deleteItemID, id)
    }
    
    func testDeleteItemPublishes() throws {
        // Given
        let id = UUID()
        let expectation = self.expectation(description: "Publisher called")
        let cancelable =
            repository.updatePublisher
            .delay(for: .milliseconds(1), scheduler: RunLoop.main)
            .sink { action in
                if case .update(let itemID) = action {
                    XCTAssertEqual(itemID, id)
                }
                expectation.fulfill()
            }
        
        // When
        try repository.deleteItem(id)
        
        // Then
        waitForExpectations(timeout: 1)
        cancelable.cancel()
    }
    
    private func makeStorageItem(
        id: UUID = UUID(),
        date: Date = Date(),
        description: String = "",
        type: String = "income",
        category: String = "",
        value: Decimal = .nan) -> Storage.Item {
        
        Storage.Item(
            id: id,
            date: date,
            description: description,
            type: type,
            category: category,
            value: value)
    }
    
    private func makeItem(
        id: UUID = UUID(),
        date: Date = Date(),
        description: String = "",
        type: ItemType = .income,
        category: String = "",
        value: Decimal = .nan) -> Item {
        
        Item(
            id: id,
            date: date,
            description: description,
            type: type,
            category: category,
            value: value)
    }
    
    // MARK: - Setup
    override func setUp() {
        super.setUp()
        toDomain = StorageToDomainFactory()
        toStorage = DomainToStorageFactory()
        storageRead = ItemRepositoryReadableDouble()
        storageWrite = ItemRepositoryWritableDouble()
        repository = MainItemRepository(
            storageRead: storageRead,
            storageWrite: storageWrite,
            toDomainTransformer: toDomain,
            toStorageTransformer: toStorage)
    }
    
    // MARK: - Doubles
    class ItemRepositoryReadableDouble: ItemRepositoryReadable {
        var getItemID: UUID?
        
        var itemToReturn: Storage.Item?
        var itemsToReturn = [Storage.Item]()
        
        func getItem(with id: UUID) throws -> Storage.Item? {
            itemToReturn
        }
        
        func getAllItems() throws -> [Storage.Item] {
            itemsToReturn
        }
    }
    
    class ItemRepositoryWritableDouble: ItemRepositoryWritable {
        var addItem: Storage.Item?
        var updateItem: Storage.Item?
        var deleteItemID: UUID?
        
        func addItem(_ storageItem: Storage.Item) throws {
            addItem = storageItem
        }
        
        func updateItem(_ storageItem: Storage.Item) throws {
            updateItem = storageItem
        }
        
        func deleteItem(with id: UUID) throws {
            deleteItemID = id
        }
    }
}
