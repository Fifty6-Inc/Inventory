//
//  EditProjectScene.swift
//  Inventory
//
//  Created by Mikael Weiss on 8/3/21.
//  Copyright © 2021 Fifty6 Incorporated. All rights reserved.
//

import SwiftUI

enum EditProject {
    
    // MARK: - Build scene
    
    struct Scene {
        func view(preview: Bool = false, isPresented: Binding<Bool>) -> some View {
            let service: EditProjectService = preview ? PreviewService() : buildService()
            let presenter = Presenter(viewModel: ViewModel(isPresented: isPresented))
            let interactor = Interactor(service: service, presenter: presenter)
            let view = ContentView(viewModel: presenter.viewModel, interactor: interactor)
            interactor.fetchProject()
            interactor.fetchAllItems()
            return view
        }
        
        private func buildService() -> Service {
            guard let input = EditProject.input
            else { fatalError("Required input is missing (\(#file))") }
            let projectFetcher = RepositoryRoot.shared.projectRepository
            let itemsFetcher = RepositoryRoot.shared.itemRepository
            
            return Service(
                projectFetcher: projectFetcher,
                itemsFetcher: itemsFetcher,
                projectID: input.projectID)
        }
    }
    
    // MARK: - Scene input
    
    private struct Input {
        let projectID: UUID?
    }
    private static var input: Input?
    static func prepareIncomingRoute(with projectID: UUID?) {
        input = Input(projectID: projectID)
    }
}
