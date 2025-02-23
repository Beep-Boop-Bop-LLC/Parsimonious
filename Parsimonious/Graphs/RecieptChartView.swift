//
//  RecieptChartView.swift
//  BarGraphTest
//
//  Created by Zach Venanzi on 1/28/25.
//

import SwiftUI
import Charts

struct ReceiptChartView: View {
    @ObservedObject var controller: ReceiptController
    @State private var selectedTab: Int
    @State private var selectedDay: ReceiptDate? = nil
    @State private var selectedTotal: Double? = nil
    @State private var isInteracting: Bool = false
    
    private let weeklyReceipts: [[DailyReceiptData]]
    
    init(controller: ReceiptController) {
        _controller = ObservedObject(wrappedValue: controller)
        
        // Precompute weekly receipt data (ensuring chronological order)
        self.weeklyReceipts = completeWeeklyData(receipts: controller.receipts)
        
        // Ensure the selected tab starts at the most recent week
        _selectedTab = State(initialValue: max(0, weeklyReceipts.count - 1))
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            TabView(selection: $selectedTab) {
                ForEach(Array(weeklyReceipts.enumerated()), id: \.offset) { index, weekData in
                    VStack {
                        weekHeader(weekData: weekData)
                        weekChart(weekData: weekData)
                        spacer()
                    }
                    .tag(index) // Ensures correct tab indexing
                }
            }
            .tabViewStyle(PageTabViewStyle())
            .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .never)) // Ensures indicators appear below
            .onAppear {
                // Ensure it opens at the most recent week
                selectedTab = max(0, weeklyReceipts.count - 1)
            }
        }
        .padding()
        .frame(height: 350)
    }

    // Header displaying the weekly total and range
    private func weekHeader(weekData: [DailyReceiptData]) -> some View {
        let totalSpent = weekData.compactMap { $0.amount }.reduce(0, +) // Total spent in the week
        let totalDays = weekData.count // Always 7 days in a full week
        let averageSpent = totalDays > 0 ? totalSpent / Double(totalDays) : 0 // Average per day
        
        return VStack(spacing: 4) { // Stack everything neatly
            // Top Section - Total and Average Spent
            HStack {
                // Left Section - Total Money Spent
                VStack(alignment: .center) {
                    Text("Total Spent")
                        .font(.headline)
                        .padding(.top, 1)
                        .foregroundStyle(Color.lightBeige) // Themed X-axis labels
                    Text("$\(totalSpent, specifier: "%.2f")")
                        .font(.largeTitle)
                        .bold()
                        .foregroundStyle(Color.lightBeige) // Themed X-axis labels

                }
                .frame(maxWidth: .infinity) // Ensures even space distribution
                // Divider between sections
                Divider()
                    .frame(height: 50) // Keeps it compact

                // Right Section - Average Spent Per Day
                VStack(alignment: .center) {
                    Text("AVG. Spent")
                        .font(.headline)
                        .padding(.top, 1)
                        .foregroundStyle(Color.lightBeige) // Themed X-axis labels
                    
                    Text("$\(averageSpent, specifier: "%.2f")")
                        .font(.largeTitle)
                        .bold()
                        .foregroundStyle(Color.lightBeige) // Themed X-axis labels

                }
                .frame(maxWidth: .infinity) // Ensures even space distribution
            }
            
            // Bottom Section - Week Date Range
            if let firstDay = weekData.first?.date.formatted(), let lastDay = weekData.last?.date.formatted() {
                Text("\(firstDay) - \(lastDay)")
                    .font(.subheadline)
                    .foregroundStyle(Color.lightBeige) // Themed X-axis labels
            }
        }
        .padding(.horizontal)
    }

    // Chart displaying a full week's daily receipts
    private func weekChart(weekData: [DailyReceiptData]) -> some View {
        Chart {
            ForEach(weekData, id: \.date) { data in
                BarMark(
                    x: .value("Day", data.date.formatted(style: "M/d")),
                    y: .value("Amount", data.amount ?? 0)
                )
                .foregroundStyle(
                    (data.amount ?? 0) > 0 ?
                        AnyShapeStyle(LinearGradient(
                            gradient: Gradient(colors: [
                                Color.darkGreen.opacity(0.75),
                                Color.darkGreen.opacity(0.1)                            ]),
                            startPoint: .top,
                            endPoint: .bottom
                        )) :
                        AnyShapeStyle(Color.lightBeige.opacity(0.5))
                )
            }
        }
        .chartXAxis {
            AxisMarks {
                AxisGridLine()
                    .foregroundStyle(Color.lightBeige.opacity(0.5)) // Subtle X-axis grid lines
                AxisValueLabel()
                    .foregroundStyle(Color.lightBeige) // Themed X-axis labels
            }
        }
        .chartYAxis {
            AxisMarks { value in
                AxisGridLine()
                    .foregroundStyle(Color.lightBeige.opacity(0.5)) // Subtle X-axis grid lines
                AxisValueLabel {
                    if let amount = value.as(Double.self) {
                        Text("$\(amount, specifier: "%.2f")") // Format as USD
                            .foregroundColor(Color.lightBeige)
                    }
                }
            }
        }
    }


    
    private func spacer() -> some View {
        Rectangle()
            .fill(Color.clear) // Transparent
            .frame(width: 100, height: 30) // Set size as needed
    }
}
