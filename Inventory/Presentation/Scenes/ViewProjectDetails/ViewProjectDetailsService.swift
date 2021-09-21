//
//  ViewProjectDetailsService.swift
//  Inventory
//
//  Created by Mikael Weiss on 8/4/21.
//  Copyright © 2021 Fifty6, Inc. All rights reserved.
//

import Foundation

protocol ViewProjectDetailsService {
    var updatePublisher: RepositoryPublisher { get }
    func fetchProject() throws -> ViewProjectDetails.ProjectInfo
    func prepareRouteToEditProject(onDelete: @escaping () -> Void)
    func prepareRouteToEditItemCount(with id: UUID)
    func buildProject() throws
    func recieveParts() throws
}

protocol ViewProjectDetailsItemsFetching {
    func item(withID: UUID) throws -> Item?
    func updateItem(_ item: Item) throws
    
    var updatePublisher: RepositoryPublisher { get }
}
extension MainItemRepository: ViewProjectDetailsItemsFetching { }

protocol ViewProjectDetailsProjectFetching {
    func project(withID: UUID) throws -> Project?
    
    var updatePublisher: RepositoryPublisher { get }
}
extension MainProjectRepository: ViewProjectDetailsProjectFetching { }

extension ViewProjectDetails {
    
    struct ItemInfo {
        let itemID: UUID
        let name: String
        let count: Int
        let numberRequiredPerBuild: Int
    }
    
    struct ProjectInfo {
        let name: String
        let items: [ItemInfo]
    }
    
    enum ServiceError: Swift.Error {
        case fetchFailed
        case buildFailed
        case receivePartsFailed
    }
    
    class Service: ViewProjectDetailsService {
        private let projectFetcher: ViewProjectDetailsProjectFetching
        private let itemFetcher: ViewProjectDetailsItemsFetching
        private let projectID: UUID
        
        var updatePublisher: RepositoryPublisher {
            projectFetcher.updatePublisher
                .merge(with: itemFetcher.updatePublisher)
                .eraseToAnyPublisher()
        }
        
        init(projectFetcher: ViewProjectDetailsProjectFetching,
             itemFetcher: ViewProjectDetailsItemsFetching,
             projectID: UUID) {
            self.projectFetcher = projectFetcher
            self.itemFetcher = itemFetcher
            self.projectID = projectID
        }
        
        func fetchProject() throws -> ViewProjectDetails.ProjectInfo {
            do {
                guard let project = try projectFetcher.project(withID: projectID) else {
                    throw ServiceError.fetchFailed
                }
                
                let items = try project.projectItems.map { projectItem -> ItemInfo in
                    guard let item = try itemFetcher.item(withID: projectItem.itemID) else {
                        throw ServiceError.fetchFailed
                    }
                    return ItemInfo(
                        itemID: item.id,
                        name: item.name,
                        count: item.count,
                        numberRequiredPerBuild: projectItem.numberRequiredPerBuild)
                }
                
                return ProjectInfo(
                    name: project.name,
                    items: items)
            } catch {
                throw ServiceError.fetchFailed
            }
        }
        
        func prepareRouteToEditProject(onDelete: @escaping () -> Void) {
            EditProject.prepareIncomingRoute(with: projectID, onDelete: onDelete)
        }
        
        func prepareRouteToEditItemCount(with id: UUID) {
            EditItem.prepareIncomingRoute(with: id)
        }
        
        func buildProject() throws {
            let project = try projectFetcher.project(withID: projectID)
            guard let projectItems = project?.projectItems else {
                throw ServiceError.buildFailed
            }
            for projectItem in projectItems {
                guard let item = try itemFetcher.item(withID: projectItem.itemID) else {
                    throw ServiceError.buildFailed
                }
                let newCount = item.count - projectItem.numberRequiredPerBuild
                try item.set(count: newCount)
                try itemFetcher.updateItem(item)
            }
        }
        
        func recieveParts() throws {
            let project = try projectFetcher.project(withID: projectID)
            guard let projectItems = project?.projectItems else {
                throw ServiceError.buildFailed
            }
            for projectItem in projectItems {
                guard let item = try itemFetcher.item(withID: projectItem.itemID) else {
                    throw ServiceError.buildFailed
                }
                let newCount = item.count + projectItem.numberRequiredPerBuild
                try item.set(count: newCount)
                try itemFetcher.updateItem(item)
            }
        }
    }
    
    class PreviewService: ViewProjectDetailsService {
        
        var updatePublisher: RepositoryPublisher = RepositorySubject().eraseToAnyPublisher()
        
        func fetchProject() throws -> ViewProjectDetails.ProjectInfo {
            ProjectInfo(
                name: "Caliburn",
                items: [
                    ItemInfo(
                        itemID: UUID(),
                        name: "Bolts",
                        count: 5,
                        numberRequiredPerBuild: 4)
                ])
        }
        
        func prepareRouteToEditProject(onDelete: @escaping () -> Void) {
            EditProject.prepareIncomingRoute(with: nil, onDelete: onDelete)
        }
        
        func prepareRouteToEditItemCount(with id: UUID) {
            EditItem.prepareIncomingRoute(with: id)
        }
        
        func buildProject() throws { }
        
        func recieveParts() throws { }
    }
}
