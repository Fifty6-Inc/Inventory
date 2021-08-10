//
//  Project.swift
//  Inventory
//
//  Created by Mikael Weiss on 8/4/21.
//  Copyright © 2021 Fifty6 Incorporated. All rights reserved.
//

import Foundation

class Project {
    let id: UUID
    
    private(set) var name: String
    func set(name: String) throws {
        self.name = name
    }
    
    private(set) var projectItems: [ProjectItem]
    func set(projectItems: [ProjectItem]) throws {
        self.projectItems = projectItems
    }
    
    init(id: UUID = UUID(),
         name: String,
         items: [ProjectItem]) {
        
        self.id = id
        self.name = name
        self.projectItems = items
    }
    
    // MARK: - Reconstitution
    
    struct ReconstitutionInfo {
        let id: UUID
        let name: String
        let items: [ProjectItem]
    }
    
    init(with info: ReconstitutionInfo) throws {
        self.id = info.id
        self.name = info.name
        self.projectItems = info.items
    }
}
