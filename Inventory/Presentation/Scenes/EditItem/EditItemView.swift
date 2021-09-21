//
//  EditItemView.swift
//  Inventory
//
//  Created by Mikael Weiss on 8/3/21.
//  Copyright © 2021 Fifty6, Inc. All rights reserved.
//

import SwiftUI

extension EditItem {
    struct ContentView: View {
        @State private var showConfirmDeleteActionSheet = false
        typealias Theme = EditItem.Theme
        @ObservedObject var viewModel: ViewModel
        let interactor: EditItemInteracting
        
        var body: some View {
            NavigationView {
                ScrollView {
                    VStack(spacing: 16) {
                        Field(info: viewModel.itemNameTextFieldInfo, update: interactor.updateName)
                        Field(info: viewModel.itemCountTextFieldInfo, update: interactor.updateCount)
                            .keyboardType(.numberPad)
                        
                        GeometryReader { geo in
                            HStack(spacing: 16) {
                                CountButton(
                                    totalWidth: geo.size.width,
                                    negative: true,
                                    imageName: "chevron.left.2",
                                    onChange: updateCount(value:),
                                    onDragEnded: dragEnded)
                                CountButton(
                                    totalWidth: geo.size.width,
                                    negative: false,
                                    imageName: "chevron.right.2",
                                    onChange: updateCount(value:),
                                    onDragEnded: dragEnded)
                            }
                            .frame(maxWidth: .infinity)
                        }
                        .frame(height: 36)
                        .padding(.horizontal)
                        
                        Spacer().frame(height: 50)
                        
                        DeleteButton(title: Theme.deleteButtonTitle, onTap: didTapDelete)
                            .opacity(viewModel.showRemoveItemButton ? 1 : 0)
                    }
                }
                .navigationTitle(viewModel.sceneTitle)
                .navigationBarItems(leading: cancelButton, trailing: saveButton)
                .navigationBarBackButtonHidden(true)
                .accentColor(Theme.tintColor)
                .errorSheet($viewModel.error)
                .actionSheet(isPresented: $showConfirmDeleteActionSheet) {
                    confirmDeleteItemActionSheet
                }
            }
        }
        
        // MARK: - Subviews
        
        private struct CountButton: View {
            @State private var offset: CGFloat = 0
            let totalWidth: CGFloat
            private let frameWidth: CGFloat = 64
            private let paddingWidth: CGFloat = 12
            private var usedWidth: CGFloat {
                (totalWidth / 2) - frameWidth - paddingWidth
            }
            private let maxUpdateValue: CGFloat = 10.5
            let negative: Bool
            let imageName: String
            let onChange: (Int) -> Void
            let onDragEnded: () -> Void
            
            private var dragGesture: some Gesture {
                DragGesture(minimumDistance: 0, coordinateSpace: .global)
                    .onEnded { value in
                        withAnimation {
                            offset = 0
                        }
                        onDragEnded()
                    }
                    .onChanged { value in
                        offset = value.translation.width
                        
                        let transformedOffset = maxUpdateValue * (offset / usedWidth)
                        switch (transformedOffset, negative) {
                        case (...(-maxUpdateValue), true): return
                        case (0..., true): return
                        case (...0, false): return
                        case (maxUpdateValue..., false): return
                        default: break
                        }
                        
                        onChange(Int(transformedOffset))
                    }
            }
            
            private var presentedOffset: CGFloat {
                let temp: CGFloat
                switch offset {
                case ..<0: temp = negative ? offset : (offset / 100)
                case 0...: temp = negative ? (offset / 100) : offset
                default: temp = offset
                }
                switch temp {
                case ..<(-usedWidth): return -usedWidth + ((temp + usedWidth) / 10)
                case usedWidth...: return usedWidth + ((temp - usedWidth) / 10)
                default: return temp
                }
            }
            
            var body: some View {
                RoundedRectangle(cornerRadius: 10, style: .continuous)
                    .fill(Color.appTintColor)
                    .frame(width: frameWidth)
                    .overlay(
                        Image(systemName: imageName)
                            .font(.system(size: 24, weight: .heavy, design: .rounded))
                            .foregroundColor(.appWhite)
                    )
                    .gesture(dragGesture)
                    .offset(x: presentedOffset)
            }
        }
        
        private struct Field: View {
            let info: TextFieldInfo
            let update: (String) -> Void
            
            private var text: Binding<String> {
                Binding(get: { info.value }, set: update)
            }
            
            var body: some View {
                TextField(info.placeholder, text: text)
                    .padding()
                    .overlay(
                        RoundedRectangle(cornerRadius: 15, style: .continuous)
                            .stroke(lineWidth: 2)
                            .fill(info.borderColor)
                    )
                    .padding(.horizontal)
            }
        }
        
        var cancelButton: some View {
            Button(action: interactor.dismiss) {
                Text(Theme.cancelButtonTitle)
                    .accentColor(Theme.tintColor)
            }
        }
        
        var saveButton: some View {
            Button(action: interactor.save) {
                Text(Theme.saveButtonTitle)
                    .accentColor(Theme.tintColor)
            }.disabled(!viewModel.canSave)
        }
        
        var confirmDeleteItemActionSheet: ActionSheet {
            var buttons = [ActionSheet.Button]()
            
            buttons.append(.destructive(
                Text(Theme.confirmDeleteItemButtonTitle),
                action: interactor.delete))
            buttons.append(.cancel(Text(Theme.cancelButtonTitle)))
            
            return ActionSheet(
                title: Text(Theme.confirmDeleteItemTitle),
                message: Text(Theme.confirmDeleteItemMessage),
                buttons: buttons)
        }
    }
}

// MARK: - Interacting

extension EditItem.ContentView {
    private func updateCount(value: Int) {
        interactor.addToCount(value)
    }
    
    private func dragEnded() {
        interactor.dragEnded()
    }
    
    func didTapDelete() {
        showConfirmDeleteActionSheet = true
    }
}

// MARK: - Previews

struct EditItem_Previews: PreviewProvider {
    static var previews: some View {
        EditItem.Scene().view(preview: true, isPresented: .constant(true))
    }
}
