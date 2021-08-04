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
    
    private(set) var itemIDs: [UUID]
    func set(itemIDs: [UUID]) throws {
        self.itemIDs = itemIDs
    }
    
    init(id: UUID = UUID(), name: String, itemIDs: [UUID]) {
        self.id = id
        self.name = name
        self.itemIDs = itemIDs
    }
    
    // MARK: - Reconstitution
    
    struct ReconstitutionInfo {
        let id: UUID
        let name: String
        let itemIDs: [UUID]
    }
    
    init(with info: ReconstitutionInfo) throws {
        self.id = info.id
        self.name = info.name
        self.itemIDs = info.itemIDs
    }
}
