//
//  DomainToStorageTransformer.swift
//  Inventory
//
//  Created by Mikael Weiss on 2/15/21.
//  Copyright © 2021 Fifty6 Incorporated. All rights reserved.
//

import Foundation

protocol DomainToStorageTransformer {
    func item(from domainItem: Item) -> Storage.Item
    func project(from domainProject: Project) -> Storage.Project
    func projectItem(from domainProjectItem: ProjectItem) -> Storage.ProjectItem
}

class DomainToStorageFactory: DomainToStorageTransformer {
    func item(from domainItem: Item) -> Storage.Item {
        Storage.Item(
            id: domainItem.id,
            name: domainItem.name,
            count: Int64(domainItem.count))
    }
    
    func project(from domainProject: Project) -> Storage.Project {
        Storage.Project(
            id: domainProject.id,
            name: domainProject.name,
            projectItems: domainProject.projectItems.map(projectItem(from:)))
    }
    
    func projectItem(from domainProjectItem: ProjectItem) -> Storage.ProjectItem {
        Storage.ProjectItem(
            id: domainProjectItem.id,
            itemID: domainProjectItem.itemID,
            numberRequiredPerBuild: Int64(domainProjectItem.numberRequiredPerBuild))
    }
}
