//
//  EditItemInteractor.swift
//  Inventory
//
//  Created by Mikael Weiss on 8/3/21.
//  Copyright © 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import Foundation

protocol EditItemInteracting {
    func dismiss()
    func save()
    func updateName(_ value: String)
    func updateCount(_ value: String)
}

extension EditItem {
    
    struct Interactor: EditItemInteracting {
        let service: EditItemService
        let presenter: EditItemPresenting
        
        func dismiss() {
            presenter.presentDismiss()
        }
        
        func save() {
            do {
                try service.save()
            } catch {
                presenter.present(error: .saveFailed)
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
        
        private func checkCanSave() {
            presenter.present(canSave: service.canSave())
        }
    }
}
