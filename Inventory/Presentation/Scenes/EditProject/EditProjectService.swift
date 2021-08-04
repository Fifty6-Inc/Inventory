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
    func validateName(_ value: String) throws
    func canSave() -> Bool
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

extension EditProject {
    
    enum ServiceError: Swift.Error {
        case fetchFailed
        case invalidInput
        case saveFailed
        case deleteFailed
    }
    
    enum ValidationError: Swift.Error {
        case empty
        case invalid
    }
    
    struct ProjectInfo {
        var name: String?
    }
    
    class Service: EditProjectService {
        private let projectFetcher: EditProjectProjectFetching
        private let projectID: UUID?
        
        init(projectFetcher: EditProjectProjectFetching, projectID: UUID?) {
            self.projectFetcher = projectFetcher
            self.projectID = projectID
        }
        
        private var project: Project?
        private var name: String?
        
        func fetchProject() throws -> ProjectInfo? {
            if let projectID = projectID {
                do {
                    let project = try projectFetcher.project(withID: projectID)
                    self.project = project
                    name = project?.name
                    return ProjectInfo(name: project?.name)
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
        
        func canSave() -> Bool {
            !name.isNilOrEmpty
        }
        
        func save() throws {
            if let name = name {
                do {
                    if let project = project {
                        try project.set(name: name)
                        try projectFetcher.updateProject(project)
                    } else {
                        let project = Project(name: name, itemIDs: [])
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
    }
    
    class PreviewService: EditProjectService {
        private var name = ""
        private var count: Int?
        
        func fetchProject() throws -> ProjectInfo? {
            ProjectInfo(name: name)
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
        
        func delete() throws {
            throw ServiceError.deleteFailed
        }
    }
}
