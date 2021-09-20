//
//  CoreDataStorage+ReadTests.swift
//  InventoryTests
//
//  Created by Mikael Weiss on 8/17/21.
//  Copyright © 2021 Fifty6, Inc. All rights reserved.
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
        // Given
        let randomID = UUID()
        
        // When/Then
        XCTAssertThrowsError(try storage.getItem(with: randomID)) { error in
            XCTAssertEqual(error as? StorageError, .objectNotFound(randomID))
        }
    }
    
    func testGetAllItems() throws {
        // Given
        _ = store.newItem()
        _ = store.newItem()
        _ = store.newItem()
        
        // When
        let storageItems = try storage.getAllItems()
        
        // Then
        XCTAssertEqual(storageItems.count, 3)
    }
    
    // MARK: - Projects
    
    func testGetProject() throws {
        // Given
        let id = UUID()
        let project = store.newProject()
        project.id = id
        
        // When
        let storageProject = try storage.getProject(with: id)
        
        // Then
        XCTAssertEqual(storageProject?.id, id)
    }
    
    func testGetProjectObjectNotFound() throws {
        // Given
        let randomID = UUID()
        
        // When/Then
        XCTAssertThrowsError(try storage.getProject(with: randomID)) { error in
            XCTAssertEqual(error as? StorageError, .objectNotFound(randomID))
        }
    }
    
    func testGetAllProjects() throws {
        // Given
        _ = store.newProject()
        _ = store.newProject()
        _ = store.newProject()
        
        // When
        let storageProjects = try storage.getAllProjects()
        
        // Then
        XCTAssertEqual(storageProjects.count, 3)
    }
    
    // MARK: - ProjectItems
    
    func testGetProjectItems() throws {
        // Given
        let id = UUID()
        let projectItem = store.newProjectItem()
        projectItem.id = id
        
        // When
        let storageProjectItem = try storage.getProjectItem(with: id)
        
        // Then
        XCTAssertEqual(storageProjectItem?.id, id)
    }
    
    func testGetProjectItemObjectNotFound() throws {
        // Given
        let randomID = UUID()
        
        // When/Then
        XCTAssertThrowsError(try storage.getProjectItem(with: randomID)) { error in
            XCTAssertEqual(error as? StorageError, .objectNotFound(randomID))
        }
    }
    
    func testGetAllProjectItems() throws {
        // Given
        let item1 = store.newProjectItem()
        let item2 = store.newProjectItem()
        let item3 = store.newProjectItem()
        let project = store.newProject()
        let projectID = UUID()
        project.id = projectID
        project.addToProjectItems([item1, item2, item3])

        // When
        let storageProjectItems = try storage.getAllProjectItems(for: projectID)

        // Then
        XCTAssertEqual(storageProjectItems.count, 3)
    }
    
    func testGetAllProjectItemsThrows() {
        // Given
        let randomID = UUID()
        
        //When/Then
        XCTAssertThrowsError(try storage.getAllProjectItems(for: randomID)) { error in
            XCTAssertEqual(error as? StorageError, .objectNotFound(randomID))
        }
    }
    
    // MARK: - Setup / Teardown
    
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
