//
//  Item.swift
//  Inventory
//
//  Created by Mikael Weiss on 8/3/21.
//  Copyright © 2021 Fifty6 Incorporated. All rights reserved.
//

import Foundation

class Item {
    let id: UUID
    
    private(set) var name: String
    func set(name: String) throws {
        self.name = name
    }
    
    private(set) var count: Int
    func set(count: Int) throws {
        self.count = count
    }
    
    init(id: UUID = UUID(),
         name: String,
         count: Int) {
        self.id = id
        self.name = name
        self.count = count
    }
    
    // MARK: - Reconstitution
    
    struct ReconstitutionInfo {
        let id: UUID
        let name: String
        let count: Int
    }
    
    init(with info: ReconstitutionInfo) throws {
        self.id = info.id
        self.name = info.name
        self.count = info.count
    }
}
