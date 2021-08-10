//
//  CoreDataStoreTests.swift
//  Persistence
//
//  Created by Mikael Weiss on 2/18/21.
//  Copyright © 2021 Fifty6 Incorporated. All rights reserved.
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
        
        // When/Then
        XCTAssertNoThrow(try store.save())
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
    
    // MARK: - Project
    
    func testNewProject() {
        // When
        let result = store.newProject()
        
        // Then
        XCTAssertNotNil(result)
    }
    
    func testGetProjectWithUnknownID() {
        // Given
        var result: Persistence.Project?
        let randomID = UUID()
        
        // When
        XCTAssertNoThrow(result = try store.getProject(with: randomID))
        
        // Then
        XCTAssertNil(result)
    }
    
    func testGetProjectWithKnownID() {
        // Given
        var result: Persistence.Project?
        let id = UUID()
        let newEntity = store.newProject()
        newEntity.id = id
        XCTAssertNoThrow(try store.save())
        
        // When
        XCTAssertNoThrow(result = try store.getProject(with: id))
        
        // Then
        XCTAssertNotNil(result)
        XCTAssertEqual(result?.id, id)
    }
    
    func testDeleteProject() {
        // Given
        var result: Persistence.Project?
        let id = UUID()
        let newEntity = store.newProject()
        newEntity.id = id
        XCTAssertNoThrow(try store.save())
        
        // When
        XCTAssertNoThrow(try store.deleteProject(with: id))
        
        // Then
        XCTAssertNoThrow(result = try store.getProject(with: id))
        XCTAssertNil(result)
    }
    
    func testGetAllProjects() throws {
        // Given
        _ = store.newProject()
        _ = store.newProject()
        _ = store.newProject()
        XCTAssertNoThrow(try store.save())
        
        // When
        let entities = try store.getAllProjects()
        
        XCTAssertEqual(entities.count, 3)
    }
    
    // MARK: - ProjectItem
    
    func testNewProjectItem() {
        // When
        let result = store.newProjectItem()
        
        // Then
        XCTAssertNotNil(result)
    }
    
    func testGetProjectItemWithUnknownID() {
        // Given
        var result: Persistence.ProjectItem?
        let randomID = UUID()
        
        // When
        XCTAssertNoThrow(result = try store.getProjectItem(with: randomID))
        
        // Then
        XCTAssertNil(result)
    }
    
    func testGetProjectItemWithKnownID() {
        // Given
        var result: Persistence.ProjectItem?
        let id = UUID()
        let newEntity = store.newProjectItem()
        newEntity.id = id
        XCTAssertNoThrow(try store.save())
        
        // When
        XCTAssertNoThrow(result = try store.getProjectItem(with: id))
        
        // Then
        XCTAssertNotNil(result)
        XCTAssertEqual(result?.id, id)
    }
    
    func testDeleteProjectItem() {
        // Given
        var result: Persistence.ProjectItem?
        let id = UUID()
        let newEntity = store.newProjectItem()
        newEntity.id = id
        XCTAssertNoThrow(try store.save())
        
        // When
        XCTAssertNoThrow(try store.deleteProjectItem(with: id))
        
        // Then
        XCTAssertNoThrow(result = try store.getProjectItem(with: id))
        XCTAssertNil(result)
    }
    
    func testGetAllProjectItems() throws {
        // Given
        _ = store.newProjectItem()
        _ = store.newProjectItem()
        _ = store.newProjectItem()
        XCTAssertNoThrow(try store.save())
        
        // When
        let entities = try store.getAllProjectItems()
        
        XCTAssertEqual(entities.count, 3)
    }
}
