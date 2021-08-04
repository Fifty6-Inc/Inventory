//
//  ProjectRepositoryTests.swift
//  InventoryTests
//
//  Created by Mikael Weiss on 2/15/21.
//  Copyright © 2021 Fifty6 Incorporated. All rights reserved.
//

import XCTest
@testable import Inventory
import Combine

class ProjectRepositoryTests: XCTestCase {
    
    var repository: ProjectRepository!
    var storageRead: ProjectRepositoryReadableDouble!
    var storageWrite: ProjectRepositoryWritableDouble!
    var toDomain: StorageToDomainTransformer!
    var toStorage: DomainToStorageTransformer!
    
    func testFetchAllProjects() throws {
        // Given
        let id = UUID()
        let date = Date()
        let storageProject = makeStorageProject(
            id: id,
            date: date,
            description: "Something",
            type: "income",
            category: "Some category",
            value: 55)
        storageRead.projectsToReturn = [storageProject]
        
        // When
        let allProjects = try? repository.allProjects()
        
        // Then
        let project = allProjects?.first
        XCTAssertEqual(project?.id, id)
        XCTAssertEqual(project?.date, date)
        XCTAssertEqual(project?.description, "Something")
        XCTAssertEqual(project?.type, .income)
        XCTAssertEqual(project?.category, "Some category")
        XCTAssertEqual(project?.value, 55)
        XCTAssertEqual(allProjects?.count, 1)
    }
    
    func testFetchProject() throws {
        // Given
        let id = UUID()
        storageRead.projectToReturn = makeStorageProject(id: id, description: "Something")
        
        // When
        let project = try? repository.project(withID: id)
        
        // Then
        XCTAssertEqual(project?.id, id)
        XCTAssertEqual(project?.description, "Something")
    }
    
    func testAddProject() throws {
        // Given
        let id = UUID()
        let project = makeProject(id: id)
        
        // When
        try repository.addProject(project)
        
        // Then
        let storageProject = storageWrite.addProject
        XCTAssertEqual(storageProject?.id, id)
    }
    
    func testAddProjectPublishes() throws {
        // Given
        let expectation = self.expectation(description: "Publisher called")
        let id = UUID()
        let project = makeProject(id: id)
        let cancelable =
            repository.updatePublisher
            .delay(for: .milliseconds(1), scheduler: RunLoop.main)
            .sink { action in
                if case .add(let projectID) = action {
                    XCTAssertEqual(projectID, id)
                }
                expectation.fulfill()
            }
        
        // When
        try repository.addProject(project)
        
        // Then
        waitForExpectations(timeout: 1)
        cancelable.cancel()
    }
    
    
    func testUpdateProject() throws {
        // Given
        let id = UUID()
        storageWrite.updateProject = makeStorageProject(id: id, description: "Some old description")
        let project = makeProject(id: id, description: "Some new description")
        
        // When
        try repository.updateProject(project)
        
        // Then
        let storageProject = storageWrite.updateProject
        XCTAssertEqual(storageProject?.id, id)
        XCTAssertEqual(storageProject?.description, "Some new description")
    }
    
    func testUpdateProjectPublishes() throws {
        // Given
        let expectation = self.expectation(description: "Publisher called")
        let id = UUID()
        let project = makeProject(id: id)
        let cancelable =
            repository.updatePublisher
            .delay(for: .milliseconds(1), scheduler: RunLoop.main)
            .sink { action in
                if case .update(let projectID) = action {
                    XCTAssertEqual(projectID, id)
                }
                expectation.fulfill()
            }
        
        // When
        try repository.updateProject(project)
        
        // Then
        waitForExpectations(timeout: 1)
        cancelable.cancel()
    }
    
    func testDeleteProject() throws {
        // Given
        let id = UUID()
        
        // When
        try repository.deleteProject(id)
        
        // Then
        XCTAssertEqual(storageWrite.deleteProjectID, id)
    }
    
    func testDeleteProjectPublishes() throws {
        // Given
        let id = UUID()
        let expectation = self.expectation(description: "Publisher called")
        let cancelable =
            repository.updatePublisher
            .delay(for: .milliseconds(1), scheduler: RunLoop.main)
            .sink { action in
                if case .update(let projectID) = action {
                    XCTAssertEqual(projectID, id)
                }
                expectation.fulfill()
            }
        
        // When
        try repository.deleteProject(id)
        
        // Then
        waitForExpectations(timeout: 1)
        cancelable.cancel()
    }
    
    private func makeStorageProject(
        id: UUID = UUID(),
        date: Date = Date(),
        description: String = "",
        type: String = "income",
        category: String = "",
        value: Decimal = .nan) -> Storage.Project {
        
        Storage.Project(
            id: id,
            date: date,
            description: description,
            type: type,
            category: category,
            value: value)
    }
    
    private func makeProject(
        id: UUID = UUID(),
        date: Date = Date(),
        description: String = "",
        type: ProjectType = .income,
        category: String = "",
        value: Decimal = .nan) -> Project {
        
        Project(
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
        storageRead = ProjectRepositoryReadableDouble()
        storageWrite = ProjectRepositoryWritableDouble()
        repository = MainProjectRepository(
            storageRead: storageRead,
            storageWrite: storageWrite,
            toDomainTransformer: toDomain,
            toStorageTransformer: toStorage)
    }
    
    // MARK: - Doubles
    class ProjectRepositoryReadableDouble: ProjectRepositoryReadable {
        var getProjectID: UUID?
        
        var projectToReturn: Storage.Project?
        var projectsToReturn = [Storage.Project]()
        
        func getProject(with id: UUID) throws -> Storage.Project? {
            projectToReturn
        }
        
        func getAllProjects() throws -> [Storage.Project] {
            projectsToReturn
        }
    }
    
    class ProjectRepositoryWritableDouble: ProjectRepositoryWritable {
        var addProject: Storage.Project?
        var updateProject: Storage.Project?
        var deleteProjectID: UUID?
        
        func addProject(_ storageProject: Storage.Project) throws {
            addProject = storageProject
        }
        
        func updateProject(_ storageProject: Storage.Project) throws {
            updateProject = storageProject
        }
        
        func deleteProject(with id: UUID) throws {
            deleteProjectID = id
        }
    }
}
