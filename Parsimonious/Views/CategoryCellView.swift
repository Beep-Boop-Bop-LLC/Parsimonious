//
//  CategoryCellView.swift
//  Parsimonious
//
//  Created by Zach Venanzi on 10/14/24.
//

import SwiftUI

struct CategoryCellView: View {
    var category: String
    var currentMonthTotal: Double
    var averageMonthTotal: Double
    
    @State private var budgetAmount = ""
    @FocusState private var focusAmount: Bool
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(category)
                    .font(.headline)
                    .foregroundColor(.lightBeige)
                Text("Current Month: \(String(format: "$%.2f", currentMonthTotal))")
                    .font(.subheadline)
                    .foregroundColor(.lightBeige)
                Text("Avg Monthly: \(String(format: "$%.2f", averageMonthTotal))")
                    .font(.subheadline)
                    .foregroundColor(.lightBeige)
            }
            Spacer()
            BudgetAmountView(budgetAmount: $budgetAmount, focus: $focusAmount, category: category)
        }
        .padding(.vertical, 8)
    }
}
