//
//  EditProjectPresenter.swift
//  Inventory
//
//  Created by Mikael Weiss on 8/3/21.
//  Copyright © 2021 Fifty6 Incorporated. All rights reserved.
//

import Foundation

protocol EditProjectPresenting {
    func presentFetch(_ project: EditProject.ProjectInfo?)
    func present(allItems: [Item])
    func present(updateName: String, error: EditProject.ValidationError?)
    func present(projectItems: [EditProject.ItemInfo])
    func present(error: EditProject.ServiceError?)
    func present(canSave: Bool)
    func presentDismiss()
}

extension EditProject {
    
    struct Presenter: EditProjectPresenting {
        
        let viewModel: ViewModel
        
        func presentFetch(_ project: EditProject.ProjectInfo?) {
            if let project = project {
                if let name = project.name {
                    present(updateName: name, error: nil)
                }
                
                viewModel.projectItems = mapItemToItemsGridItem(project.items)
                viewModel.showRemoveProjectButton = true
                viewModel.sceneTitle = Strings.sceneEditTitle
            }
        }
        
        func present(allItems: [Item]) {
            viewModel.allItems = mapItemToItemsGridItem(allItems)
        }
        
        func present(updateName: String, error: ValidationError?) {
            viewModel.projectNameTextFieldInfo.value = updateName
            let errorIsNil = error == nil
            viewModel.projectNameTextFieldInfo.borderColor = errorIsNil ? Theme.tintColor : Theme.errorColor
        }
        
        func present(projectItems: [ItemInfo]) {
            viewModel.projectItems = mapItemToItemsGridItem(projectItems)
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
        
        private func mapItemToItemsGridItem(_ items: [Item]) -> [ItemsGrid.Item] {
            let gridItems = items.map {
                ItemsGrid.Item(
                    id: $0.id,
                    name: $0.name,
                    count: "Count: \($0.count)",
                    numberPerBuild: nil)
            }
            return gridItems.sorted(by: { $0.name < $1.name })
        }
        
        private func mapItemToItemsGridItem(_ items: [ItemInfo]) -> [ItemsGrid.Item] {
            let gridItems = items.map {
                ItemsGrid.Item(
                    id: $0.itemID,
                    name: $0.name,
                    count: "\($0.count)",
                    numberPerBuild: "Num/Build: \($0.numberRequiredPerBuild)")
            }
            return gridItems.sorted(by: { $0.name < $1.name })
        }
    }
}
