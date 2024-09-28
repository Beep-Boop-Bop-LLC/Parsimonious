//
//  ProfileView.swift
//  Parsimonious
//
//  Created by Zach Venanzi on 9/10/24.
//
import SwiftUI

struct ProfileView: View {
    @Binding var email: String
    @Binding var projectedBudgets: [String: Double]
    @Binding var categories: [Category]

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Profile")) {
                    TextField("Personal Email", text: $email)
                }

                Section(header: Text("Budgets")) {
                    ForEach(categories) { category in
                        HStack {
                            Text(category.category)
                            Spacer()
                            TextField("Projected Budget", value: Binding(
                                get: { projectedBudgets[category.category, default: 0.0] },
                                set: { newValue in
                                    projectedBudgets[category.category] = newValue
                                    saveProjectedBudgets()  // Save when edited
                                }
                            ), format: .currency(code: "USD"))
                            .keyboardType(.decimalPad)
                        }
                    }
                }
            }
            .navigationTitle("Profile")
            .onAppear {
                loadProjectedBudgets()
            }
        }
    }

    // Load projected budgets from UserDefaults
    private func loadProjectedBudgets() {
        if let data = UserDefaults.standard.data(forKey: "projectedBudgets"),
           let savedBudgets = try? JSONDecoder().decode([String: Double].self, from: data) {
            projectedBudgets = savedBudgets
        }
    }

    // Save projected budgets to UserDefaults
    private func saveProjectedBudgets() {
        if let data = try? JSONEncoder().encode(projectedBudgets) {
            UserDefaults.standard.set(data, forKey: "projectedBudgets")
        }
    }
}
