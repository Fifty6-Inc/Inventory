//
//  EditItemPresenter.swift
//  Inventory
//
//  Created by Mikael Weiss on 8/3/21.
//  Copyright © 2021 Fifty6 Incorporated. All rights reserved.
//

import Foundation

protocol EditItemPresenting {
    func present(canSave: Bool)
    func present(updateName: String, error: EditItem.ValidationError?)
    func present(updateCount: String, error: EditItem.ValidationError?)
    func present(error: EditItem.ServiceError?)
    func presentDismiss()
}

extension EditItem {
    
    struct Presenter: EditItemPresenting {
        
        let viewModel: ViewModel
        
        func present(canSave: Bool) {
            viewModel.canSave = canSave
        }
        
        func present(updateName: String, error: ValidationError?) {
            viewModel.itemNameTextFieldInfo.value = updateName
            let errorIsNil = error == nil
            viewModel.itemNameTextFieldInfo.borderColor = errorIsNil ? Theme.tintColor : Theme.errorColor
        }
        
        func present(updateCount: String, error: ValidationError?) {
            viewModel.itemCountTextFieldInfo.value = updateCount
            let errorIsNil = error == nil
            viewModel.itemCountTextFieldInfo.borderColor = errorIsNil ? Theme.tintColor : Theme.errorColor
        }
        
        func present(error: ServiceError?) {
            if let error = error {
                viewModel.error = Strings.displayError(for: error)
            } else {
                viewModel.error = Strings.defaultError
            }
        }
        
        func presentDismiss() {
            viewModel.isPresented.wrappedValue = false
        }
    }
}
