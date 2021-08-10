//
//  ProjectRepository.swift
//  Inventory
//
//  Created by Mikael Weiss on 2/15/21.
//  Copyright © 2021 Fifty6 Incorporated. All rights reserved.
//

import Foundation
import Combine

protocol ProjectRepository {
    func allProjects() throws -> [Project]
    func project(withID: UUID) throws -> Project?
    
    func addProject(_ project: Project) throws
    func updateProject(_ project: Project) throws
    func deleteProject(_ id: UUID) throws
    
    var updatePublisher: RepositoryPublisher { get }
}

protocol ProjectRepositoryReadable {
    func getProject(with id: UUID) throws -> Storage.Project?
    func getAllProjects() throws -> [Storage.Project]
}
protocol ProjectRepositoryWritable {
    func addProject(_ storageProject: Storage.Project) throws
    func updateProject(_ storageProject: Storage.Project) throws
    func deleteProject(with id: UUID) throws
}

class MainProjectRepository: ProjectRepository {
    
    private let subject = PassthroughSubject<RepositoryAction, Never>()
    var updatePublisher: RepositoryPublisher {
        subject.eraseToAnyPublisher()
    }
    
    private let storageRead: ProjectRepositoryReadable
    private let storageWrite: ProjectRepositoryWritable
    private let toDomain: StorageToDomainTransformer
    private let toStorage: DomainToStorageTransformer
    
    init(storageRead: ProjectRepositoryReadable,
         storageWrite: ProjectRepositoryWritable,
         toDomainTransformer: StorageToDomainTransformer = StorageToDomainFactory(),
         toStorageTransformer: DomainToStorageTransformer = DomainToStorageFactory()) {
        
        self.storageRead = storageRead
        self.storageWrite = storageWrite
        self.toDomain = toDomainTransformer
        self.toStorage = toStorageTransformer
    }
    
    func allProjects() throws -> [Project] {
        let allProjects = try storageRead.getAllProjects()
        return try allProjects.compactMap { try toDomain.project(from: $0) }
    }
    
    func project(withID: UUID) throws -> Project? {
        guard let storageProject = try storageRead.getProject(with: withID) else { return nil }
        return try toDomain.project(from: storageProject)
    }
    
    func addProject(_ project: Project) throws {
        let storageProject = toStorage.project(from: project)
        try storageWrite.addProject(storageProject)
        subject.send(.add(project.id))
    }
    
    func updateProject(_ project: Project) throws {
        let storageProject = toStorage.project(from: project)
        try storageWrite.updateProject(storageProject)
        subject.send(.update(project.id))
    }
    
    func deleteProject(_ id: UUID) throws {
        try storageWrite.deleteProject(with: id)
        subject.send(.delete(id))
    }
}
