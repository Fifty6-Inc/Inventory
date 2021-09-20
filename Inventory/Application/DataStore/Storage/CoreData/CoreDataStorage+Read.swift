//
//  CoreDataStorage+Read.swift
//  Inventory
//
//  Created by Mikael Weiss on 8/15/21.
//  Copyright © 2021 Fifty6, Inc. All rights reserved.
//

import Foundation
import Persistence

extension CoreDataStorage: StorageReadable {
    
    // MARK: - Items
    
    func getItem(with id: UUID) throws -> Storage.Item? {
        guard let persistenceItem = try? store.getItem(with: id)
        else {
            throw StorageError.objectNotFound(id)
        }
        return factory.item(from: persistenceItem)
    }
    
    func getAllItems() throws -> [Storage.Item] {
        guard let storeItems = try? store.getAllItems()
        else {
            throw StorageError.storeThrewError
        }
        return storeItems.map { factory.item(from: $0) }
    }
    
    // MARK: - Projects
    
    func getProject(with id: UUID) throws -> Storage.Project? {
        guard let persistenceProject = try? store.getProject(with: id)
        else {
            throw StorageError.objectNotFound(id)
        }
        return factory.project(from: persistenceProject)
    }
    
    func getAllProjects() throws -> [Storage.Project] {
        guard let storeItems = try? store.getAllProjects()
        else {
            throw StorageError.storeThrewError
        }
        return storeItems.map { factory.project(from: $0) }
    }
    
    // MARK: - ProjectItems
    
    func getProjectItem(with id: UUID) throws -> Storage.ProjectItem? {
        guard let persistenceProjectItem = try? store.getProjectItem(with: id)
        else {
            throw StorageError.objectNotFound(id)
        }
        return factory.projectItem(from: persistenceProjectItem)
    }
    
    func getAllProjectItems(for project: UUID) throws -> [Storage.ProjectItem] {
        guard let storeProject = try? store.getProject(with: project) else {
            throw StorageError.objectNotFound(project)
        }
        let projectItems = storeProject.projectItems?.allObjects as? [Persistence.ProjectItem]
        return projectItems?.map(factory.projectItem(from:)) ?? []
    }
}
