//
//  ViewProjectDetailsView.swift
//  Inventory
//
//  Created by Mikael Weiss on 8/4/21.
//  Copyright © 2021 Fifty6, Inc. All rights reserved.
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
                    ProjectTitleBar(
                        title: viewModel.projectName,
                        onBack: didTapBack,
                        onEdit: didTapEdit)
                        .frame(maxHeight: .infinity, alignment: .top)
                        .padding(.bottom)
                    
                    ItemsGrid(
                        items: viewModel.items,
                        didTapItem: interactor.didTapItem(with:))
                        .padding(.horizontal)
                        .sheet(isPresented: $viewModel.showEditItem) {
                            EditItem.Scene().view(isPresented: $viewModel.showEditItem)
                        }
                }
                HStack {
                    StandardButton(
                        title: Theme.buildProjectButtonTitle,
                        action: buildProject)
                        .frame(maxWidth: .infinity)
                    Button(action: recieveParts) {
                        Image(systemName: "arrow.counterclockwise")
                            .foregroundColor(.appWhite)
                            .font(.system(size: 28, weight: .bold, design: .rounded))
                            .padding(12)
                            .background(
                                Circle()
                                    .fill(Color.appTintColor)
                            )
                    }
                    
                }
                .padding(.bottom)
                .padding(.horizontal)
                .frame(maxHeight: .infinity, alignment: .bottom)
            }
            .navigationBarHidden(true)
            .errorSheet($viewModel.error)
            .sheet(isPresented: $viewModel.showEditProject) {
                EditProject.Scene().view(isPresented: $viewModel.showEditProject)
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
    
    func recieveParts() {
        withAnimation {
            interactor.recieveParts()
        }
    }
    
    func didTapBack() {
        interactor.dismiss()
    }
    
    func didTapEdit() {
        interactor.edit()
    }
}

// MARK: - Previews

struct ViewProjectDetails_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ViewProjectDetails.Scene().view(preview: true, isPresented: .constant(true))
                .preferredColorScheme(.dark)
        }
    }
}
