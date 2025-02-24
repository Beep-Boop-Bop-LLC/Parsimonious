//
//  HorizontalBarGraph.swift
//  Parsimonious
//
//  Created by Zach Venanzi on 2/23/25.
//

import SwiftUI

struct HorizontalBarGraph: View {
    @EnvironmentObject var controller: ReceiptController

    var categoryTotals: [String: Double] {
        let today = ReceiptDate()
        return controller.receipts
            .filter { $0.date.month == today.month && $0.date.year == today.year }
            .reduce(into: [String: Double]()) { totals, receipt in
                totals[receipt.category, default: 0] += receipt.amount
            }
    }

    var totalBudget: Double {
        Double(controller.categoriesToBudgets.values.reduce(0, +))
    }
    
    var totalSpent: Double {
        categoryTotals.values.reduce(0, +)
    }
    
    private func currentMonth() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM" // "January", "February", etc.
        return formatter.string(from: Date())
    }

    var body: some View {
        VStack(alignment: .center, spacing: 10) { // ✅ Centering Applied
            HStack{
                Text(currentMonth())
                    .font(.headline)
                    .fontWeight(.heavy)
                    .foregroundStyle(Color.lightBeige) // Themed X-axis labels
                Spacer()
                Text("\(String(format: "$%.2f", totalSpent)) of \(String(format: "$%.2f", totalBudget))")
                    .font(.headline)
                    .foregroundStyle(Color.lightBeige) // Themed X-axis labels
            }
            .padding(.horizontal)
            // --- Graph 1: Centered Horizontal Stacked Graph ---
            GeometryReader { geometry in
                let totalWidth = geometry.size.width // ✅ Full width of the available space
                let spentWidth = min(totalWidth, (totalSpent / max(totalBudget, 1)) * totalWidth) // ✅ Ensures it scales correctly
                let categories = sortedCategories()

                ZStack(alignment: .leading) {
                    // Background Total Budget Bar
                    Rectangle()
                        .fill(Color.black.opacity(0.2))
                        .frame(width: totalWidth, height: 40) // ✅ Full width, now 40 height

                    // Foreground Spent Bar (Stacked Categories)
                    HStack(spacing: 0) {
                        ForEach(Array(categories.enumerated()), id: \.element.key) { index, categoryData in
                            let category = categoryData.key
                            let amount = categoryData.value
                            let categoryWidth = (amount / max(totalSpent, 1)) * spentWidth // ✅ Correct proportion within spent amount
                            
                            Rectangle()
                                .fill(colorForCategory(category, index: index)).opacity(0.5) // ✅ Uses ordered colors
                                .frame(width: categoryWidth, height: 40) // ✅ Now 40 height
                        }
                    }
                    .frame(width: spentWidth, alignment: .leading) // ✅ Ensures spent amount scales properly
                }
                .cornerRadius(10)
                .frame(height: 40) // ✅ Updated height
            }
            .padding(.horizontal, 10) // ✅ Ensures 10pt padding on both sides
            .padding(.bottom, 10)
            // Legend with category labels
            LazyHGrid(rows: Array(repeating: GridItem(.flexible(), spacing: 1), count: dynamicRowCount()), spacing: 8) {
                let categories = sortedCategories()

                ForEach(Array(categories.enumerated()), id: \.element.key) { index, categoryData in
                    let category = categoryData.key

                    HStack(spacing: 5) {
                        Circle()
                            .fill(colorForCategory(category, index: index)).opacity(0.5)
                            .frame(width: 10, height: 10)

                        Text(category)
                            .font(.caption)
                            .foregroundColor(.white.opacity(0.8))
                    }
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.top, 15)
            .padding(.horizontal, 20)

        }
        .padding(.top, 1)
        .padding(.horizontal)
        .padding(.bottom, 1)

    }
    private func dynamicRowCount() -> Int {
        let totalCategories = sortedCategories().count
        let itemsPerRow = 4 // Adjust as needed for desired row width
        return max(1, (totalCategories / itemsPerRow) + (totalCategories % itemsPerRow == 0 ? 0 : 1))
    }


    // Sort categories by amount spent (largest first)
    private func sortedCategories() -> [(key: String, value: Double)] {
        return categoryTotals.sorted { $0.value > $1.value }
    }

    // Color scheme for categories (Customizable)
    private func colorForCategory(_ category: String, index: Int) -> Color {
        let colorsOrder: [Color] = [
            .paleGreen, .lightBeige, .softYellow, .taupe, .mossGreen,
            .teal, .brickRed, .oceanBlue, .seafoam, .sand,
            .burntOrange, .mustard, .mocha, .emerald, .coolGray
        ]

        return colorsOrder[index % colorsOrder.count] // ✅ Cycles through colors in order
    }
}
