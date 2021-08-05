//
//  ViewProjectDetailsModels.swift
//  Inventory
//
//  Created by Mikael Weiss on 8/4/21.
//  Copyright © 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import SwiftUI

extension ViewProjectDetails {
    
    class ViewModel: ObservableObject {
        let isPresented: Binding<Bool>
        @Published var projectName = ""
        @Published var items = [ItemsGrid.Item]()
        @Published var showEditProject = false
        @Published var showEditItem = false
        @Published var error: ErrorSheet.ViewModel?
        
        init(isPresented: Binding<Bool>) {
            self.isPresented = isPresented
        }
    }
    
    struct Theme {
        static let tintColor = Color.appTintColor
        static let backButtonTitle = Strings.cancelButtonTitle
        static let editButtonTitle = Strings.editButtonTitle
        static let buildProjectButtonTitle = Strings.buildProjectButtonTitle
    }
    
    enum Strings {
        static let cancelButtonTitle = "Cancel"
        static let editButtonTitle = "Edit"
        static let buildProjectButtonTitle = "Build Project"
        
        static func displayError(for error: ServiceError) -> ErrorSheet.ViewModel {
            switch error {
            case .fetchFailed: return .fetchFailed
            }
        }
        
        static let defaultError = ErrorSheet.ViewModel.default
    }
}
