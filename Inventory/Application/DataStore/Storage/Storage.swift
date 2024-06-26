//
//  Storage.swift
//  Inventory
//
//  Created by Mikael Weiss on 8/15/21.
//  Copyright © 2021 Fifty6, Inc. All rights reserved.
//

import Foundation

enum Storage {
    struct Item {
        let id: UUID?
        let name: String?
        let count: Int64?
    }
    struct Project {
        let id: UUID?
        let name: String?
        let projectItems: [ProjectItem]?
    }
    struct ProjectItem {
        let id: UUID?
        let itemID: UUID?
        let numberRequiredPerBuild: Int64?
    }
}
