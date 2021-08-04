//
//  ViewItemsOverviewView.swift
//  Inventory
//
//  Created by Mikael Weiss on 8/3/21.
//  Copyright © 2021 Fifty6 Incorporated. All rights reserved.
//

import SwiftUI

extension ViewItemsOverview {
    struct ContentView: View {
        typealias Theme = ViewItemsOverview.Theme
        @ObservedObject var viewModel: ViewModel
        let interactor: ViewItemsOverviewInteracting
        
        let layout = [
            GridItem(.adaptive(minimum: 150))
        ]
        
        var body: some View {
            NavigationView {
                ScrollView {
                    VStack(spacing: 10) {
                        Text(Theme.itemsTitle)
                            .font(.system(size: 56, weight: .heavy, design: .rounded))
                            .frame(maxWidth: .infinity, alignment: .center)
                        LazyVGrid(columns: layout) {
                            ForEach(viewModel.items) { item in
                                RoundedRectangle(cornerRadius: 16, style: .continuous)
                                    .fill(Color.blue)
                                    .inverseMask {
                                        VStack {
                                            Text(item.name)
                                            Text(item.count)
                                        }
                                    }
                                    .frame(height: 150)
                                    .onTapGesture {
                                        didTapItem(with: item.id)
                                    }
                            }
                        }
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
                .sheet(isPresented: $viewModel.showAddItem) {
                    EditItem.Scene().view(isPresented: $viewModel.showAddItem)
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
