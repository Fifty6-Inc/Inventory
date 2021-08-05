//
//  ViewProjectDetailsService.swift
//  Inventory
//
//  Created by Mikael Weiss on 8/4/21.
//  Copyright © 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import Foundation

protocol ViewProjectDetailsService {
    var updatePublisher: RepositoryPublisher { get }
    func fetchProject() throws -> ViewProjectDetails.ProjectInfo
    func prepareRouteToEditProject()
    func prepareRouteToEditItemCount(with id: UUID)
    func buildProject()
}

protocol ViewProjectDetailsItemsFetching {
    func item(withID: UUID) throws -> Item?
    
    var updatePublisher: RepositoryPublisher { get }
}
extension MainItemRepository: ViewProjectDetailsItemsFetching { }

protocol ViewProjectDetailsProjectFetching {
    func project(withID: UUID) throws -> Project?
    
    var updatePublisher: RepositoryPublisher { get }
}
extension MainProjectRepository: ViewProjectDetailsProjectFetching { }

extension ViewProjectDetails {
    
    struct ProjectInfo {
        let name: String
        let items: [Item]
    }
    
    enum ServiceError: Swift.Error {
        case fetchFailed
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
                
                let items = try project.itemIDs.compactMap {
                    try itemFetcher.item(withID: $0)
                }
                
                return ProjectInfo(
                    name: project.name,
                    items: items)
            } catch {
                throw ServiceError.fetchFailed
            }
        }
        
        func prepareRouteToEditProject() {
            EditProject.prepareIncomingRoute(with: projectID)
        }
        
        func prepareRouteToEditItemCount(with id: UUID) {
            EditItem.prepareIncomingRoute(with: id)
        }
        
        func buildProject() {
            // AAAAAAA
        }
    }
    
    class PreviewService: ViewProjectDetailsService {
        
        var updatePublisher: RepositoryPublisher = RepositorySubject().eraseToAnyPublisher()
        
        func fetchProject() throws -> ViewProjectDetails.ProjectInfo {
            ProjectInfo(
                name: "Caliburn",
                items: [
                    Item(name: "Bolts",
                         count: 5)
                ])
        }
        
        func prepareRouteToEditProject() {
            EditProject.prepareIncomingRoute(with: nil)
        }
        
        func prepareRouteToEditItemCount(with id: UUID) {
            EditItem.prepareIncomingRoute(with: id)
        }
        
        func buildProject() { }
    }
}
