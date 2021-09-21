//
//  AddNewProjectItemScene.swift
//  Inventory
//
//  Created by Mikael Weiss on 8/3/21.
//  Copyright © 2021 Fifty6, Inc. All rights reserved.
//

import SwiftUI

enum AddNewProjectItem {
    
    // MARK: - Build scene
    
    struct Scene {
        func view(preview: Bool = false, isPresented: Binding<Bool>) -> some View {
            let service: AddNewProjectItemService = preview ? PreviewService() : buildService()
            let presenter = Presenter(viewModel: ViewModel(isPresented: isPresented))
            let interactor = Interactor(service: service, presenter: presenter)
            let view = ContentView(viewModel: presenter.viewModel, interactor: interactor)
            return view
        }
        
        private func buildService() -> Service {
            guard let input = AddNewProjectItem.input
            else { fatalError("Required input is missing (\(#file))") }
            
            return Service(onSave: input.onSave)
        }
    }
    
    // MARK: - Scene input
    
    private struct Input {
        let onSave: (AddNewProjectItem.ItemInfo) -> Void
    }
    private static var input: Input?
    static func prepareIncomingRoute(onSave: @escaping (AddNewProjectItem.ItemInfo) -> Void) {
        input = Input(onSave: onSave)
    }
}
