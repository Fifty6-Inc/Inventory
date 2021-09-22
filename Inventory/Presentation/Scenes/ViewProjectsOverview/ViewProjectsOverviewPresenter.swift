//
//  ViewProjectsOverviewPresenter.swift
//  Inventory
//
//  Created by Mikael Weiss on 8/3/21.
//  Copyright © 2021 Fifty6, Inc. All rights reserved.
//

import Foundation

protocol ViewProjectsOverviewPresenting {
    func presentFetch(_ projects: [ViewProjectsOverview.ProjectDetails])
    func presentShowAddProject()
    func presentShowProjectDetails()
    func present(error: ViewProjectsOverview.ServiceError?)
    func presentOnHiddenGesture()
}

extension ViewProjectsOverview {
    
    struct Presenter: ViewProjectsOverviewPresenting {
        
        let viewModel: ViewModel
        
        func presentFetch(_ projects: [ViewProjectsOverview.ProjectDetails]) {
            let sortedProjects = projects.sorted(by: { $0.name < $1.name })
            viewModel.projects = sortedProjects.map {
                ProjectsGrid.Project(
                    id: $0.id,
                    name: $0.name)
            }
        }
        
        func presentShowAddProject() {
            viewModel.showAddProject = true
        }
        
        func presentShowProjectDetails() {
            viewModel.showProjectDetails = true
        }
        
        func present(error: ServiceError?) {
            if let error = error {
                viewModel.error = Strings.displayError(for: error)
            } else {
                viewModel.error = Strings.defaultError
            }
        }
        
        func presentOnHiddenGesture() {
            viewModel.error = Strings.previewServiceError
        }
    }
}
