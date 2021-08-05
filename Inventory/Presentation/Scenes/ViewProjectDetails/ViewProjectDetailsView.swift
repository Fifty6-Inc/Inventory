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
        
        var sheetBinding: Binding<Bool> {
            Binding(get: {
                viewModel.showEditProject || viewModel.showEditItem
            }, set: { dismiss in
                if dismiss {
                    viewModel.showEditProject = false
                    viewModel.showEditItem = false
                }
            })
        }
        
        var body: some View {
            ZStack {
                ScrollView {
                    Text(viewModel.projectName)
                        .font(.system(.largeTitle, design: .rounded))
                        .fontWeight(.medium)
                    
                    ItemsGrid(
                        items: viewModel.items,
                        didTapItem: interactor.didTapItem(with:))
                }
                VStack {
                    Spacer()
                    StandardButton(
                        title: Theme.buildProjectButtonTitle,
                        action: buildProject)
                        .padding(.horizontal)
                }
            }
            .navigationTitle(Theme.sceneTitle)
            .navigationBarItems(leading: cancelButton, trailing: editButton)
            .navigationBarBackButtonHidden(true)
            .accentColor(Theme.tintColor)
            .errorSheet($viewModel.error)
            .sheet(isPresented: sheetBinding) {
                if viewModel.showEditProject {
                    EditProject.Scene().view(isPresented: sheetBinding)
                } else {
                    EditItem.Scene().view(isPresented: sheetBinding)
                }
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
