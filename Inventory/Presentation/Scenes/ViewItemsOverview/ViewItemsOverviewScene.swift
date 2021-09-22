//
//  ViewItemsOverviewScene.swift
//  Inventory
//
//  Created by Mikael Weiss on 8/3/21.
//  Copyright © 2021 Fifty6, Inc. All rights reserved.
//

import SwiftUI

enum ViewItemsOverview {
    struct Scene {
        func view(preview: Bool = false) -> some View {
            let usePreviewService = ApplicationState.shared.usePreviewServices || preview
            let service: ViewItemsOverviewService = usePreviewService ? PreviewService() : buildService()
            let presenter = Presenter(viewModel: ViewModel())
            let interactor = Interactor(service: service, presenter: presenter)
            let view = ContentView(viewModel: presenter.viewModel, interactor: interactor)
            interactor.fetchItems()
            return view
        }
        
        func buildService() -> Service {
            let itemFetcher = RepositoryRoot.shared.itemRepository
            return Service(itemFetcher: itemFetcher)
        }
    }
}
