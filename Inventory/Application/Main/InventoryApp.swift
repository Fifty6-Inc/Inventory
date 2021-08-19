//
//  InventoryApp.swift
//  Inventory
//
//  Created by Mikael Weiss on 8/3/21.
//  Copyright © 2021 Fifty6, Inc. All rights reserved.
//

import SwiftUI

@main
struct InventoryApp: App {
    static let storage = CoreDataStorage.shared
    
    var body: some Scene {
        WindowGroup {
            MainTabView()
        }
    }
}
