//
//  StorageToDomainTransformer.swift
//  Inventory
//
//  Created by Mikael Weiss on 2/15/21.
//  Copyright © 2021 Fifty6 Incorporated. All rights reserved.
//

import SwiftUI

enum ReconstitutionError: Error {
    case missingRequiredFields
    case invalidOption(String)
}

protocol StorageToDomainTransformer {
    func item(from storageItem: Storage.Item) throws -> Item
    func project(from storageProject: Storage.Project) throws -> Project
}

class StorageToDomainFactory: StorageToDomainTransformer {
    func item(from storageItem: Storage.Item) throws -> Item {
        guard let id = storageItem.id,
              let name = storageItem.name,
              let count = storageItem.count
        else { throw ReconstitutionError.missingRequiredFields }
        
        let itemInfo = Item.ReconstitutionInfo(
            id: id,
            name: name,
            count: Int(count))
        
        return try Item(with: itemInfo)
    }
    
    func project(from storageProject: Storage.Project) throws -> Project {
        guard let id = storageProject.id,
              let name = storageProject.name,
              let items = storageProject.items
        else { throw ReconstitutionError.missingRequiredFields }
        
        let projectInfo = Project.ReconstitutionInfo(
            id: id,
            name: name,
            items: try items.map(projectItem(from:)))
        
        return try Project(with: projectInfo)
    }
    
    func projectItem(from storageProjectItem: Storage.ProjectItem) throws -> ProjectItem {
        guard let id = storageProjectItem.id,
              let itemID = storageProjectItem.itemID,
              let numberRequiredPerBuild = storageProjectItem.numberRequiredPerBuild
        else { throw ReconstitutionError.missingRequiredFields }
        
        let projectItemInfo = ProjectItem.ReconstitutionInfo(
            id: id,
            itemID: itemID,
            numberRequiredPerBuild: Int(numberRequiredPerBuild))
        return try ProjectItem(with: projectItemInfo)
    }
}
