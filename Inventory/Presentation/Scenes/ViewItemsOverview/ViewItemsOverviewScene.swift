//
//  ViewItemsOverviewScene.swift
//  Inventory
//
//  Created by Mikael Weiss on 8/3/21.
//  Copyright © 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import SwiftUI

enum ViewItemsOverview {
    struct Scene {
        func view(preview: Bool = false) -> some View {
            let service: ViewItemsOverviewService = preview ? PreviewService() : Service()
            let presenter = Presenter(viewModel: ViewModel())
            let interactor = Interactor(service: service, presenter: presenter)
            let view = ContentView(viewModel: presenter.viewModel, interactor: interactor)
            return view
        }
    }
}
