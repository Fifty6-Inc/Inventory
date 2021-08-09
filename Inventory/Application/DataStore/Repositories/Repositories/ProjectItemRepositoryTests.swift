//
//  ProjectItemRepositoryTests.swift
//  InventoryTests
//
//  Created by Mikael Weiss on 2/15/21.
//  Copyright © 2021 Fifty6 Incorporated. All rights reserved.
//

import XCTest
@testable import Inventory
import Combine

class ProjectItemRepositoryTests: XCTestCase {
    
    var repository: ProjectItemRepository!
    var storageRead: ProjectItemRepositoryReadableDouble!
    var storageWrite: ProjectItemRepositoryWritableDouble!
    var toDomain: StorageToDomainTransformer!
    var toStorage: DomainToStorageTransformer!
    
    func testFetchAllProjectItems() throws {
        // Given
        let id = UUID()
        let date = Date()
        let storageProjectItem = makeStorageProjectItem(
            id: id,
            date: date,
            description: "Something",
            type: "income",
            category: "Some category",
            value: 55)
        storageRead.projectItemsToReturn = [storageProjectItem]
        
        // When
        let allProjectItems = try? repository.allProjectItems()
        
        // Then
        let projectItem = allProjectItems?.first
        XCTAssertEqual(projectItem?.id, id)
        XCTAssertEqual(projectItem?.date, date)
        XCTAssertEqual(projectItem?.description, "Something")
        XCTAssertEqual(projectItem?.type, .income)
        XCTAssertEqual(projectItem?.category, "Some category")
        XCTAssertEqual(projectItem?.value, 55)
        XCTAssertEqual(allProjectItems?.count, 1)
    }
    
    func testFetchProjectItem() throws {
        // Given
        let id = UUID()
        storageRead.projectItemToReturn = makeStorageProjectItem(id: id, description: "Something")
        
        // When
        let projectItem = try? repository.projectItem(withID: id)
        
        // Then
        XCTAssertEqual(projectItem?.id, id)
        XCTAssertEqual(projectItem?.description, "Something")
    }
    
    func testAddProjectItem() throws {
        // Given
        let id = UUID()
        let projectItem = makeProjectItem(id: id)
        
        // When
        try repository.addProjectItem(projectItem)
        
        // Then
        let storageProjectItem = storageWrite.addProjectItem
        XCTAssertEqual(storageProjectItem?.id, id)
    }
    
    func testAddProjectItemPublishes() throws {
        // Given
        let expectation = self.expectation(description: "Publisher called")
        let id = UUID()
        let projectItem = makeProjectItem(id: id)
        let cancelable =
            repository.updatePublisher
            .delay(for: .milliseconds(1), scheduler: RunLoop.main)
            .sink { action in
                if case .add(let projectItemID) = action {
                    XCTAssertEqual(projectItemID, id)
                }
                expectation.fulfill()
            }
        
        // When
        try repository.addProjectItem(projectItem)
        
        // Then
        waitForExpectations(timeout: 1)
        cancelable.cancel()
    }
    
    
    func testUpdateProjectItem() throws {
        // Given
        let id = UUID()
        storageWrite.updateProjectItem = makeStorageProjectItem(id: id, description: "Some old description")
        let projectItem = makeProjectItem(id: id, description: "Some new description")
        
        // When
        try repository.updateProjectItem(projectItem)
        
        // Then
        let storageProjectItem = storageWrite.updateProjectItem
        XCTAssertEqual(storageProjectItem?.id, id)
        XCTAssertEqual(storageProjectItem?.description, "Some new description")
    }
    
    func testUpdateProjectItemPublishes() throws {
        // Given
        let expectation = self.expectation(description: "Publisher called")
        let id = UUID()
        let projectItem = makeProjectItem(id: id)
        let cancelable =
            repository.updatePublisher
            .delay(for: .milliseconds(1), scheduler: RunLoop.main)
            .sink { action in
                if case .update(let projectItemID) = action {
                    XCTAssertEqual(projectItemID, id)
                }
                expectation.fulfill()
            }
        
        // When
        try repository.updateProjectItem(projectItem)
        
        // Then
        waitForExpectations(timeout: 1)
        cancelable.cancel()
    }
    
    func testDeleteProjectItem() throws {
        // Given
        let id = UUID()
        
        // When
        try repository.deleteProjectItem(id)
        
        // Then
        XCTAssertEqual(storageWrite.deleteProjectItemID, id)
    }
    
    func testDeleteProjectItemPublishes() throws {
        // Given
        let id = UUID()
        let expectation = self.expectation(description: "Publisher called")
        let cancelable =
            repository.updatePublisher
            .delay(for: .milliseconds(1), scheduler: RunLoop.main)
            .sink { action in
                if case .update(let projectItemID) = action {
                    XCTAssertEqual(projectItemID, id)
                }
                expectation.fulfill()
            }
        
        // When
        try repository.deleteProjectItem(id)
        
        // Then
        waitForExpectations(timeout: 1)
        cancelable.cancel()
    }
    
    private func makeStorageProjectItem(
        id: UUID = UUID(),
        date: Date = Date(),
        description: String = "",
        type: String = "income",
        category: String = "",
        value: Decimal = .nan) -> Storage.ProjectItem {
        
        Storage.ProjectItem(
            id: id,
            date: date,
            description: description,
            type: type,
            category: category,
            value: value)
    }
    
    private func makeProjectItem(
        id: UUID = UUID(),
        date: Date = Date(),
        description: String = "",
        type: ProjectItemType = .income,
        category: String = "",
        value: Decimal = .nan) -> ProjectItem {
        
        ProjectItem(
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
        storageRead = ProjectItemRepositoryReadableDouble()
        storageWrite = ProjectItemRepositoryWritableDouble()
        repository = MainProjectItemRepository(
            storageRead: storageRead,
            storageWrite: storageWrite,
            toDomainTransformer: toDomain,
            toStorageTransformer: toStorage)
    }
    
    // MARK: - Doubles
    class ProjectItemRepositoryReadableDouble: ProjectItemRepositoryReadable {
        var getProjectItemID: UUID?
        
        var projectItemToReturn: Storage.ProjectItem?
        var projectItemsToReturn = [Storage.ProjectItem]()
        
        func getProjectItem(with id: UUID) throws -> Storage.ProjectItem? {
            projectItemToReturn
        }
        
        func getAllProjectItems() throws -> [Storage.ProjectItem] {
            projectItemsToReturn
        }
    }
    
    class ProjectItemRepositoryWritableDouble: ProjectItemRepositoryWritable {
        var addProjectItem: Storage.ProjectItem?
        var updateProjectItem: Storage.ProjectItem?
        var deleteProjectItemID: UUID?
        
        func addProjectItem(_ storageProjectItem: Storage.ProjectItem) throws {
            addProjectItem = storageProjectItem
        }
        
        func updateProjectItem(_ storageProjectItem: Storage.ProjectItem) throws {
            updateProjectItem = storageProjectItem
        }
        
        func deleteProjectItem(with id: UUID) throws {
            deleteProjectItemID = id
        }
    }
}
