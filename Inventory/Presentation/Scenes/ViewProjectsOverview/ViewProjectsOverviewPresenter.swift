//
//  ViewProjectsOverviewPresenter.swift
//  Inventory
//
//  Created by Mikael Weiss on 8/3/21.
//  Copyright © 2021 Fifty6 Incorporated. All rights reserved.
//

import Foundation

protocol ViewProjectsOverviewPresenting {
    func presentFetch(_ projects: [ViewProjectsOverview.ProjectDetails])
    func presentShowEditProject()
    func present(error: ViewProjectsOverview.ServiceError?)
}

extension ViewProjectsOverview {
    
    struct Presenter: ViewProjectsOverviewPresenting {
        
        let viewModel: ViewModel
        
        func presentFetch(_ projects: [ViewProjectsOverview.ProjectDetails]) {
            viewModel.projects = projects.map {
                ViewProjectsOverview.ProjectViewModel(
                    id: $0.id,
                    name: $0.name)
            }
        }
        
        func presentShowEditProject() {
            viewModel.showEditProject = true
        }
        
        func present(error: ServiceError?) {
            if let error = error {
                viewModel.error = Strings.displayError(for: error)
            } else {
                viewModel.error = Strings.defaultError
            }
        }
    }
}
