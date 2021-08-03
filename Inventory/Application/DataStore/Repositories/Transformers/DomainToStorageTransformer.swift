//
//  DomainToStorageTransformer.swift
//  Inventory
//
//  Created by Mikael Weiss on 2/15/21.
//

import Foundation

protocol DomainToStorageTransformer {
    func item(from domainItem: Item) -> Storage.Item
}

class DomainToStorageFactory: DomainToStorageTransformer {
    func item(from domainItem: Item) -> Storage.Item {
        Storage.Item(
            id: domainItem.id,
            name: domainItem.name,
            count: Int64(domainItem.count))
    }
}
