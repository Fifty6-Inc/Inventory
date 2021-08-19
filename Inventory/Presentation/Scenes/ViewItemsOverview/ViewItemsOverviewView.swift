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
                    VStack(spacing: 10) {
                        Text(Theme.itemsTitle)
                            .font(.system(size: 56, weight: .heavy, design: .rounded))
                            .frame(maxWidth: .infinity, alignment: .center)
                        ItemsGrid(
                            items: viewModel.items,
                            didTapItem: didTapItem(with:))
                    }
                }
                .padding(.horizontal)
                .navigationBarTitleDisplayMode(.inline)
                .navigationBarItems(trailing: addButton)
                .toolbar {
                    ToolbarItem(placement: .principal) {
                        Logo()
                    }
                }
                .navigationBarBackButtonHidden(true)
                .accentColor(Theme.tintColor)
                .errorSheet($viewModel.error)
                .sheet(isPresented: $viewModel.showEditItem) {
                    EditItem.Scene().view(isPresented: $viewModel.showEditItem)
                }
            }
        }
        
        var addButton: some View {
            Button(action: interactor.add) {
                Image(systemName: "plus")
                    .font(.system(size: 16, weight: .heavy, design: .rounded))
                    .contentShape(Rectangle())
                    .accentColor(Theme.tintColor)
            }
        }
    }
}

// MARK: - Interacting

extension ViewItemsOverview.ContentView {
    func didTapItem(with id: UUID) {
        interactor.didTapItem(with: id)
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
