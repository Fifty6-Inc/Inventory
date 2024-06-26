//
//  EditProjectInteractor.swift
//  Inventory
//
//  Created by Mikael Weiss on 8/3/21.
//  Copyright © 2021 Fifty6, Inc. All rights reserved.
//

import Foundation
import Combine

protocol EditProjectInteracting {
    func fetchProject()
    func dismiss()
    func save()
    func delete()
    func updateName(_ value: String)
    func removeItem(with id: UUID)
    func addProjectItem(with request: EditProject.AddProjectItem.Request)
    func addItemAndProjectItem(with request: EditProject.AddItemAndProjectItem.Request)
}

extension EditProject {
    
    struct Interactor: EditProjectInteracting {
        let service: EditProjectService
        let presenter: EditProjectPresenting
        
        init(service: EditProjectService,
             presenter: EditProjectPresenting) {
            self.service = service
            self.presenter = presenter
        }
        
        func fetchProject() {
            attempt {
                let project = try service.fetchProject()
                presenter.presentFetch(project)
            }
        }
        
        func fetchAllItems() {
            attempt {
                let items = try service.fetchAllItems()
                presenter.present(allItems: items)
            }
        }
        
        func dismiss() {
            presenter.presentDismiss()
        }
        
        func save() {
            attempt {
                try service.save()
                presenter.presentDismiss()
            }
        }
        
        func delete() {
            attempt {
                try service.delete()
                presenter.presentDismiss()
            }
        }
        
        func updateName(_ value: String) {
            do {
                try service.validateName(value)
                presenter.present(updateName: value, error: nil)
            } catch {
                presenter.present(updateName: value, error: error as? ValidationError)
            }
            checkCanSave()
        }
        
        private func checkCanSave() {
            presenter.present(canSave: service.canSave())
        }
        
        func removeItem(with id: UUID) {
            service.removeItem(with: id)
            refreshItems()
        }
        
        func addProjectItem(with request: AddProjectItem.Request) {
            attempt {
                try service.addProjectItem(
                    with: request.itemID,
                    numberRequiredPerBuild: request.numberRequiredPerBuild)
                refreshItems()
            }
        }
        
        func addItemAndProjectItem(with request: EditProject.AddItemAndProjectItem.Request) {
            service.addItemAndProjectItem(
                itemName: request.name,
                count: request.count,
                numberRequiredPerBuild: request.numberRequiredPerBuild)
            refreshItems()
        }
        
        private func refreshItems() {
            let items = service.projectItems()
            presenter.present(projectItems: items)
            
            let allItems = service.filteredItems()
            presenter.present(allItems: allItems)
            
            checkCanSave()
        }
        
        private func attempt(_ attempt: () throws -> Void) {
            do {
                try attempt()
            } catch {
                presenter.present(error: error as? ServiceError)
            }
        }
    }
}
