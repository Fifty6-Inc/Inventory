//
//  ProjectItemRepository.swift
//  Inventory
//
//  Created by Mikael Weiss on 2/15/21.
//  Copyright © 2021 Fifty6 Incorporated. All rights reserved.
//

import Foundation
import Combine

protocol ProjectItemRepository {
    func allProjectItems() throws -> [ProjectItem]
    func projectItem(withID: UUID) throws -> ProjectItem?
    
    func addProjectItem(_ projectItem: ProjectItem) throws
    func updateProjectItem(_ projectItem: ProjectItem) throws
    func deleteProjectItem(_ id: UUID) throws
    
    var updatePublisher: RepositoryPublisher { get }
}

protocol ProjectItemRepositoryReadable {
    func getProjectItem(with id: UUID) throws -> Storage.ProjectItem?
    func getAllProjectItems() throws -> [Storage.ProjectItem]
}
protocol ProjectItemRepositoryWritable {
    func addProjectItem(_ storageProjectItem: Storage.ProjectItem) throws
    func updateProjectItem(_ storageProjectItem: Storage.ProjectItem) throws
    func deleteProjectItem(with id: UUID) throws
}

class MainProjectItemRepository: ProjectItemRepository {
    
    private let subject = PassthroughSubject<RepositoryAction, Never>()
    var updatePublisher: RepositoryPublisher {
        subject.eraseToAnyPublisher()
    }
    
    private let storageRead: ProjectItemRepositoryReadable
    private let storageWrite: ProjectItemRepositoryWritable
    private let toDomain: StorageToDomainTransformer
    private let toStorage: DomainToStorageTransformer
    
    init(storageRead: ProjectItemRepositoryReadable,
         storageWrite: ProjectItemRepositoryWritable,
         toDomainTransformer: StorageToDomainTransformer = StorageToDomainFactory(),
         toStorageTransformer: DomainToStorageTransformer = DomainToStorageFactory()) {
        
        self.storageRead = storageRead
        self.storageWrite = storageWrite
        self.toDomain = toDomainTransformer
        self.toStorage = toStorageTransformer
    }
    
    func allProjectItems() throws -> [ProjectItem] {
        guard let allProjectItems = try? storageRead.getAllProjectItems() else { return [] }
        return allProjectItems.compactMap { try? toDomain.projectItem(from: $0) }
    }
    
    func projectItem(withID: UUID) throws -> ProjectItem? {
        guard let storageProjectItem = try storageRead.getProjectItem(with: withID) else { return nil }
        return try toDomain.projectItem(from: storageProjectItem)
    }
    
    func addProjectItem(_ projectItem: ProjectItem) throws {
        let storageProjectItem = toStorage.projectItem(from: projectItem)
        try storageWrite.addProjectItem(storageProjectItem)
        subject.send(.add(projectItem.id))
    }
    
    func updateProjectItem(_ projectItem: ProjectItem) throws {
        let storageProjectItem = toStorage.projectItem(from: projectItem)
        try storageWrite.updateProjectItem(storageProjectItem)
        subject.send(.update(projectItem.id))
    }
    
    func deleteProjectItem(_ id: UUID) throws {
        try storageWrite.deleteProjectItem(with: id)
        subject.send(.delete(id))
    }
}
