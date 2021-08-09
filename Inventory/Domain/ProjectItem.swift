//
//  ProjectItem.swift
//  Inventory
//
//  Created by Mikael Weiss on 8/5/21.
//

import Foundation

struct ProjectItem {
    let id: UUID
    let itemID: UUID
    let numberRequiredPerBuild: Int
    
    init(id: UUID = UUID(), itemID: UUID, numberRequiredPerBuild: Int) {
        self.id = id
        self.itemID = itemID
        self.numberRequiredPerBuild = numberRequiredPerBuild
    }
    
    // MARK: - Reconstitution
    
    struct ReconstitutionInfo {
        let id: UUID
        let itemID: UUID
        let numberRequiredPerBuild: Int
    }
    
    init(with info: ReconstitutionInfo) throws {
        self.id = info.id
        self.itemID = info.itemID
        self.numberRequiredPerBuild = info.numberRequiredPerBuild
    }
}
