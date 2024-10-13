//
//  BarGraphView.swift
//  Parsimonious
//
//  Created by Zach Venanzi on 10/11/24.
//
import SwiftUI

struct BarGraphView: View {
    
    @ObservedObject var receiptController: ReceiptController
    var selectedCategories: Set<String> // Property for selected categories
    let calendar = Calendar.current
    let today = Date()

    // Get the last seven days' dates (reversed so the most recent day is on the right)
    var lastSevenDays: [Date] {
        (0..<7).compactMap { calendar.date(byAdding: .day, value: -$0, to: today) }.reversed()
    }

    // Sum of receipts for each of the last seven days filtered by selected categories
    var dailySums: [Double] {
        lastSevenDays.map { day in
            let receiptsForDay = receiptController.receipts.filter { receipt in
                calendar.isDate(receipt.date.toDate(), inSameDayAs: day) &&
                (selectedCategories.isEmpty || selectedCategories.contains(receipt.category)) // Filter by selected categories
            }
            return receiptsForDay.reduce(0) { $0 + $1.amount }
        }
    }

    // Get the date range for display under the graph
    var dateRangeLabel: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        if let startDate = lastSevenDays.last, let endDate = lastSevenDays.first {
            return "\(dateFormatter.string(from: startDate)) - \(dateFormatter.string(from: endDate))"
        }
        return ""
    }

    var body: some View {
        VStack {
            HStack(alignment: .center) {
                // Y-axis labels for easier analysis
                VStack(spacing: 0) {
                    ForEach((0...5).reversed(), id: \.self) { step in
                        Text("\(step * 200)")
                            .font(.footnote)
                            .foregroundColor(.white)
                            .frame(height: 40) // Adjusted height for scaling
                    }
                }
                
                // The vertical bar graph layout
                GeometryReader { geometry in
                    HStack(alignment: .bottom, spacing: 10) {
                        ForEach(0..<7, id: \.self) { index in
                            VStack {
                                // Scaled bar with dynamic height based on screen size
                                Rectangle()
                                    .fill(Color.white)
                                    .frame(width: 20, height: barHeight(for: dailySums[index], maxHeight: geometry.size.height))

                                // Day label under the bar
                                Text(dayLabel(for: lastSevenDays[index]))
                                    .font(.caption)
                                    .foregroundColor(.white)
                                    .frame(height: 30)
                            }
                        }
                    }
                }
            }
            .padding()

            // Label for the date range
            Text(dateRangeLabel)
                .font(.caption)
                .foregroundColor(.white)
                .padding(.top, 8)
        }
        .frame(height: 300) // Adjust graph height as needed
        .onChange(of: selectedCategories) { newValue in
            print("BarGraphView - Updated Selected Categories: \(newValue)") // Debugging print statement
        }
    }

    // Generate day labels for the last seven days (e.g., Mon, Tue)
    func dayLabel(for date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "E" // Day of the week (e.g., Mon)
        return dateFormatter.string(from: date)
    }

    // Dynamically calculate bar height for visual clarity and scaling
    func barHeight(for amount: Double, maxHeight: CGFloat) -> CGFloat {
        let maxAmount: Double = 1000 // Set the expected max value for scaling
        return CGFloat(amount / maxAmount) * maxHeight
    }
}

// Helper function to convert ReceiptDate to Date
extension ReceiptDate {
    func toDate() -> Date {
        let components = DateComponents(year: year, month: month, day: day)
        return Calendar.current.date(from: components) ?? Date()
    }
}
