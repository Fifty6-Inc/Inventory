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
        static let cancelButtonTitle = Strings.cancelButtonTitle
        static let saveButtonTitle = Strings.saveButtonTitle
        static let deleteButtonTitle = Strings.deleteButtonTitle
        static let deleteItemButtonTitle = Strings.deleteItemButtonTitle
    }
    
    enum Strings {
        static let sceneAddTitle = "Add Project"
        static let sceneEditTitle = "Edit Project"
        static let cancelButtonTitle = "Cancel"
        static let saveButtonTitle = "Save"
        static let deleteButtonTitle = "Delete Project"
        static let deleteItemButtonTitle = "Delete item from project"
        static let projectNameTextFieldPlaceholder = "Project name"
        
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
