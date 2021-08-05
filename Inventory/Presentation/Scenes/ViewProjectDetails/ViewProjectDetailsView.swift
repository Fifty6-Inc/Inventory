//
//  ViewProjectDetailsView.swift
//  Inventory
//
//  Created by Mikael Weiss on 8/4/21.
//  Copyright © 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import SwiftUI

extension ViewProjectDetails {
    struct ContentView: View {
        typealias Theme = ViewProjectDetails.Theme
        @ObservedObject var viewModel: ViewModel
        let interactor: ViewProjectDetailsInteracting
        
        var body: some View {
            ZStack {
                ScrollView {
                    ItemsGrid(
                        items: viewModel.items,
                        didTapItem: interactor.didTapItem(with:))
                        .padding(.horizontal)
                        .sheet(isPresented: $viewModel.showEditItem) {
                            EditItem.Scene().view(isPresented: $viewModel.showEditItem)
                        }
                }
                StandardButton(
                    title: Theme.buildProjectButtonTitle,
                    action: buildProject)
                    .frame(maxHeight: .infinity, alignment: .bottom)
                    .padding(.horizontal)
                    .padding(.bottom)
            }
            .navigationBarTitleDisplayMode(.large)
            .navigationTitle(viewModel.projectName)
            .navigationBarItems(leading: cancelButton, trailing: editButton)
            .navigationBarBackButtonHidden(true)
            .accentColor(Theme.tintColor)
            .errorSheet($viewModel.error)
            .sheet(isPresented: $viewModel.showEditProject) {
                EditProject.Scene().view(isPresented: $viewModel.showEditProject)
            }
        }
        
        var cancelButton: some View {
            Button(action: interactor.dismiss) {
                Image(systemName: "arrow.left")
                    .font(.system(size: 16, weight: .bold, design: .rounded))
                    .contentShape(Rectangle())
                    .accentColor(Theme.tintColor)
            }
        }
        
        var editButton: some View {
            Button(action: interactor.edit) {
                Text(Theme.editButtonTitle)
                    .font(.system(size: 17, weight: .medium, design: .rounded))
                    .accentColor(Theme.tintColor)
            }
        }
    }
}

// MARK: - Interacting

extension ViewProjectDetails.ContentView {
    func buildProject() {
        withAnimation {
            interactor.buildProject()
        }
    }
}

// MARK: - Previews

struct ViewProjectDetails_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ViewProjectDetails.Scene().view(preview: true, isPresented: .constant(true))
        }
    }
}
