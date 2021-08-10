//
//  EditProjectModels.swift
//  Inventory
//
//  Created by Mikael Weiss on 8/3/21.
//  Copyright © 2021 Fifty6 Incorporated. All rights reserved.
//

import SwiftUI

extension EditProject {
    
    struct TextFieldInfo {
        var placeholder = ""
        var value = ""
        var state: ValidationError? = nil
        var borderColor = Theme.tintColor
    }
    
    enum AddProjectItem {
        struct Request {
            let itemID: UUID
            let numberRequiredPerBuild: Int
        }
    }
    
    class ViewModel: ObservableObject {
        let isPresented: Binding<Bool>
        @Published var canSave = false
        @Published var error: ErrorSheet.ViewModel?
        @Published var projectNameTextFieldInfo = TextFieldInfo(placeholder: Strings.projectNameTextFieldPlaceholder)
        @Published var showRemoveProjectButton = false
        @Published var sceneTitle = Strings.sceneAddTitle
        @Published var projectItems = [ItemsGrid.Item]()
        @Published var showAllItems = false
        @Published var allItems = [ItemsGrid.Item]()
        
        init(isPresented: Binding<Bool>) {
            self.isPresented = isPresented
        }
    }
    
    struct Theme {
        static let tintColor = Color.appTintColor
        static let errorColor = Color.appErrorColor
        static let itemsTitle = Strings.itemsTitle
        static let cancelButtonTitle = Strings.cancelButtonTitle
        static let saveButtonTitle = Strings.saveButtonTitle
        static let deleteButtonTitle = Strings.deleteButtonTitle
        
        static let addItemButtonTitle = Strings.addItemButtonTitle
        
        static let numberPerBuildTitle = Strings.numberPerBuildTitle
        static let mustBeIntegerValueTextFieldErrorMessage = Strings.mustBeIntegerValueTextFieldErrorMessage
        
        static let confirmRemoveItemTitle = Strings.confirmRemoveItemTitle
        static let confirmRemoveItemMessage = Strings.confirmRemoveItemMessage
        static let confirmRemoveItemButtonTitle = Strings.confirmRemoveItemButtonTitle
        
        static let confirmDeleteProjectTitle = Strings.confirmDeleteProjectTitle
        static let confirmDeleteProjectMessage = Strings.confirmDeleteProjectMessage
        static let confirmDeleteProjectButtonTitle = Strings.confirmDeleteProjectButtonTitle
    }
    
    enum Strings {
        static let itemsTitle = "Items"
        static let sceneAddTitle = "Add Project"
        static let sceneEditTitle = "Edit Project"
        static let cancelButtonTitle = "Cancel"
        static let saveButtonTitle = "Save"
        static let deleteButtonTitle = "Delete Project"
        static let projectNameTextFieldPlaceholder = "Project name"
        
        static let addItemButtonTitle = "Add Item"
        
        static let numberPerBuildTitle = "Number Required Per Build"
        static let mustBeIntegerValueTextFieldErrorMessage = "Must be integer value"
        
        static let confirmRemoveItemTitle = "You sure?"
        static let confirmRemoveItemMessage = "Are you sure you want to remove this item from the project?"
        static let confirmRemoveItemButtonTitle = "Remove item from project"
        
        static let confirmDeleteProjectTitle = "You sure?"
        static let confirmDeleteProjectMessage = "Are you sure you want to delete this project? This action cannot be undone."
        static let confirmDeleteProjectButtonTitle = "Delete Project"
        
        static func displayError(for error: ServiceError) -> ErrorSheet.ViewModel {
            switch error {
            case .saveFailed: return .saveFailed
            case .fetchFailed: return .fetchFailed
            case .invalidInput:
                let message = "Some value is either missing or incorrect. Please make sure all values are entered correctly"
                return .default(with: message)
            case .deleteFailed:
                let message = "Unable to delete. Please try again."
                return .default(with: message)
            case .addItemFailed:
                let message = "Unable to add item to project. Please try again."
                return .default(with: message)
            }
        }
        
        static let defaultError = ErrorSheet.ViewModel.default
    }
}
