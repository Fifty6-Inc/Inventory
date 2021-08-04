//
//  StorageToDomainTransformerTests.swift
//  InventoryTests
//
//  Created by Mikael Weiss on 2/15/21.
//  Copyright © 2021 Fifty6 Incorporated. All rights reserved.
//

import XCTest
@testable import Inventory

class StorageToDomainTransformerTests: XCTestCase {
    
    var factory = StorageToDomainFactory()
    
    // MARK: - Item
    
    func testItem() throws {
        // Given
        let id = UUID()
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
    
    // MARK: - Project
    
    func testProject() throws {
        // Given
        let id = UUID()
        let randomID = UUID()
        let storageProject = Storage.Project(
            id: id,
            name: "Some name",
            itemIDs: [UUID(), UUID(), randomID, UUID()])
        
        // When
        let project = try factory.project(from: storageProject)
        
        // Then
        XCTAssertEqual(project.id, id)
        XCTAssertEqual(project.name, "Some name")
        XCTAssertEqual(project.itemIDs.count, 4)
        XCTAssertEqual(project.itemIDs[2], randomID)
    }
}
