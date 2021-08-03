//
//  InventoryApp.swift
//  Inventory
//
//  Created by Mikael Weiss on 8/3/21.
//

import SwiftUI

@main
struct InventoryApp: App {
    var body: some Scene {
        WindowGroup {
            ViewItemsOverview.Scene().view()
        }
    }
}
