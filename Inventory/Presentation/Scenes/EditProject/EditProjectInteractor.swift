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
}

extension EditProject {
    
    struct Interactor: EditProjectInteracting {
        let service: EditProjectService
        let presenter: EditProjectPresenting
        
        func fetchProject() {
            do {
                let project = try service.fetchProject()
                presenter.presentFetch(project)
            } catch {
                presenter.present(error: error as? ServiceError)
            }
        }
        
        func dismiss() {
            presenter.presentDismiss()
        }
        
        func save() {
            do {
                try service.save()
                presenter.presentDismiss()
            } catch {
                presenter.present(error: error as? ServiceError)
            }
        }
        
        func delete() {
            do {
                try service.delete()
                presenter.presentDismiss()
            } catch {
                presenter.present(error: error as? ServiceError)
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
    }
}
