//
//  ViewProjectsOverviewScene.swift
//  Inventory
//
//  Created by Mikael Weiss on 8/3/21.
//  Copyright © 2021 Fifty6, Inc. All rights reserved.
//

import SwiftUI

enum ViewProjectsOverview {
    struct Scene {
        func view(preview: Bool = false) -> some View {
            let usePreviewService = ApplicationState.shared.usePreviewServices || preview
            let service: ViewProjectsOverviewService = usePreviewService ? PreviewService() : buildService()
            let presenter = Presenter(viewModel: ViewModel())
            let interactor = Interactor(service: service, presenter: presenter)
            let view = ContentView(viewModel: presenter.viewModel, interactor: interactor)
            interactor.fetchProjects()
            return view
        }
        
        func buildService() -> Service {
            let projectFetcher = RepositoryRoot.shared.projectRepository
            return Service(projectFetcher: projectFetcher)
        }
    }
}
