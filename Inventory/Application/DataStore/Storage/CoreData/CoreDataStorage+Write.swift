//
//  CoreDataStorage+Write.swift
//  Inventory
//
//  Created by Mikael Weiss on 2/15/21.
//  Copyright © 2021 Fifty6 Incorporated. All rights reserved.
//

import Foundation
import Persistence

extension CoreDataStorage: StorageWritable {
    
    // MARK: - Items
    
    func addItem(_ storageItem: Storage.Item) throws {
        let storeItem = store.newItem()
        factory.copyItemValues(from: storageItem, to: storeItem)
        try store.save()
    }
    
    func updateItem(_ storageItem: Storage.Item) throws {
        guard let itemID = storageItem.id else {
            throw StorageError.missingID
        }
        
        guard let storeItem = try store.getItem(with: itemID) else {
            throw StorageError.objectNotFound(itemID.uuidString)
        }
        
        factory.copyItemValues(from: storageItem, to: storeItem)
        try store.save()
    }
    
    func deleteItem(with id: UUID) throws {
        try store.deleteItem(with: id)
        try store.save()
    }
    
    // MARK: - Projects
    
    func addProject(_ storageProject: Storage.Project) throws {
        let storeProject = store.newProject()
        factory.copyProjectValues(from: storageProject, to: storeProject)
        try store.save()
    }
    
    func updateProject(_ storageProject: Storage.Project) throws {
        guard let projectID = storageProject.id else {
            throw StorageError.missingID
        }
        
        guard let storeProject = try store.getProject(with: projectID) else {
            throw StorageError.objectNotFound(projectID.uuidString)
        }
        
        factory.copyProjectValues(from: storageProject, to: storeProject)
        try store.save()
    }
    
    func deleteProject(with id: UUID) throws {
        try store.deleteProject(with: id)
        try store.save()
    }
}
