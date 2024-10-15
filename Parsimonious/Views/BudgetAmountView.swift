//
//  BudgetAmountView.swift
//  Parsimonious
//
//  Created by Zach Venanzi on 10/14/24.
//

import SwiftUI

struct BudgetAmountView: View {
    
    @Binding var budgetAmount: String
    @FocusState.Binding var focus: Bool
    var category: String

    var body: some View {
        TextField("Amount", text: $budgetAmount)
            .customTextField()
            .font(.system(size: 70, weight: .heavy))
            .shadow(color: .black.opacity(0.1), radius: 5, x: 2, y: 2)
            .keyboardType(.decimalPad)
            .minimumScaleFactor(0.8)
            .onAppear {
                // Load saved budget amount or default to $500
                let savedBudget = UserDefaults.standard.double(forKey: "budget_\(category)")
                budgetAmount = savedBudget > 0 ? String(format: "$%.2f", savedBudget) : "$500.00"
            }
            .onChange(of: budgetAmount) { newValue in
                let filtered = newValue.filter { "0123456789".contains($0) }
                if let cents = Int(filtered) {
                    let budget = Double(cents) / 100
                    budgetAmount = String(format: "$%.2f", budget)
                    
                    // Save budget to UserDefaults
                    UserDefaults.standard.set(budget, forKey: "budget_\(category)")
                }
            }
            .focused($focus)
    }
}

