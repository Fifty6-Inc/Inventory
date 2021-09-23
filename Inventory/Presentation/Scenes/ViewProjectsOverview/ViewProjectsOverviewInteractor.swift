//
//  ViewProjectsOverviewInteractor.swift
//  Inventory
//
//  Created by Mikael Weiss on 8/3/21.
//  Copyright © 2021 Fifty6, Inc. All rights reserved.
//

import Foundation
import Combine
import SwiftUI

protocol ViewProjectsOverviewInteracting {
    func fetchProjects()
    func didTapProject(with id: UUID)
    func add()
    func onHiddenGesture()
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
                    withAnimation {
                        handleRefresh()
                    }
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
            service.prepareRouteToProject(with: id)
            presenter.presentShowProjectDetails()
        }
        
        func add() {
            service.prepareRouteToAddProject()
            presenter.presentShowAddProject()
        }
        
        func onHiddenGesture() {
            #if DEBUG
            service.onHiddenGesture()
            presenter.presentOnHiddenGesture()
            #endif
        }
    }
}
