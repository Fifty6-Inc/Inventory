//
//  CoreDataStorage+Write.swift
//  Inventory
//
//  Created by Mikael Weiss on 2/15/21.
//  Copyright © 2021 Fifty6, Inc. All rights reserved.
//

import Foundation
import Persistence

extension CoreDataStorage: StorageWritable {
    
    // MARK: - Save
    
    private func save() throws {
        do { try store.save() }
        catch { throw StorageError.saveFailed }
    }
    
    // MARK: - Items
    
    func addItem(_ storageItem: Storage.Item) throws {
        let storeItem = store.newItem()
        factory.copyItemValues(from: storageItem, to: storeItem)
        try save()
    }
    
    func updateItem(_ storageItem: Storage.Item) throws {
        guard let itemID = storageItem.id else {
            throw StorageError.missingID
        }
        
        guard let storeItem = try store.getItem(with: itemID) else {
            throw StorageError.objectNotFound(itemID)
        }
        
        factory.copyItemValues(from: storageItem, to: storeItem)
        try save()
    }
    
    func deleteItem(with id: UUID) throws {
        do {
            try store.deleteItem(with: id)
        } catch {
            throw StorageError.deleteFailed(id)
        }
        try save()
    }
    
    // MARK: - Projects
    
    func addProject(_ storageProject: Storage.Project) throws {
        let storeProject = store.newProject()
        factory.copyProjectValues(from: storageProject, to: storeProject)
        
        if let projectItems = storageProject.projectItems,
           let projectID = storageProject.id {
            for projectItem in projectItems {
                try addProjectItem(projectItem, toProject: projectID)
            }
        }
        
        try save()
    }
    
    func updateProject(_ storageProject: Storage.Project) throws {
        guard let projectID = storageProject.id else {
            throw StorageError.missingID
        }
        
        guard let storeProject = try store.getProject(with: projectID) else {
            throw StorageError.objectNotFound(projectID)
        }
        
        factory.copyProjectValues(from: storageProject, to: storeProject)
        
        guard let storeProjectItems = storeProject.projectItems?.allObjects as? [Persistence.ProjectItem] else {
            throw StorageError.missingValue
        }
        
        try storageProject.projectItems?.forEach { storageProjectItem in
            let projectItemExists = storeProjectItems.contains { storeProjectItem in
                storageProjectItem.id == storeProjectItem.id
            }
            
            if projectItemExists {
                try updateProjectItem(storageProjectItem)
            } else {
                try addProjectItem(storageProjectItem, toProject: projectID)
            }
        }
        
        try storeProjectItems.forEach { storeProjectItem in
            guard let projectItems = storageProject.projectItems else {
                throw StorageError.missingValue
            }
            let itemRemoved = !projectItems.contains { $0.id == storeProjectItem.id }
            if itemRemoved {
                if let id = storeProjectItem.id {
                    try deleteProjectItem(with: id)
                }
            }
        }
        
        try save()
    }
    
    func deleteProject(with id: UUID) throws {
        do {
            try store.deleteProject(with: id)
        } catch {
            throw StorageError.deleteFailed(id)
        }
        try save()
    }
    
    // MARK: - ProjectItems
    
    private func addProjectItem(_ projectItem: Storage.ProjectItem, toProject projectID: UUID) throws {
        guard let storeProject = try store.getProject(with: projectID) else {
            throw StorageError.objectNotFound(projectID)
        }
        
        let storeProjectItem = store.newProjectItem()
        factory.copyProjectItemValues(from: projectItem, to: storeProjectItem)
        storeProject.addToProjectItems(storeProjectItem)
        try save()
    }
    
    private func updateProjectItem(_ projectItem: Storage.ProjectItem) throws {
        guard let projectItemID = projectItem.id else {
            throw StorageError.missingID
        }
        
        guard let storeProjectItem = try store.getProjectItem(with: projectItemID) else {
            throw StorageError.objectNotFound(projectItemID)
        }
        
        factory.copyProjectItemValues(from: projectItem, to: storeProjectItem)
        try save()
    }
    
    private func deleteProjectItem(with id: UUID) throws {
        do {
            try store.deleteProjectItem(with: id)
        } catch {
            throw StorageError.deleteFailed(id)
        }
        try save()
    }
}
