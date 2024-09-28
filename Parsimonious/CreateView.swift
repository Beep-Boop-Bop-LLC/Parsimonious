//
//  CreateView.swift
//  Parsimonious
//
//  Created by Zach Venanzi on 9/14/24.
//

import SwiftUI

struct CreateView: View {
    @Binding var receipts: [Receipt]
    @Binding var categories: [Category]
    
    @State private var amount: Double = 0.0 // Changed from String to Double
    @State private var description: String = ""
    @State private var note: String = ""
    @State private var selectedCategory: Category? = nil
    @State private var newCategoryName: String = ""
    @State private var isCategoryCreating = false
    @FocusState private var isDescriptionFocused: Bool
    @FocusState private var isTextFieldFocused: Bool
    @FocusState private var isAmountFocused: Bool

    var body: some View {
        NavigationView {
            VStack(spacing: 5) {
                headerView
                detailsForm
                categoryScrollView
                Spacer()
                
                if isCategoryCreating {
                    categoryCreationTextField
                }
                
                addButton
                    .padding()
            }
            .background(Color.paleGreen.ignoresSafeArea())
            .onTapGesture {
                UIApplication.shared.endEditing(true)
            }
            .onChange(of: isDescriptionFocused) { _ in
                if isDescriptionFocused {
                    isDescriptionFocused = true
                }
            }
            
            .onAppear {
                DispatchQueue.main.async {
                    isDescriptionFocused = true
                }
                loadData() // Load data when the view appears
            }
            .onDisappear {
                isDescriptionFocused = false
                saveData() // Save data when the view disappears
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
    
    private var headerView: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [Color.white.opacity(0.2), Color.white.opacity(0.8)]),
                startPoint: .top,
                endPoint: .bottom
            )
            .edgesIgnoringSafeArea(.top)
            .frame(maxHeight: .infinity, alignment: .top)
            
            VisualEffectBlur(blurStyle: .light)
                .edgesIgnoringSafeArea(.all)
            
            HStack {
                Spacer()
                Text("Parsimonious")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.seafoamGreen)
                    .frame(maxWidth: .infinity, alignment: .center)
                Spacer()
            }
            .frame(height: 60)
        }
        .frame(height: 60)
    }
    
    private var detailsForm: some View {
        VStack(spacing: 20) {
            amountTextField
            descriptionTextField
            noteTextField
        }
        .padding(.top, 20)
    }
    
    private var amountTextField: some View {
        ZStack {
            TextField("", value: Binding(
                get: { amount == 0 ? 0.0 : amount },  // Default to 0 if the value is nil or 0
                set: { newValue in amount = newValue }  // Update amount on user input
            ), format: .currency(code: "USD"))
            .multilineTextAlignment(.center)
            .foregroundColor(.seafoamGreen)
            .font(.system(size: 70, weight: .heavy))
            .keyboardType(.decimalPad)
            .frame(maxWidth: .infinity, alignment: .center)
            .background(Color.clear)
            .autocorrectionDisabled(true)
            .focused($isAmountFocused) // Bind focus state
        }
    }


    private var isReceiptComplete: Bool {
        return amount != 0.0 && !description.isEmpty && selectedCategory != nil
    }

    private func addReceipt() {
        let newReceipt = Receipt(
            id: UUID(),
            date: Date(),
            description: description,
            note: note,
            category: selectedCategory?.category ?? "Uncategorized",
            amount: amount
        )
        
        receipts.append(newReceipt)
        clearForm()
    }

    private func clearForm() {
        amount = 0.0 // Reset to 0.0 instead of empty string
        description = ""
        note = ""
        selectedCategory = nil
        print("Form cleared")
    }

    
    private var descriptionTextField: some View {
        ZStack {
            if description.isEmpty {
                Text("x")
                    .font(.system(size: 25, weight: .semibold))
                    .foregroundColor(.seafoamGreen)
                    .frame(maxWidth: .infinity, alignment: .center)
            }
            TextField("", text: $description)
                .multilineTextAlignment(.center)
                .foregroundColor(.seafoamGreen)
                .font(.system(size: 25, weight: .semibold))
                .frame(maxWidth: .infinity, alignment: .center)
                .background(Color.clear)
                .autocorrectionDisabled(true)
                .focused($isDescriptionFocused)
                .onSubmit {
                    isAmountFocused = true
                }
                .onChange(of: description) { _ in
                    updateCategoryBasedOnDescription()
                }
        }
    }

    private var noteTextField: some View {
        ZStack {
            if note.isEmpty {
                Text("note")
                    .font(.system(size: 25, weight: .semibold))
                    .foregroundColor(.seafoamGreen)
                    .frame(maxWidth: .infinity, alignment: .center)
            }
            TextField("", text: $note)
                .multilineTextAlignment(.center)
                .foregroundColor(.seafoamGreen)
                .font(.system(size: 25, weight: .semibold))
                .frame(maxWidth: .infinity, alignment: .center)
                .background(Color.clear)
                .autocorrectionDisabled(true)
        }
    }
    
    private var categoryScrollView: some View {
        ScrollViewReader { scrollViewProxy in
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 10) {
                    ForEach(categories) { category in
                        categoryButton(for: category)
                            .contextMenu {
                                Button(action: {
                                    isCategoryCreating = true
                                    newCategoryName = ""
                                    isTextFieldFocused = true
                                    print("Create Category button tapped for: \(category.category)")
                                }) {
                                    Text("Create Category")
                                    Image(systemName: "plus")
                                }
                                Button(action: {
                                    deleteCategory(category)
                                }) {
                                    Text("Delete")
                                    Image(systemName: "trash")
                                }
                            }
                            .id(category.id)
                    }
                }
                .padding(.horizontal)
                .onChange(of: selectedCategory) { newCategory in
                    if let id = newCategory?.id {
                        withAnimation {
                            scrollViewProxy.scrollTo(id, anchor: .center)
                        }
                        print("Scrolled to category: \(newCategory?.category ?? "None")")
                    }
                }
            }
            .frame(height: 60)
        }
    }

    private var categoryCreationTextField: some View {
        VStack {
            TextField("", text: $newCategoryName)
                .textFieldStyle(PlainTextFieldStyle())
                .padding()
                .background(Color.clear)
                .cornerRadius(8)
                .font(.system(size: 25, weight: .semibold))
                .foregroundColor(.seafoamGreen)
                .keyboardType(.default)
                .focused($isTextFieldFocused)
                .onSubmit {
                    addNewCategory()
                }
                .submitLabel(.done)
                .multilineTextAlignment(.center)
        }
        .background(Color.clear)
        .onTapGesture {
            UIApplication.shared.endEditing(true)
            isTextFieldFocused = false
        }
    }

    private var addButton: some View {
        GeometryReader { geometry in
            HStack {
                Button(action: {
                    addReceipt()
                }) {
                    Text("Add")
                        .font(.system(size: 20, weight: .semibold))
                        .padding()
                        .foregroundColor(isReceiptComplete ? .seafoamGreen : .white)
                }
                .padding(.horizontal)
                .disabled(!isReceiptComplete)
            }
            .frame(width: geometry.size.width)
            .background(isReceiptComplete ? Color.white : Color.gray.opacity(0.5))
        }
        .frame(height: 50)
        .cornerRadius(8)
    }

    private func addNewCategory() {
        if !newCategoryName.isEmpty {
            let newCategory = Category(category: newCategoryName)
            categories.append(newCategory)
            newCategoryName = ""
            isTextFieldFocused = false
            isCategoryCreating = false
            print("Added new category: \(newCategory)")
        } else {
            print("New category name is empty, not added.")
        }
    }
    
    private func categoryButton(for category: Category) -> some View {
        Button(action: {
            selectCategory(category)
        }) {
            Text(category.category)
                .font(.system(size: 20, weight: .semibold))
                .foregroundColor(selectedCategory == category ? .seafoamGreen : .gray)
                .padding()
                .background(selectedCategory == category ? Color.white : Color.clear)
                .cornerRadius(8)
        }
    }
    
    private func deleteCategory(_ category: Category) {
        if let index = categories.firstIndex(of: category) {
            categories.remove(at: index)
            if selectedCategory == category {
                selectedCategory = nil
            }
            print("Deleted category: \(category.category)")
        }
    }
    
    private func selectCategory(_ category: Category) {
        selectedCategory = category
        print("Category selected: \(category.category)")
    }
    
    private func saveData() {
        if let encodedReceipts = try? JSONEncoder().encode(receipts) {
            UserDefaults.standard.set(encodedReceipts, forKey: "savedReceipts")
        }
        if let encodedCategories = try? JSONEncoder().encode(categories) {
            UserDefaults.standard.set(encodedCategories, forKey: "savedCategories")
        }
    }

    private func loadData() {
        if let savedReceipts = UserDefaults.standard.object(forKey: "savedReceipts") as? Data,
           let decodedReceipts = try? JSONDecoder().decode([Receipt].self, from: savedReceipts) {
            receipts = decodedReceipts
        }
        if let savedCategories = UserDefaults.standard.object(forKey: "savedCategories") as? Data,
           let decodedCategories = try? JSONDecoder().decode([Category].self, from: savedCategories) {
            categories = decodedCategories
        }
        
        // Ensure amount is set as Double, not String
        receipts = receipts.map { receipt in
            var updatedReceipt = receipt
            updatedReceipt.amount = Double(receipt.amount) // Convert amount if necessary
            return updatedReceipt
        }
    }

    
    private func updateCategoryBasedOnDescription() {
        if let matchingReceipt = receipts.first(where: { $0.description == description }) {
            selectedCategory = categories.first { $0.category == matchingReceipt.category }
            print("Matching receipt found. Updated selected category to: \(selectedCategory?.category ?? "None")")
        } else {
            selectedCategory = nil
            print("No matching receipt found.")
        }
    }
}

extension UIApplication {
    func endEditing(_ force: Bool) {
        windows
            .filter { $0.isKeyWindow }
            .first?
            .endEditing(force)
    }
}

