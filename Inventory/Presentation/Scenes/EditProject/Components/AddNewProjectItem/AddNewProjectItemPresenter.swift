//
//  AddNewProjectItemPresenter.swift
//  Inventory
//
//  Created by Mikael Weiss on 8/3/21.
//  Copyright © 2021 Fifty6, Inc. All rights reserved.
//

import Foundation

protocol AddNewProjectItemPresenting {
    func present(updateName: String, error: AddNewProjectItem.ValidationError?)
    func present(updateCount: String, error: AddNewProjectItem.ValidationError?)
    func present(updateNumberPerBuild: String, error: AddNewProjectItem.ValidationError?)
    func present(error: AddNewProjectItem.ServiceError?)
    func present(canSave: Bool)
    func presentDismiss()
}

extension AddNewProjectItem {
    
    struct Presenter: AddNewProjectItemPresenting {
        
        let viewModel: ViewModel
        
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
        
        func present(updateNumberPerBuild: String, error: AddNewProjectItem.ValidationError?) {
            viewModel.numberPerBuildTextFieldInfo.value = updateNumberPerBuild
            let errorIsNil = error == nil
            viewModel.numberPerBuildTextFieldInfo.borderColor = errorIsNil ? Theme.tintColor : Theme.errorColor
        }
        
        
        func present(error: ServiceError?) {
            if let error = error {
                viewModel.error = Strings.displayError(for: error)
            } else {
                viewModel.error = Strings.defaultError
            }
        }
        
        func present(canSave: Bool) {
            viewModel.canSave = canSave
        }
        
        func presentDismiss() {
            viewModel.isPresented.wrappedValue = false
        }
    }
}
