//
//  EditItemService.swift
//  Inventory
//
//  Created by Mikael Weiss on 8/3/21.
//  Copyright © 2021 Fifty6, Inc. All rights reserved.
//

import Foundation

protocol EditItemService {
    func fetchItem() throws -> EditItem.ItemInfo?
    func validateName(_ value: String) throws
    func validateCount(_ value: String) throws
    func addToCount(_ value: Int)
    func dragEnded()
    func fetchCount() -> Int?
    func canSave() -> Bool
    func save() throws
    func delete() throws
}

protocol EditItemItemFetching {
    func item(withID: UUID) throws -> Item?
    func addItem(_ item: Item) throws
    func updateItem(_ item: Item) throws
    func deleteItem(_ id: UUID) throws
}
extension MainItemRepository: EditItemItemFetching { }

protocol EditItemProjectFetching {
    func allProjects() throws -> [Project]
    func updateProject(_ project: Project) throws
}
extension MainProjectRepository: EditItemProjectFetching { }

extension EditItem {
    
    enum ServiceError: Swift.Error {
        case fetchFailed
        case invalidInput
        case saveFailed
        case deleteFailed
        case updateCountFailed
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
        private let projectFetcher: EditItemProjectFetching
        private let itemID: UUID?
        
        init(itemFetching: EditItemItemFetching,
             projectFetching: EditItemProjectFetching,
             itemID: UUID?) {
            
            self.itemFetcher = itemFetching
            self.projectFetcher = projectFetching
            self.itemID = itemID
        }
        
        private var item: Item?
        private var name: String?
        private var count: Int?
        private var isDragging = false
        private var startValue: Int?
        
        func fetchItem() throws -> ItemInfo? {
            if let itemID = itemID {
                do {
                    let item = try itemFetcher.item(withID: itemID)
                    self.item = item
                    name = item?.name
                    count = item?.count
                    return ItemInfo(name: item?.name, count: item?.count)
                } catch {
                    throw ServiceError.fetchFailed
                }
            }
            return nil
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
        
        func addToCount(_ value: Int) {
            let count = count ?? 0
            if isDragging == false {
                startValue = count
            }
            isDragging = true
            if let startValue = startValue {
                self.count = count + (value - (count - startValue))
            }
        }
        
        func dragEnded() {
            isDragging = false
            startValue = nil
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
        
        func delete() throws {
            do {
                if let item = item {
                    try itemFetcher.deleteItem(item.id)
                    deleteItemIDFromAllProjects(item.id)
                } else {
                    throw ServiceError.deleteFailed
                }
            } catch {
                throw ServiceError.deleteFailed
            }
        }
        
        private func deleteItemIDFromAllProjects(_ itemId: UUID) {
            guard let projects = try? projectFetcher.allProjects() else { return }
            for project in projects {
                let newItems = project.projectItems.filter { $0.itemID != itemID }
                try? project.set(projectItems: newItems)
                try? projectFetcher.updateProject(project)
            }
        }
    }
    
    class PreviewService: EditItemService {
        private var name = ""
        private var count: Int?
        private var isDragging = false
        private var startValue: Int?
        
        func fetchItem() throws -> ItemInfo? {
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
        
        func addToCount(_ value: Int) {
            let count = count ?? 0
            if isDragging == false {
                startValue = count
            }
            isDragging = true
            if let startValue = startValue {
                self.count = count + ((count - startValue) - value)
            }
        }
        
        func dragEnded() {
            isDragging = false
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
        
        func delete() throws {
            throw ServiceError.deleteFailed
        }
    }
}
