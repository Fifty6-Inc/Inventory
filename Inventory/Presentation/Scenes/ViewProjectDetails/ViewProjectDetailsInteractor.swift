//
//  ViewProjectDetailsInteractor.swift
//  Inventory
//
//  Created by Mikael Weiss on 8/4/21.
//  Copyright © 2021 Fifty6, Inc. All rights reserved.
//

import Foundation
import Combine
import SwiftUI

protocol ViewProjectDetailsInteracting {
    func dismiss()
    func edit()
    func didTapItem(with id: UUID)
    func buildProject()
    func recieveParts()
}

extension ViewProjectDetails {
    
    struct Interactor: ViewProjectDetailsInteracting {
        let service: ViewProjectDetailsService
        let presenter: ViewProjectDetailsPresenting
        private var updateSubscriber: AnyCancellable?
        
        init(service: ViewProjectDetailsService,
             presenter: ViewProjectDetailsPresenting) {
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
            fetchProject()
        }
        
        func fetchProject() {
            do {
                let project = try service.fetchProject()
                presenter.presentFetch(project)
            } catch {
                presenter.present(error: error as? ServiceError)
            }
        }
        
        func dismiss() {
            presenter.presentDismiss()
        }
        
        func edit() {
            service.prepareRouteToEditProject(onDelete: dismiss)
            presenter.presentPrepareRouteToEditProject()
        }
        
        func didTapItem(with id: UUID) {
            service.prepareRouteToEditItemCount(with: id)
            presenter.presentPrepareRouteToEditItem()
        }
        
        func buildProject() {
            do {
                try service.buildProject()
            } catch {
                presenter.present(error: error as? ServiceError)
            }
        }
        
        func recieveParts() {
            do {
                try service.recieveParts()
            } catch {
                presenter.present(error: error as? ServiceError)
            }
        }
    }
}
