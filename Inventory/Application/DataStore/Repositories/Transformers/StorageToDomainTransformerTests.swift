//
//  StorageToDomainTransformerTests.swift
//  InventoryTests
//
//  Created by Mikael Weiss on 2/15/21.
//

import XCTest
@testable import Inventory

class StorageToDomainTransformerTests: XCTestCase {
    
    var factory = StorageToDomainFactory()
    
    // MARK: - Item
    func testItem() throws {
        // Given
        let id = UUID()
        let givenDate = Date()
        let storageItem = Storage.Item(
            id: id,
            name: "Some name",
            count: 55)
        
        // When
        let item = try factory.item(from: storageItem)
        
        // Then
        XCTAssertEqual(item.id, id)
        XCTAssertEqual(item.name, "Some name")
        XCTAssertEqual(item.count, 55)
    }
}
