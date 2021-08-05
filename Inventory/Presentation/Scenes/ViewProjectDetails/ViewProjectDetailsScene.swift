//
//  ViewProjectDetailsScene.swift
//  Inventory
//
//  Created by Mikael Weiss on 8/4/21.
//  Copyright © 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import SwiftUI

enum ViewProjectDetails {
    
    // MARK: - Build scene
    
    struct Scene {
        
        func view(preview: Bool = false, isPresented: Binding<Bool>) -> some View {
            let service: ViewProjectDetailsService = preview ? PreviewService() : buildService()
            let presenter = Presenter(viewModel: ViewModel(isPresented: isPresented))
            let interactor = Interactor(service: service, presenter: presenter)
            let view = ContentView(viewModel: presenter.viewModel, interactor: interactor)
            interactor.fetchProject()
            return view
        }
        
        private func buildService() -> Service {
            guard let input = ViewProjectDetails.input
            else { fatalError("Required input is missing (\(#file))") }
            
            return Service(
                projectFetcher: RepositoryRoot.shared.projectRepository,
                itemFetcher: RepositoryRoot.shared.itemRepository,
                projectID: input.projectID)
        }
    }
    
    // MARK: - Scene input
    struct Input {
        let projectID: UUID
    }
    static var input: Input? = Input(projectID: UUID())
    static func prepareIncomingRoute(with projectID: UUID) {
        input = Input(projectID: projectID)
    }
}
