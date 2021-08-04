//
//  DomainToStorageTransformerTests.swift
//  InventoryTests
//
//  Created by Mikael Weiss on 2/15/21.
//  Copyright © 2021 Fifty6 Incorporated. All rights reserved.
//

import XCTest
@testable import Inventory

class DomainToStorageTransformerTests: XCTestCase {
    
    var factory = DomainToStorageFactory()
    
    // MARK: - Item
    
    func testItem() {
        // Given
        let id = UUID()
        let date = Date()
        let domainItem = Item(
            id: id,
            name: "Some name",
            count: 50)
        
        // When
        let item = factory.item(from: domainItem)
        
        // Then
        XCTAssertEqual(item.id, id)
        XCTAssertEqual(item.name, "Some name")
        XCTAssertEqual(item.count, 50)
    }
}
