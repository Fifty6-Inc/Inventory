//
//  EditItemScene.swift
//  Inventory
//
//  Created by Mikael Weiss on 8/3/21.
//  Copyright © 2021 Fifty6 Incorporated. All rights reserved.
//

import SwiftUI

enum EditItem {
    
    // MARK: - Build scene
    
    struct Scene {
        func view(preview: Bool = false, isPresented: Binding<Bool>) -> some View {
            let service: EditItemService = preview ? PreviewService() : buildService()
            let presenter = Presenter(viewModel: ViewModel(isPresented: isPresented))
            let interactor = Interactor(service: service, presenter: presenter)
            let view = ContentView(viewModel: presenter.viewModel, interactor: interactor)
            interactor.fetchItem()
            return view
        }
        
        private func buildService() -> Service {
            guard let input = EditItem.input
            else { fatalError("Required input is missing (\(#file))") }
            
            return Service(
                itemFetching: RepositoryRoot.shared.itemRepository,
                projectFetching: RepositoryRoot.shared.projectRepository,
                itemID: input.itemID)
        }
    }
    
    // MARK: - Scene input
    
    private struct Input {
        let itemID: UUID?
    }
    private static var input: Input?
    static func prepareIncomingRoute(with itemID: UUID?) {
        input = Input(itemID: itemID)
    }
}
