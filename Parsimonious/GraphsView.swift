//
//  GraphsView.swift
//  Parsimonious
//
//  Created by Zach Venanzi on 10/4/24.
//

import SwiftUI

// Dummy data for categories
struct CategoryData {
    var name: String
    var totalAmount: Double
    var budgetedAmount: Double
    var averageAmount: Double
}

// Sample categories data
var categories: [CategoryData] = [
    CategoryData(name: "Food", totalAmount: 600, budgetedAmount: 500, averageAmount: 480),
    CategoryData(name: "Transport", totalAmount: 250, budgetedAmount: 220, averageAmount: 190),
    CategoryData(name: "Entertainment", totalAmount: 75, budgetedAmount: 400, averageAmount: 350),
    CategoryData(name: "Health & Fitness", totalAmount: 250, budgetedAmount: 200, averageAmount: 195),
    CategoryData(name: "Utilities", totalAmount: 60, budgetedAmount: 300, averageAmount: 280),
    CategoryData(name: "Travel", totalAmount: 80, budgetedAmount: 450, averageAmount: 420),
    CategoryData(name: "Personal Care", totalAmount: 40, budgetedAmount: 180, averageAmount: 170),
    CategoryData(name: "Food", totalAmount: 600, budgetedAmount: 500, averageAmount: 480)
]

struct GraphsView: View {
    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [Color.white.opacity(0.2), Color.white.opacity(0.8)]),
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea(edges: .all)
            .frame(maxWidth: .infinity, maxHeight: .infinity)

                VStack {
                    ParsimoniousHeaderView()
                    
                    // Stacked Bar Chart
                    StackedBarChartView(categories: categories)
// Assuming you have this view implemented
                    LegendView(categories: categories)
                        .padding(.top, 10)
                        .padding(.horizontal)
                    ScrollView {
                    ForEach(categories, id: \.name) { category in
                        HorizontalBarGraphView(category: category.name,
                                                totalAmount: category.totalAmount,
                                                budgetedAmount: category.budgetedAmount,
                                                averageAmount: category.averageAmount)
                            .padding(.horizontal)
                    }
                }
                .padding(.bottom, 20) // Add some padding at the bottom for scrolling
            }
        }
        .background(Color.paleGreen.ignoresSafeArea())
    }
}


// Your existing StackedBarChartView, HorizontalBarGraphView, and LegendView implementations go here...

struct StackedBarChartView: View {
    var categories: [CategoryData]

    let categoryColors: [Color] = [
        Color.green.opacity(0.85),      // Light Green
        Color.green.opacity(0.55),      // Medium Green
        Color.green.opacity(0.20),      // Darker Green
        Color.seafoamGreen.opacity(0.4),      // Slightly darker Green
        Color.seafoamGreen.opacity(0.1),      // More vibrant Green
        Color.seafoamGreen.opacity(1.0),      // Very light Green
        Color.green.opacity(0.5)       // Pale Green
    ]

    var body: some View {
        VStack {
            GeometryReader { geometry in
                let totalAmount = categories.reduce(0) { $0 + $1.totalAmount }
                HStack(spacing: 0) {
                    ForEach(categories.indices, id: \.self) { index in
                        let category = categories[index]
                        let percentage = category.totalAmount / totalAmount
                        Rectangle()
                            .fill(categoryColors[index % categoryColors.count])
                            .frame(width: geometry.size.width * CGFloat(percentage), height: geometry.size.height)
                            .cornerRadius(5)
                    }
                }
                .cornerRadius(5)
            }
            .frame(height: 30) // Set a fixed height for the bar chart
        }
    }
}

struct LegendView: View {
    var categories: [CategoryData]
    
    let categoryColors: [Color] = [
        Color.green.opacity(0.85),      // Light Green
        Color.green.opacity(0.55),      // Medium Green
        Color.green.opacity(0.20),      // Darker Green
        Color.seafoamGreen.opacity(0.4),      // Slightly darker Green
        Color.seafoamGreen.opacity(0.1),      // More vibrant Green
        Color.seafoamGreen.opacity(1.0),      // Very light Green
        Color.green.opacity(0.5)       // Pale Green
    ]

    
    var body: some View {
        let columns = Array(repeating: GridItem(.flexible(minimum: 50)), count: 3) // Adjust for layout
        
        LazyVGrid(columns: columns, alignment: .leading, spacing: 8) {
            ForEach(categories.indices, id: \.self) { index in
                HStack(spacing: 5) {
                    Circle()
                        .fill(categoryColors[index % categoryColors.count])
                        .frame(width: 10, height: 10)
                    Text(categories[index].name)
                        .font(.subheadline)
                        .foregroundColor(.seafoamGreen)
                        .lineLimit(1)
                        .minimumScaleFactor(0.5)
                }
            }
        }
        .padding(.horizontal)
    }
}

struct BarView: View {
    var value: Double
    var budgetedAmount: Double
    var color: Color

    var body: some View {
        GeometryReader { geometry in
            let percentage = min(value / budgetedAmount, 1.0)
            Rectangle()
                .fill(color)
                .frame(width: geometry.size.width * CGFloat(percentage), height: 30)
                .cornerRadius(5)
        }
        .frame(height: 30)
    }
}

struct HorizontalBarGraphView: View {
    var category: String
    var totalAmount: Double
    @State var budgetedAmount: Double
    var averageAmount: Double
    @FocusState private var isBudgetedAmountFocused: Bool

    var body: some View {
        ZStack {
            Color.clear
                .contentShape(Rectangle())
                .onTapGesture {
                    isBudgetedAmountFocused = false
                }

            VStack(alignment: .leading) {
                Text(category)
                    .font(.headline.weight(.heavy))
                    .foregroundColor(.seafoamGreen)
                    .padding(.bottom, 5)

                BarView(value: totalAmount, budgetedAmount: budgetedAmount, color: totalAmount > budgetedAmount ? Color.red.opacity(0.5) : Color.white.opacity(0.65))
                    .overlay(Text(String(format: "$%.2f", totalAmount))
                        .font(.headline.weight(.heavy))
                        .foregroundColor(.seafoamGreen)
                        .padding(5), alignment: .leading)

                BarView(value: budgetedAmount, budgetedAmount: budgetedAmount, color: Color.seafoamGreen.opacity(0.3))
                    .overlay(
                        TextField("", value: $budgetedAmount, format: .number)
                            .foregroundColor(.seafoamGreen)
                            .font(.headline.weight(.heavy))
                            .padding(5)
                            .multilineTextAlignment(.leading)
                            .keyboardType(.decimalPad)
                            .focused($isBudgetedAmountFocused),
                        alignment: .leading
                    )

                BarView(value: averageAmount, budgetedAmount: budgetedAmount, color: averageAmount > budgetedAmount ? Color.red.opacity(0.5) : Color.seafoamGreen.opacity(0.2))
                    .overlay(Text(String(format: "$%.2f", averageAmount))
                        .font(.headline.weight(.heavy))
                        .foregroundColor(.seafoamGreen)
                        .padding(5), alignment: .leading)
            }
            .padding(.vertical, 10)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
