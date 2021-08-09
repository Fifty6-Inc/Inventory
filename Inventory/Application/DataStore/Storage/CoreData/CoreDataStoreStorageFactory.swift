//
//  CoreDataStorageFactory.swift
//  Inventory
//
//  Created by Mikael Weiss on 2/15/21.
//  Copyright © 2021 Fifty6 Incorporated. All rights reserved.
//

import Foundation
import Persistence

protocol CoreDataStoreStorage {
    // Core Data Store -> Storage
    func item(from storeItem: Persistence.Item) -> Storage.Item
    func project(from storeProject: Persistence.Project) -> Storage.Project
    func projectItem(from storeProjectItem: Persistence.ProjectItem) -> Storage.ProjectItem
    
    // Storage -> Core Data Store
    // The store does the actual creation. We just copy values here.
    func copyItemValues(from item: Storage.Item, to storeItem: Persistence.Item)
    func copyProjectValues(from project: Storage.Project, to storeProject: Persistence.Project)
    func copyProjectItemValues(from projectItem: Storage.ProjectItem, to storeProjectItem: Persistence.ProjectItem)
}

class CoreDataStoreStorageFactory: CoreDataStoreStorage {
    // MARK: - Core Data Store - Storage
    
    func item(from storeItem: Persistence.Item) -> Storage.Item {
        Storage.Item(
            id: storeItem.id,
            name: storeItem.name,
            count: storeItem.count)
    }
    
    func project(from storeProject: Persistence.Project) -> Storage.Project {
        let items = storeProject.projectItems?.allObjects as? [Persistence.ProjectItem]
        return Storage.Project(
            id: storeProject.id,
            name: storeProject.name,
            items: items?.map(projectItem(from:)))
    }
    
    func projectItem(from storeProjectItem: Persistence.ProjectItem) -> Storage.ProjectItem {
        Storage.ProjectItem(
            id: storeProjectItem.id,
            itemID: storeProjectItem.itemID,
            numberRequiredPerBuild: storeProjectItem.numberRequiredPerBuild)
    }
    
    // MARK: - Storage -> Core Data Store
    func copyItemValues(from item: Storage.Item, to storeItem: Persistence.Item) {
        storeItem.id = item.id
        storeItem.name = item.name
        storeItem.count = item.count ?? 0
    }
    
    func copyProjectValues(from project: Storage.Project, to storeProject: Persistence.Project) {
        storeProject.id = project.id
        storeProject.name = project.name
    }
    
    func copyProjectItemValues(from projectItem: Storage.ProjectItem, to storeProjectItem: Persistence.ProjectItem) {
        storeProjectItem.itemID = projectItem.itemID
        if let numberRequiredPerBuild = projectItem.numberRequiredPerBuild {
            storeProjectItem.numberRequiredPerBuild = numberRequiredPerBuild
        }
    }
}
