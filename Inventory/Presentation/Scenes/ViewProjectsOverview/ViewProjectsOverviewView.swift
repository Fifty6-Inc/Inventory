//
//  ViewProjectsOverviewView.swift
//  Inventory
//
//  Created by Mikael Weiss on 8/3/21.
//  Copyright © 2021 Fifty6, Inc. All rights reserved.
//

import SwiftUI

extension ViewProjectsOverview {
    struct ContentView: View {
        typealias Theme = ViewProjectsOverview.Theme
        @ObservedObject var viewModel: ViewModel
        let interactor: ViewProjectsOverviewInteracting
        
        var body: some View {
            NavigationView {
                ScrollView {
                    TitleBar(title: Theme.projectsTitle,
                             onAdd: didTapAdd,
                             onHiddenGesture: onHiddenGesture)
                    ProjectsGrid(projects: viewModel.projects,
                                 didTapProject: didTapProject(with:))
                    .padding(.horizontal)
                }
                .navigationBarHidden(true)
                .errorSheet($viewModel.error)
                .sheet(isPresented: $viewModel.showAddProject) {
                    EditProject.Scene().view(isPresented: $viewModel.showAddProject)
                }
                .navLink(isActive: $viewModel.showProjectDetails) {
                    ViewProjectDetails.Scene().view(isPresented: $viewModel.showProjectDetails)
                }
            }
            .gradientNavBar()
        }
    }
}

// MARK: - Interacting

extension ViewProjectsOverview.ContentView {
    func didTapProject(with id: UUID) {
        interactor.didTapProject(with: id)
    }
    
    func didTapAdd() {
        interactor.add()
    }
    
    func onHiddenGesture() {
        interactor.onHiddenGesture()
    }
}

// MARK: - Previews

struct ViewProjectsOverview_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ViewProjectsOverview.Scene().view(preview: true)
        }
    }
}
