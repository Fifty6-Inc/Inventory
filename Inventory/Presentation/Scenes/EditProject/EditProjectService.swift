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
    func projectItems() -> [Item]
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
    
    struct ProjectInfo {
        var name: String?
        var items: [Item]
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
        private var items = [Item]()
        private var allItems = [Item]()
        
        func fetchProject() throws -> ProjectInfo? {
            if let projectID = projectID {
                do {
                    let project = try projectFetcher.project(withID: projectID)
                    self.project = project
                    name = project?.name
                    let items = project?.itemIDs.compactMap {
                        try? itemsFetcher.item(withID: $0)
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
                return items
            } catch {
                throw ServiceError.fetchFailed
            }
        }
        
        func projectItems() -> [Item] {
            items
        }
        
        func filteredItems() -> [Item] {
            allItems.filter { item in
                !items.contains(where: { $0.id == item.id })
            }
        }
        
        func validateName(_ value: String) throws {
            name = value
            if value.isEmpty { throw ValidationError.empty }
        }
        
        func canSave() -> Bool {
            !name.isNilOrEmpty
        }
        
        func save() throws {
            if let name = name {
                do {
                    if let project = project {
                        try project.set(name: name)
                        try project.set(itemIDs: items.map { $0.id })
                        try projectFetcher.updateProject(project)
                    } else {
                        let project = Project(name: name, itemIDs: items.map { $0.id })
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
        
        func addItem(with id: UUID) throws {
            do {
                guard let item = try itemsFetcher.item(withID: id) else {
                    throw ServiceError.addItemFailed
                }
                items.append(item)
            } catch {
                throw ServiceError.addItemFailed
            }
        }
        
        func removeItem(with id: UUID) {
            items.removeAll(where: { $0.id == id })
        }
    }
    
    class PreviewService: EditProjectService {
        private var name = ""
        private var count: Int?
        
        func fetchProject() throws -> ProjectInfo? {
            let items = [
                Item(name: "First", count: 5),
                Item(name: "Second", count: 6)
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
        
        func projectItems() -> [Item] {
            [
                Item(name: "First", count: 5),
                Item(name: "Second", count: 6)
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
