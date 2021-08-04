//
//  EditItemInteractor.swift
//  Inventory
//
//  Created by Mikael Weiss on 8/3/21.
//  Copyright © 2021 Fifty6 Incorporated. All rights reserved.
//

import Foundation

protocol EditItemInteracting {
    func fetchItem()
    func dismiss()
    func save()
    func delete()
    func updateName(_ value: String)
    func updateCount(_ value: String)
    func subtractFromCount()
    func addToCount()
}

extension EditItem {
    
    struct Interactor: EditItemInteracting {
        let service: EditItemService
        let presenter: EditItemPresenting
        
        func fetchItem() {
            do {
                let item = try service.fetchItem()
                presenter.presentFetch(item)
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
        
        func updateCount(_ value: String) {
            do {
                try service.validateCount(value)
                presenter.present(updateCount: value, error: nil)
            } catch {
                presenter.present(updateCount: value, error: error as? ValidationError)
            }
            checkCanSave()
        }
        
        func subtractFromCount() {
            service.subtractFromCount()
            updateCount()
            checkCanSave()
        }
        
        func addToCount() {
            service.addToCount()
            updateCount()
            checkCanSave()
        }
        
        private func updateCount() {
            let count = service.fetchCount()
            if let count = count {
                presenter.present(updateCount: String(count), error: nil)
            } else {
                presenter.present(updateCount: "", error: nil)
            }
        }
        
        private func checkCanSave() {
            presenter.present(canSave: service.canSave())
        }
    }
}
