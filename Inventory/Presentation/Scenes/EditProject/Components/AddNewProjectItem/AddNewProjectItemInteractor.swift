//
//  AddNewProjectItemInteractor.swift
//  Inventory
//
//  Created by Mikael Weiss on 8/3/21.
//  Copyright © 2021 Fifty6, Inc. All rights reserved.
//

import Foundation

protocol AddNewProjectItemInteracting {
    func dismiss()
    func save()
    func updateName(_ value: String)
    func updateCount(_ value: String)
    func updateNumberPerBuild(_ value: String)
}

extension AddNewProjectItem {
    
    struct Interactor: AddNewProjectItemInteracting {
        let service: AddNewProjectItemService
        let presenter: AddNewProjectItemPresenting
        
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
        
        func updateName(_ value: String) {
            do {
                try service.validateName(value)
                presenter.present(updateName: value, error: nil)
            } catch {
                presenter.present(updateName: value, error: error as? ValidationError)
            }
            checkCanSave()
        }
        
        func updateCount(_ value: String) {
            do {
                try service.validateCount(value)
                presenter.present(updateCount: value, error: nil)
            } catch {
                presenter.present(updateCount: value, error: error as? ValidationError)
            }
            checkCanSave()
        }
        
        func updateNumberPerBuild(_ value: String) {
            do {
                try service.validateNumberPerBuild(value)
                presenter.present(updateNumberPerBuild: value, error: nil)
            } catch {
                presenter.present(updateNumberPerBuild: value, error: error as? ValidationError)
            }
            checkCanSave()
        }
        
        private func checkCanSave() {
            presenter.present(canSave: service.canSave())
        }
    }
}
