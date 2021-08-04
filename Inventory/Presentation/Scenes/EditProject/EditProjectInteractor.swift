//
//  EditProjectInteractor.swift
//  Inventory
//
//  Created by Mikael Weiss on 8/3/21.
//  Copyright © 2021 Fifty6 Incorporated. All rights reserved.
//

import Foundation

protocol EditProjectInteracting {
    func fetchProject()
    func dismiss()
    func save()
    func delete()
    func updateName(_ value: String)
    func removeItem(with id: UUID)
    func addItem(with id: UUID)
}

extension EditProject {
    
    struct Interactor: EditProjectInteracting {
        let service: EditProjectService
        let presenter: EditProjectPresenting
        
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
        
        func addItem(with id: UUID) {
            attempt {
                try service.addItem(with: id)
                refreshItems()
            }
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
