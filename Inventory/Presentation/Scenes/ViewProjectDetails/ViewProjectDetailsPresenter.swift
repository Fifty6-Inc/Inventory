//
//  ViewProjectDetailsPresenter.swift
//  Inventory
//
//  Created by Mikael Weiss on 8/4/21.
//  Copyright © 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import Foundation

protocol ViewProjectDetailsPresenting {
    func presentPrepareRouteToEditProject()
    func presentPrepareRouteToEditItem()
    func presentFetch(_ projectInfo: ViewProjectDetails.ProjectInfo)
    func present(error: ViewProjectDetails.ServiceError?)
    func presentDismiss()
}

extension ViewProjectDetails {
    struct Presenter: ViewProjectDetailsPresenting {
        
        let viewModel: ViewModel
        
        func presentFetch(_ projectInfo: ProjectInfo) {
            viewModel.projectName = projectInfo.name
            viewModel.items = projectInfo.items.map {
                ItemsGrid.Item(
                    id: $0.itemID,
                    name: $0.name,
                    count: "Count: \($0.count)",
                    numberPerBuild: "Num/Build: \($0.numberRequiredPerBuild)")
            }
        }
        
        func presentPrepareRouteToEditProject() {
            viewModel.showEditProject = true
        }
        
        func presentPrepareRouteToEditItem() {
            viewModel.showEditItem = true
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
