//
//  ViewItemsOverviewView.swift
//  Inventory
//
//  Created by Mikael Weiss on 8/3/21.
//  Copyright © 2021 Fifty6, Inc. All rights reserved.
//

import SwiftUI

extension ViewItemsOverview {
    struct ContentView: View {
        typealias Theme = ViewItemsOverview.Theme
        @ObservedObject var viewModel: ViewModel
        let interactor: ViewItemsOverviewInteracting
        
        var body: some View {
            NavigationView {
                ScrollView {
                    VStack {
                        TitleBar(title: Theme.itemsTitle, onAdd: didTapAdd)
                        ItemsGrid(
                            items: viewModel.items,
                            didTapItem: didTapItem(with:))
                            .padding(.horizontal, 18)
                    }
                }
                .navigationBarHidden(true)
                .errorSheet($viewModel.error)
                .sheet(isPresented: $viewModel.showEditItem) {
                    EditItem.Scene().view(isPresented: $viewModel.showEditItem)
                }
            }
        }
    }
}

// MARK: - Interacting

extension ViewItemsOverview.ContentView {
    func didTapItem(with id: UUID) {
        interactor.didTapItem(with: id)
    }
    
    func didTapAdd() {
        interactor.add()
    }
}

// MARK: - Previews

struct ViewItemsOverview_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ViewItemsOverview.Scene().view(preview: true)
        }
    }
}
