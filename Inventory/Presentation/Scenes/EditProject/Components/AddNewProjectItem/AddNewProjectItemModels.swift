//
//  AddNewProjectItemModels.swift
//  Inventory
//
//  Created by Mikael Weiss on 8/3/21.
//  Copyright © 2021 Fifty6, Inc. All rights reserved.
//

import SwiftUI

extension AddNewProjectItem {
    
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
        @Published var itemNameTextFieldInfo = TextFieldInfo(placeholder: Strings.itemNameTextFieldPlaceholder)
        @Published var itemCountTextFieldInfo = TextFieldInfo(placeholder: Strings.itemCountTextFieldPlaceholder)
        @Published var numberPerBuildTextFieldInfo = TextFieldInfo(placeholder: Strings.numberPerBuildTextFieldPlaceholder)
        @Published var showRemoveItemButton = false
        
        init(isPresented: Binding<Bool>) {
            self.isPresented = isPresented
        }
    }
    
    struct Theme {
        static let tintColor = Color.appTintColor
        static let errorColor = Color.appErrorColor
        static let sceneTitle = Strings.sceneTitle
        static let cancelButtonTitle = Strings.cancelButtonTitle
        static let saveButtonTitle = Strings.saveButtonTitle
    }
    
    enum Strings {
        static let sceneTitle = "Add Item"
        static let cancelButtonTitle = "Cancel"
        static let saveButtonTitle = "Save"
        static let itemNameTextFieldPlaceholder = "Item name"
        static let itemCountTextFieldPlaceholder = "Item count"
        static let numberPerBuildTextFieldPlaceholder = "Number of items used each build"
        
        static func displayError(for error: ServiceError) -> ErrorSheet.ViewModel {
            switch error {
            case .saveFailed: return .saveFailed
            }
        }
        
        static let defaultError = ErrorSheet.ViewModel.default
    }
}
