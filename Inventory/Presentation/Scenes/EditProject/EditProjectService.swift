//
//  EditProjectService.swift
//  Inventory
//
//  Created by Mikael Weiss on 8/3/21.
//  Copyright © 2021 Fifty6 Incorporated. All rights reserved.
//

import Foundation

protocol EditProjectService {
    func fetchProject() throws -> EditProject.ProjectInfo?
    func fetchAllItems() throws -> [Item]
    func projectItems() -> [EditProject.ItemInfo]
    func filteredItems() -> [Item]
    func validateName(_ value: String) throws
    func canSave() -> Bool
    func addItem(with id: UUID) throws
    func removeItem(with id: UUID)
    func save() throws
    func delete() throws
}

protocol EditProjectProjectFetching {
    func project(withID: UUID) throws -> Project?
    func addProject(_ project: Project) throws
    func updateProject(_ project: Project) throws
    func deleteProject(_ id: UUID) throws
}
extension MainProjectRepository: EditProjectProjectFetching { }

protocol EditProjectItemsFetching {
    func allItems() throws -> [Item]
    func item(withID: UUID) throws -> Item?
}
extension MainItemRepository: EditProjectItemsFetching { }

extension EditProject {
    
    enum ServiceError: Swift.Error {
        case fetchFailed
        case invalidInput
        case saveFailed
        case deleteFailed
        case addItemFailed
    }
    
    enum ValidationError: Swift.Error {
        case empty
        case invalid
    }
    
    struct ItemInfo {
        let id: UUID
        let itemID: UUID
        let name: String
        let count: Int
        let numberRequiredPerBuild: Int
    }
    
    struct ProjectInfo {
        var name: String?
        var items: [ItemInfo]
    }
    
    class Service: EditProjectService {
        private let projectFetcher: EditProjectProjectFetching
        private let itemsFetcher: EditProjectItemsFetching
        private let projectID: UUID?
        
        init(projectFetcher: EditProjectProjectFetching,
             itemsFetcher: EditProjectItemsFetching,
             projectID: UUID?) {
            
            self.projectFetcher = projectFetcher
            self.itemsFetcher = itemsFetcher
            self.projectID = projectID
        }
        
        private var project: Project?
        private var name: String?
        private var items = [ItemInfo]()
        private var allItems = [Item]()
        
        func fetchProject() throws -> ProjectInfo? {
            if let projectID = projectID {
                do {
                    let project = try projectFetcher.project(withID: projectID)
                    self.project = project
                    name = project?.name
                    let items = try project?.items.map { projectItem -> ItemInfo in
                        guard let item = try itemsFetcher.item(withID: projectItem.itemID)
                        else { throw ServiceError.fetchFailed }
                        return ItemInfo(
                            id: projectItem.id,
                            itemID: item.id,
                            name: item.name,
                            count: item.count,
                            numberRequiredPerBuild: projectItem.numberRequiredPerBuild)
                    }
                    self.items = items ?? []
                    
                    return ProjectInfo(
                        name: name,
                        items: self.items)
                } catch {
                    throw ServiceError.fetchFailed
                }
            }
            return nil
        }
        
        func fetchAllItems() throws -> [Item] {
            do {
                let items = try itemsFetcher.allItems()
                allItems = items
                return filteredItems()
            } catch {
                throw ServiceError.fetchFailed
            }
        }
        
        func filteredItems() -> [Item] {
            allItems.filter { item in
                !items.contains(where: { $0.itemID == item.id })
            }
        }
        
        func projectItems() -> [ItemInfo] {
            items
        }
        
        func validateName(_ value: String) throws {
            name = value
            if value.isEmpty { throw ValidationError.empty }
        }
        
        func addItem(with id: UUID) throws {
            do {
                guard let item = try itemsFetcher.item(withID: id) else {
                    throw ServiceError.addItemFailed
                }
                let itemInfo = ItemInfo(
                    id: UUID(),
                    itemID: item.id,
                    name: item.name,
                    count: item.count,
                    numberRequiredPerBuild: 0)
                items.append(itemInfo)
            } catch {
                throw ServiceError.addItemFailed
            }
        }
        
        func removeItem(with id: UUID) {
            items.removeAll(where: { $0.itemID == id })
        }
        
        func canSave() -> Bool {
            !name.isNilOrEmpty && items.count > 0
        }
        
        func save() throws {
            if let name = name {
                do {
                    if let project = project {
                        try project.set(name: name)
                        try project.set(items: items.map(map(itemInfo:)))
                        try projectFetcher.updateProject(project)
                    } else {
                        let project = Project(name: name, items: items.map(map(itemInfo:)))
                        try projectFetcher.addProject(project)
                        self.project = project
                    }
                } catch {
                    throw ServiceError.saveFailed
                }
            } else {
                throw ServiceError.invalidInput
            }
        }
        
        private func map(itemInfo: ItemInfo) -> ProjectItem {
            ProjectItem(
                id: itemInfo.id,
                itemID: itemInfo.itemID,
                numberRequiredPerBuild: itemInfo.numberRequiredPerBuild)
        }
        
        func delete() throws {
            do {
                if let project = project {
                    try projectFetcher.deleteProject(project.id)
                } else {
                    throw ServiceError.deleteFailed
                }
            } catch {
                throw ServiceError.deleteFailed
            }
        }
    }
    
    class PreviewService: EditProjectService {
        private var name = ""
        private var count: Int?
        
        func fetchProject() throws -> ProjectInfo? {
            let items = [
                ItemInfo(
                    id: UUID(),
                    itemID: UUID(),
                    name: "First",
                    count: 5,
                    numberRequiredPerBuild: 6),
                ItemInfo(
                    id: UUID(),
                    itemID: UUID(),
                    name: "Second",
                    count: 6,
                    numberRequiredPerBuild: 6)
            ]
            return ProjectInfo(
                name: name,
                items: items)
        }
        
        func fetchAllItems() throws -> [Item] {
            [
                Item(name: "First", count: 5),
                Item(name: "Second", count: 6)
            ]
        }
        
        func projectItems() -> [ItemInfo] {
            [
                ItemInfo(
                    id: UUID(),
                    itemID: UUID(),
                    name: "First",
                    count: 5,
                    numberRequiredPerBuild: 6),
                ItemInfo(
                    id: UUID(),
                    itemID: UUID(),
                    name: "Second",
                    count: 6,
                    numberRequiredPerBuild: 6)
            ]
        }
        
        func filteredItems() -> [Item] { [] }
        
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
        
        func delete() throws {
            throw ServiceError.deleteFailed
        }
        
        func addItem(with id: UUID) throws { }
        
        func removeItem(with id: UUID) { }
    }
}
