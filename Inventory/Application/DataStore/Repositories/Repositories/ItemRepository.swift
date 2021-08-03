//
//  ItemRepository.swift
//  Inventory
//
//  Created by Mikael Weiss on 2/15/21.
//

import Foundation
import Combine

protocol ItemRepository {
    func allItems() throws -> [Item]
    func item(withID: UUID) throws -> Item?
    
    func addItem(_ item: Item) throws
    func updateItem(_ item: Item) throws
    func deleteItem(_ id: UUID) throws
    
    var updatePublisher: RepositoryPublisher { get }
}

protocol ItemRepositoryReadable {
    func getItem(with id: UUID) throws -> Storage.Item?
    func getAllItems() throws -> [Storage.Item]
}
protocol ItemRepositoryWritable {
    func addItem(_ storageItem: Storage.Item) throws
    func updateItem(_ storageItem: Storage.Item) throws
    func deleteItem(with id: UUID) throws
}

class MainItemRepository: ItemRepository {
    
    private let subject = PassthroughSubject<RepositoryAction, Never>()
    var updatePublisher: RepositoryPublisher {
        subject.eraseToAnyPublisher()
    }
    
    private let storageRead: ItemRepositoryReadable
    private let storageWrite: ItemRepositoryWritable
    private let toDomain: StorageToDomainTransformer
    private let toStorage: DomainToStorageTransformer
    
    init(storageRead: ItemRepositoryReadable,
         storageWrite: ItemRepositoryWritable,
         toDomainTransformer: StorageToDomainTransformer = StorageToDomainFactory(),
         toStorageTransformer: DomainToStorageTransformer = DomainToStorageFactory()) {
        
        self.storageRead = storageRead
        self.storageWrite = storageWrite
        self.toDomain = toDomainTransformer
        self.toStorage = toStorageTransformer
    }
    
    func allItems() throws -> [Item] {
        guard let allItems = try? storageRead.getAllItems() else { return [] }
        return allItems.compactMap { try? toDomain.item(from: $0) }
    }
    
    func item(withID: UUID) throws -> Item? {
        guard let storageItem = try storageRead.getItem(with: withID) else { return nil }
        return try toDomain.item(from: storageItem)
    }
    
    func addItem(_ item: Item) throws {
        let storageItem = toStorage.item(from: item)
        try storageWrite.addItem(storageItem)
        subject.send(.add(item.id))
    }
    
    func updateItem(_ item: Item) throws {
        let storageItem = toStorage.item(from: item)
        try storageWrite.updateItem(storageItem)
        subject.send(.update(item.id))
    }
    
    func deleteItem(_ id: UUID) throws {
        try storageWrite.deleteItem(with: id)
        subject.send(.delete(id))
    }
}
