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
              let itemIDs = storageProject.itemIDs
        else { throw ReconstitutionError.missingRequiredFields }
        
        let projectInfo = Project.ReconstitutionInfo(
            id: id,
            name: name,
            itemIDs: itemIDs)
        
        return try Project(with: projectInfo)
    }
}
