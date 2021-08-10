//
//  ViewProjectsOverviewView.swift
//  Inventory
//
//  Created by Mikael Weiss on 8/3/21.
//  Copyright © 2021 Fifty6 Incorporated. All rights reserved.
//

import SwiftUI

extension ViewProjectsOverview {
    struct ContentView: View {
        typealias Theme = ViewProjectsOverview.Theme
        @ObservedObject var viewModel: ViewModel
        let interactor: ViewProjectsOverviewInteracting
        
        let layout = [
            GridItem(.adaptive(minimum: 150))
        ]
        
        var body: some View {
            NavigationView {
                ScrollView {
                    VStack(spacing: 10) {
                        Text(Theme.projectsTitle)
                            .font(.system(size: 56, weight: .heavy, design: .rounded))
                            .frame(maxWidth: .infinity, alignment: .center)
                        LazyVGrid(columns: layout) {
                            ForEach(viewModel.projects) { project in
                                RoundedRectangle(cornerRadius: 16, style: .continuous)
                                    .fill(Color.appTintColor)
                                    .inverseMask {
                                        VStack {
                                            Text(project.name)
                                        }
                                    }
                                    .frame(height: 150)
                                    .onTapGesture {
                                        didTapProject(with: project.id)
                                    }
                            }
                        }
                    }
                    NavigationLink(
                        destination: ViewProjectDetails.Scene().view(isPresented: $viewModel.showProjectDetails),
                        isActive: $viewModel.showProjectDetails,
                        label: { EmptyView() })
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
                .sheet(isPresented: $viewModel.showAddProject) {
                    EditProject.Scene().view(isPresented: $viewModel.showAddProject)
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

extension ViewProjectsOverview.ContentView {
    func didTapProject(with id: UUID) {
        interactor.didTapProject(with: id)
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
