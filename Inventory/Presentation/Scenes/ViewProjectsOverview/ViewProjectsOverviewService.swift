//
//  ViewProjectsOverviewService.swift
//  Inventory
//
//  Created by Mikael Weiss on 8/3/21.
//  Copyright © 2021 Fifty6, Inc. All rights reserved.
//

import Foundation

protocol ViewProjectsOverviewService {
    var updatePublisher: RepositoryPublisher { get }
    func fetchProjects() throws -> [ViewProjectsOverview.ProjectDetails]
    func prepareRouteToProject(with id: UUID)
    func prepareRouteToAddProject()
    func onHiddenGesture()
}

protocol ViewProjectsOverviewFetching {
    func allProjects() throws -> [Project]
    
    var updatePublisher: RepositoryPublisher { get }
}
extension MainProjectRepository: ViewProjectsOverviewFetching { }

extension ViewProjectsOverview {
    
    enum ServiceError: Swift.Error {
        case fetchFailed
    }
    
    struct ProjectDetails {
        let id: UUID
        let name: String
    }
    
    class Service: ViewProjectsOverviewService {
        private let projectFetcher: ViewProjectsOverviewFetching
        
        var updatePublisher: RepositoryPublisher {
            projectFetcher.updatePublisher.eraseToAnyPublisher()
        }
        
        init(projectFetcher: ViewProjectsOverviewFetching) {
            self.projectFetcher = projectFetcher
        }
        
        func fetchProjects() throws -> [ProjectDetails] {
            do {
                let projects = try projectFetcher.allProjects()
                let projectDetails = projects.map {
                    ProjectDetails(
                        id: $0.id,
                        name: $0.name)
                }
                return projectDetails
            } catch {
                throw ServiceError.fetchFailed
            }
        }
        
        func prepareRouteToProject(with id: UUID) {
            ViewProjectDetails.prepareIncomingRoute(with: id)
        }
        
        func prepareRouteToAddProject() {
            EditProject.prepareIncomingRoute(with: nil, onDelete: {})
        }
        
        func onHiddenGesture() {
            ApplicationState.shared.usePreviewServices = true
        }
    }
    
    class PreviewService: ViewProjectsOverviewService {
        
        var updatePublisher: RepositoryPublisher = RepositorySubject().eraseToAnyPublisher()
        
        func fetchProjects() throws -> [ProjectDetails] {
            [
                ProjectDetails(
                    id: UUID(),
                    name: "Part 1"),
                ProjectDetails(
                    id: UUID(),
                    name: "Part 2"),
                ProjectDetails(
                    id: UUID(),
                    name: "Part 3"),
                ProjectDetails(
                    id: UUID(),
                    name: "Part 4"),
                ProjectDetails(
                    id: UUID(),
                    name: "Part 5")
            ]
        }
        
        func prepareRouteToProject(with id: UUID) {
            EditProject.prepareIncomingRoute(with: id, onDelete: {})
        }
        
        func prepareRouteToAddProject() {
            EditProject.prepareIncomingRoute(with: nil, onDelete: {})
        }
        
        func onHiddenGesture() {
            ApplicationState.shared.usePreviewServices = false
        }
    }
}
