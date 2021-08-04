//
//  ViewProjectsOverviewModels.swift
//  Inventory
//
//  Created by Mikael Weiss on 8/3/21.
//  Copyright © 2021 Fifty6 Incorporated. All rights reserved.
//

import SwiftUI

extension ViewProjectsOverview {
    
    struct ProjectViewModel: Identifiable {
        let id: UUID
        let name: String
    }
    
    class ViewModel: ObservableObject {
        @Published var projects = [ViewProjectsOverview.ProjectViewModel]()
        @Published var showEditProject = false
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
    }
}
