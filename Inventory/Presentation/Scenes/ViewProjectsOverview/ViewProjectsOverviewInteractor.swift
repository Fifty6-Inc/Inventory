//
//  ViewProjectsOverviewInteractor.swift
//  Inventory
//
//  Created by Mikael Weiss on 8/3/21.
//  Copyright © 2021 Fifty6 Incorporated. All rights reserved.
//

import Foundation
import Combine

protocol ViewProjectsOverviewInteracting {
    func fetchProjects()
    func didTapProject(with id: UUID)
    func add()
}

extension ViewProjectsOverview {
    
    struct Interactor: ViewProjectsOverviewInteracting {
        let service: ViewProjectsOverviewService
        let presenter: ViewProjectsOverviewPresenting
        private var updateSubscriber: AnyCancellable?
        
        init(service: ViewProjectsOverviewService, presenter: ViewProjectsOverviewPresenting) {
            self.service = service
            self.presenter = presenter
            self.updateSubscriber = service.updatePublisher
                .receive(on: RunLoop.main)
                .sink { [self] _ in
                    handleRefresh()
                }
        }
        
        private func handleRefresh() {
            fetchProjects()
        }
        
        func fetchProjects() {
            do {
                let projects = try service.fetchProjects()
                presenter.presentFetch(projects)
            } catch {
                presenter.present(error: error as? ServiceError)
            }
        }
        
        func didTapProject(with id: UUID) {
            service.prepareRouteToEditProject(with: id)
            presenter.presentShowEditProject()
        }
        
        func add() {
            service.prepareRouteToEditProject(with: nil)
            presenter.presentShowEditProject()
        }
    }
}
