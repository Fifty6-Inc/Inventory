//
//  CoreDataStoreStorageFactoryTests.swift
//  InventoryTests
//
//  Created by Mikael Weiss on 2/15/21.
//  Copyright © 2021 Fifty6 Incorporated. All rights reserved.
//

import XCTest
@testable import Inventory
import Persistence

class CoreDataStoreStorageFactoryTests: XCTestCase {
    
    var factory = CoreDataStoreStorageFactory()
    var store = CoreDataStore(storageType: .inMemory)
    
    func testItem() {
        // Given
        let givenDate = Date()
        
        let storeItem = store.newItem()
        storeItem.id = UUID(uuidString: "123E4567-E89B-12D3-A456-426655440000")
        storeItem.name = "Some name"
        storeItem.count = 45
        
        // When
        let storageItem = factory.item(from: storeItem)
        
        XCTAssertEqual(storageItem.id, UUID(uuidString: "123E4567-E89B-12D3-A456-426655440000"))
        XCTAssertEqual(storageItem.name, "Some name")
        XCTAssertEqual(storageItem.count, 45)
    }
}
