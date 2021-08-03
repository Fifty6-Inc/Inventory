//
//  InventoryApp.swift
//  Inventory
//
//  Created by Mikael Weiss on 8/3/21.
//

import SwiftUI

@main
struct InventoryApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
