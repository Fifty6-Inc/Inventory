//
//  EditItemService.swift
//  Inventory
//
//  Created by Mikael Weiss on 8/3/21.
//  Copyright © 2021 Fifty6 Incorporated. All rights reserved.
//

import Foundation

protocol EditItemService {
    func fetchItem() throws -> EditItem.ItemInfo
    func validateName(_ value: String) throws
    func validateCount(_ value: String) throws
    func subtractFromCount()
    func addToCount()
    func fetchCount() -> Int?
    func canSave() -> Bool
    func save() throws
}

protocol EditItemItemFetching {
    func item(withID: UUID) throws -> Item?
    func addItem(_ item: Item) throws
    func updateItem(_ item: Item) throws
    func deleteItem(_ id: UUID) throws
}
extension MainItemRepository: EditItemItemFetching { }

extension EditItem {
    
    enum ServiceError: Swift.Error {
        case fetchFailed
        case saveFailed
        case invalidInput
    }
    
    enum ValidationError: Swift.Error {
        case empty
        case invalid
    }
    
    struct ItemInfo {
        var name: String?
        var count: Int?
    }
    
    class Service: EditItemService {
        private let itemFetcher: EditItemItemFetching
        private let itemID: UUID?
        
        init(itemFetcher: EditItemItemFetching, itemID: UUID?) {
            self.itemFetcher = itemFetcher
            self.itemID = itemID
        }
        
        private var item: Item?
        private var name: String?
        private var count: Int?
        
        func fetchItem() throws -> ItemInfo {
            if let itemID = itemID {
                do {
                    let item = try itemFetcher.item(withID: itemID)
                    self.item = item
                } catch {
                    throw ServiceError.fetchFailed
                }
            }
            name = item?.name
            count = item?.count
            return ItemInfo(name: name, count: count)
        }
        
        func validateName(_ value: String) throws {
            name = value
            if value.isEmpty { throw ValidationError.empty }
        }
        
        func validateCount(_ value: String) throws {
            count = Int(value)
            if value.isEmpty { throw ValidationError.empty }
            if count == nil { throw ValidationError.invalid }
        }
        
        func subtractFromCount() {
            count? -= 1
            if count == nil {
                count = 1
            }
        }
        
        func addToCount() {
            count? += 1
            if count == nil {
                count = 1
            }
        }
        
        func fetchCount() -> Int? {
            count
        }
        
        func canSave() -> Bool {
            !name.isNilOrEmpty && count != nil
        }
        
        func save() throws {
            if let count = count, let name = name {
                do {
                    if let item = item {
                        try item.set(name: name)
                        try item.set(count: count)
                        try itemFetcher.updateItem(item)
                    } else {
                        let item = Item(name: name, count: count)
                        try itemFetcher.addItem(item)
                        self.item = item
                    }
                } catch {
                    throw ServiceError.saveFailed
                }
            } else {
                throw ServiceError.invalidInput
            }
        }
    }
    
    class PreviewService: EditItemService {
        private var name = ""
        private var count: Int?
        
        func fetchItem() throws -> ItemInfo {
            ItemInfo(name: name, count: count)
        }
        
        func validateName(_ value: String) throws {
            name = value
            if value.isEmpty { throw ValidationError.empty }
        }
        
        func validateCount(_ value: String) throws {
            count = Int(value)
            if value.isEmpty { throw ValidationError.empty }
            if count == nil { throw ValidationError.invalid }
        }
        
        func subtractFromCount() {
            count? -= 1
            if count == nil {
                count = 1
            }
        }
        
        func addToCount() {
            count? += 1
            if count == nil {
                count = 1
            }
        }
        
        func fetchCount() -> Int? {
            count
        }
        
        func canSave() -> Bool {
            !name.isEmpty && count != nil
        }
        
        func save() throws {
            throw ServiceError.saveFailed
        }
    }
}
