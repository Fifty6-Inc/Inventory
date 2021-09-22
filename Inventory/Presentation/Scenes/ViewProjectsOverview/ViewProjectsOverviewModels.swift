//
//  ViewProjectsOverviewModels.swift
//  Inventory
//
//  Created by Mikael Weiss on 8/3/21.
//  Copyright © 2021 Fifty6, Inc. All rights reserved.
//

import SwiftUI

extension ViewProjectsOverview {
    
    class ViewModel: ObservableObject {
        @Published var projects = [ProjectsGrid.Project]()
        @Published var showAddProject = false
        @Published var showProjectDetails = false
        @Published var error: ErrorSheet.ViewModel?
    }
    
    struct Theme {
        static let tintColor = Color.appTintColor
        static let projectsTitle = Strings.projectsTitle
    }
    
    enum Strings {
        static let projectsTitle = "Projects"
        
        static func displayError(for error: ServiceError) -> ErrorSheet.ViewModel {
            switch error {
            case .fetchFailed:
                return .fetchFailed
            }
        }
        
        static let defaultError = ErrorSheet.ViewModel.default
        static let previewServiceError = ErrorSheet.ViewModel(
            title: "Preview Service!",
            body: "You have activated or deactivated preview services!",
            dismissButtonTitle: "Epic")
    }
}
