//
//  DomainToStorageTransformerTests.swift
//  InventoryTests
//
//  Created by Mikael Weiss on 2/15/21.
//  Copyright © 2021 Fifty6, Inc. All rights reserved.
//

import XCTest
@testable import Inventory

class DomainToStorageTransformerTests: XCTestCase {
    
    var factory = DomainToStorageFactory()
    
    // MARK: - Item
    
    func testItem() {
        // Given
        let id = UUID()
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
    
    // MARK: - Project
    
    func testProject() {
        // Given
        let id = UUID()
        let randomID = UUID()
        let domainProject = Project(
            id: id,
            name: "Some name",
            itemIDs: [UUID(), UUID(), randomID, UUID()])
        
        // When
        let project = factory.project(from: domainProject)
        
        // Then
        XCTAssertEqual(project.id, id)
        XCTAssertEqual(project.name, "Some name")
        XCTAssertEqual(project.itemIDs?.count, 4)
        XCTAssertEqual(project.itemIDs?[2], randomID)
    }
}
