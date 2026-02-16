//
//  CategoryView.swift
//  Parsimonious
//
//  Created by Nick Venanzi on 10/1/24.
//  Updated with Adaptive Grid + Rounded Category Tiles
//

import SwiftUI

struct CategoryView: View {
    
    @EnvironmentObject var controller: ReceiptController
    @Binding var selection: String?
    @Binding var showPhotoPicker: Bool
    @Binding var showCameraPicker: Bool
    @State private var isAddingNew = false
    @State private var newCategory = ""
    @FocusState private var focusNewCategory: Bool

    private let columns = [GridItem(.adaptive(minimum: 110), spacing: 12)]
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 12) {
                
                ForEach(controller.categories.sorted(), id: \.self) { category in
                    Button {
                        selection = category
                    } label: {
                        Text(category)
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(selection == category ? .darkGreen : .lightBeige)
                            .padding(.vertical, 12)
                            .frame(maxWidth: .infinity)
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(selection == category ? Color.lightBeige.opacity(0.25) : Color.black.opacity(0.05))
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 12)
                                            .stroke(selection == category ? Color.lightBeige.opacity(0.6) : Color.black.opacity(0.1), lineWidth: 1)
                                    )
                            )
                            .shadow(color: .black.opacity(0.15), radius: 3, x: 2, y: 2)
                    }
                    .contextMenu {
                        Button(role: .destructive) {
                            controller.removeCategory(category)
                        } label: {
                            Label("Delete", systemImage: "trash")
                        }
                    }
                }
                
                // MARK: - Library Button
                Button {
                    showPhotoPicker = true
                } label: {
                    VStack(spacing: 6) {
                        Image(systemName: "photo.on.rectangle")
                            .font(.system(size: 16, weight: .semibold))
                    }
                    .foregroundColor(.lightBeige)
                    .padding(.vertical, 12)
                    .frame(maxWidth: .infinity)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color.white.opacity(0.15))
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(Color.white.opacity(0.2), lineWidth: 1)
                            )
                    )
                    .shadow(color: .black.opacity(0.15), radius: 3, x: 2, y: 2)
                }
                .buttonStyle(.plain)
                
                // MARK: - Camera Button
                Button {
                    if UIImagePickerController.isSourceTypeAvailable(.camera) {
                        showCameraPicker = true
                    }
                } label: {
                    VStack(spacing: 6) {
                        Image(systemName: "camera.fill")
                            .font(.system(size: 16, weight: .semibold))
                    }
                    .foregroundColor(.lightBeige)
                    .padding(.vertical, 12)
                    .frame(maxWidth: .infinity)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color.white.opacity(0.2))
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(Color.white.opacity(0.25), lineWidth: 1)
                            )
                    )
                    .shadow(color: .black.opacity(0.15), radius: 3, x: 2, y: 2)
                }
                .buttonStyle(.plain)
                
                // MARK: - Add Category Tile
                if isAddingNew {
                    TextField("Enter category name", text: $newCategory)
                        .font(.system(size: 16, weight: .medium))
                        .textInputAutocapitalization(.words)
                        .disableAutocorrection(true)
                        .focused($focusNewCategory)
                        .onSubmit(addCategory)
                        .padding(.horizontal, 14)
                        .padding(.vertical, 12)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color.black.opacity(0.05))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(Color.black.opacity(0.15), lineWidth: 1)
                                )
                        )
                        .shadow(color: .black.opacity(0.08), radius: 3, x: 1, y: 1)
                        .transition(.scale.combined(with: .opacity))
                        .animation(.easeInOut(duration: 0.25), value: isAddingNew)
                } else {
                    Button {
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                            isAddingNew = true
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                focusNewCategory = true
                            }
                        }
                    } label: {
                        HStack(spacing: 6) {
                            Image(systemName: "plus.circle.fill")
                                .font(.system(size: 17, weight: .semibold))
                            Text("New")
                                .font(.system(size: 16, weight: .semibold))
                        }
                        .foregroundColor(.darkGreen)
                        .padding(.vertical, 12)
                        .frame(maxWidth: .infinity)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color.darkGreen.opacity(0.1))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(Color.darkGreen.opacity(0.25), lineWidth: 1)
                                )
                        )
                        .shadow(color: .black.opacity(0.08), radius: 3, x: 1, y: 1)
                        .contentShape(RoundedRectangle(cornerRadius: 12))
                        .hoverEffect(.highlight) // subtle tactile feedback on iPad/macOS
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
        }
        .simultaneousGesture(
            TapGesture()
                .onEnded { _ in
                    if focusNewCategory {
                        focusNewCategory = false
                    }
                }
        )
        .animation(.easeInOut, value: controller.categories)
        .animation(.easeInOut, value: isAddingNew)
    }
    
    private func addCategory() {
        guard !newCategory.trimmingCharacters(in: .whitespaces).isEmpty else {
            isAddingNew = false
            return
        }
        controller.addCategory(newCategory)
        selection = newCategory
        newCategory = ""
        isAddingNew = false
    }
}
