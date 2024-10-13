//
//  CategoryView.swift
//  Parsimonious
//
//  Created by Nick Venanzi on 10/1/24.
//

import SwiftUI

struct CategoryView: View {
    
    @EnvironmentObject var controller: ReceiptController
    @Binding var selection: String?
    @State var isNewCategory: Bool = false
    @State var newCategory: String = ""
    @FocusState var newCategoryFocus: Bool
    
    var categories: [String] {
        var categories = Array(controller.categories)
        if isNewCategory {
            categories.append("")
        }
        categories.append("+")
        return categories
    }
    
    var body: some View {
        ScrollViewReader { scrollViewProxy in
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 10) {
                    ForEach(categories, id: \.self) { category in
                        Button(action: {
                            if category == "+" {
                                isNewCategory = true
                                newCategory = ""
                                newCategoryFocus = true
                                selection = newCategory
                            } else {
                                selection = category
                            }
                        }) {
                            if category == "" {
                                TextField("[Category]", text: $newCategory)
                                    .customTextField()
                                    .focused($newCategoryFocus)
                                    .onSubmit {
                                        controller.addCategory(newCategory)
                                        isNewCategory = false
                                        newCategoryFocus = false
                                        selection = String(newCategory)
                                    }
                            } else {
                                Text(category)
                                    .font(.system(size: 20, weight: .semibold))
                                    .foregroundColor(selection == category ? .darkGreen : .lightBeige)
                                    .shadow(color: .black.opacity(0.2), radius: 5, x: 2, y: 2) // Adjust shadow parameters here
                                    .padding()
                                    .background(selection == category ? Color.lightBeige : Color.clear)
                                    .cornerRadius(8)
                            }
                        }
                            .contextMenu {
                                Button(action: {
                                    controller.removeCategory(category)
                                }) {
                                    Text("Delete")
                                    Image(systemName: "trash")
                                }
                            }
                            .id(category)
                    }
                }
                .padding(.horizontal)
                .onChange(of: selection) { _, newCategory in
                    withAnimation {
                        scrollViewProxy.scrollTo(newCategory, anchor: .center)
                    }
                }
            }
            .frame(maxWidth: .infinity)
            .frame(height: 60)

            .onAppear {
                newCategoryFocus = false
            }
        }
    }
}
