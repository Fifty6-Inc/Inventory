//
//  ErrorSheetView.swift
//  Inventory
//
//  Created by Mikael Weiss on 8/3/21.
//  Copyright © 2021 Fifty6, Inc. All rights reserved.
//

import SwiftUI
enum ErrorSheet {
    fileprivate struct ErrorSheetView: View {
        private let tintColor = Color.appTintColor
        @Binding var viewModel: ViewModel?
        
        var body: some View {
            ZStack {
                if viewModel != nil {
                    LinearGradient(gradient: Gradient(colors: [Color.black, Color.black.opacity(0.32)]), startPoint: .bottom, endPoint: .top)
                        .ignoresSafeArea()
                        .onTapGesture(perform: dismiss)
                        .transition(.opacity)
                }
                if let viewModel = viewModel {
                    VStack(spacing: 0) {
                        Spacer()
                        VStack(spacing: 0) {
                            // Title and close button
                            HStack(spacing: 0) {
                                Text(viewModel.title)
                                    .font(.system(size: 24, weight: .bold, design: .rounded))
                                    .foregroundColor(.appWhite)
                                Spacer()
                                Button(action: dismiss,
                                       label: {
                                    Image(systemName: "xmark")
                                        .font(.system(size: 20, weight: .bold, design: .rounded))
                                })
                                    .foregroundColor(tintColor)
                            }
                            
                            // Body text
                            Text(viewModel.body)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(EdgeInsets(top: 13, leading: 0, bottom: 24, trailing: 26))
                                .font(.system(size: 18, weight: .semibold, design: .rounded))
                                .lineSpacing(5)
                                .foregroundColor(.appGrayLight)
                            
                            // Dismiss Button
                            StandardButton(
                                title: viewModel.dismissButtonTitle,
                                action: dismiss)
                        }
                        .padding([.horizontal, .top], 24)
                        .padding(.bottom, 50)
                        .background(
                            RoundedRectangle(cornerRadius: 30)
                                .foregroundColor(.appGrayDark)
                        )
                        .offset(y: 50)
                        .shadow(color: Color.black.opacity(0.5), radius: 20, x: 0, y: 2)
                    }
                    .transition(.move(edge: .bottom))
                    .zIndex(1)
                }
            }
            .animation(.easeIn)
        }
        
        private func dismiss() {
            viewModel = nil
        }
    }
}

// MARK: - View Extension

extension View {
    func errorSheet(_ viewModel: Binding<ErrorSheet.ViewModel?>) -> some View {
        ZStack {
            self
            ErrorSheet.ErrorSheetView(viewModel: viewModel)
        }
    }
}

// MARK: - Preview stuff
struct ErrorSheet_Previews: PreviewProvider {
    static var previews: some View {
        TestView()
    }
    
    struct TestView: View {
        @State private var viewModel: ErrorSheet.ViewModel? = .default
        
        var body: some View {
            Color.appTintColor
                .ignoresSafeArea()
                .onTapGesture {
                    viewModel = .default
                }
                .errorSheet($viewModel)
        }
    }
}
