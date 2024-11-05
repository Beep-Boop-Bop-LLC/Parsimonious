//
//  CircleGraphVIew.swift
//  Parsimonious
//
//  Created by Zach Venanzi on 10/12/24.
//
import SwiftUI

struct CircleGraphView: View {
    @EnvironmentObject var controller: ReceiptController
    var selectedCategories: Set<String>

    // Add a state variable to hold the budget amount as a string
    @State private var budgetAmount: String = "$2000.00"
    @FocusState private var isFocused: Bool
    
    let calendar = Calendar.current

    // Calculate the total of receipts for the current month based on selected categories
    var currentMonthTotal: Double {
        let currentMonth = calendar.component(.month, from: Date())
        let currentYear = calendar.component(.year, from: Date())

        // Filter receipts based on selected categories and current month/year
        let receiptsForCurrentMonth = controller.receipts.filter { receipt in
            (selectedCategories.isEmpty || selectedCategories.contains(receipt.category)) && // Only include selected categories
            receipt.date.month == currentMonth &&
            receipt.date.year == currentYear
        }

        return receiptsForCurrentMonth.reduce(0) { $0 + $1.amount }
    }

    // Calculate the total of receipts for the last 7 days based on selected categories
    var last7DaysTotal: Double {
        let last7DaysStart = calendar.date(byAdding: .day, value: -7, to: Date())!

        // Filter receipts based on selected categories and last 7 days
        let receiptsForLast7Days = controller.receipts.filter { receipt in
            (selectedCategories.isEmpty || selectedCategories.contains(receipt.category)) && // Only include selected categories
            toDate(receipt.date) >= last7DaysStart // Convert ReceiptDate to Date for comparison
        }

        return receiptsForLast7Days.reduce(0) { $0 + $1.amount }
    }

    // Helper function to convert ReceiptDate to Date
    private func toDate(_ receiptDate: ReceiptDate) -> Date {
        var components = DateComponents()
        components.year = receiptDate.year
        components.month = receiptDate.month
        components.day = receiptDate.day
        return Calendar.current.date(from: components) ?? Date.distantPast
    }

    // Calculate the progress based on the total receipts of the current month
    var currentMonthProgress: Double {
        guard let budget = Double(budgetAmount.filter { "0123456789.".contains($0) }), budget > 0 else { return 0 }
        return currentMonthTotal / budget
    }

    // Calculate the progress based on the total receipts of the last 7 days
    var last7DaysProgress: Double {
        guard let budget = Double(budgetAmount.filter { "0123456789.".contains($0) }), budget > 0 else { return 0 }
        return last7DaysTotal / (budget / 4) // Divide budgeted amount by 4 for weekly budget
    }

    var body: some View {
        VStack{
            HStack{
                Spacer()
                BudgetAmountView(
                    budgetAmount: $budgetAmount, // Bind budgetAmount
                    focus: $isFocused,           // Focus state
                    category: "Overall Budget"
                )
                Spacer()
            }
            HStack {
                VStack {
                    // Circle chart for current month
                    ZStack {
                        Circle()
                            .stroke(lineWidth: 20)
                            .opacity(0.3)
                            .foregroundColor(.lightBeige.opacity(0.7))
                        
                        Circle()
                            .trim(from: 0.0, to: min(currentMonthProgress, 1.0))
                            .stroke(style: StrokeStyle(lineWidth: 20, lineCap: .round, lineJoin: .round))
                            .foregroundColor(currentMonthProgressColor)
                            .rotationEffect(Angle(degrees: 270)) // Start the circle from the top
                            .animation(.easeInOut(duration: 0.5), value: currentMonthProgress) // Add animation here
                        
                        // Percentage text in the center
                        Text("\(Int(currentMonthProgress * 100))%")
                            .font(.largeTitle)
                            .fontWeight(.heavy)
                            .multilineTextAlignment(.center)
                            .foregroundColor(.lightBeige)
                    }
                    .frame(width: 150, height: 150)
                    
                    VStack(spacing: 5) { // Add spacing for better appearance
                        Text("Month Total: $\(currentMonthTotal, specifier: "%.2f")")
                            .font(.headline)
                            .minimumScaleFactor(0.5)
                            .multilineTextAlignment(.center)
                            .foregroundColor(.lightBeige)
                        Text("Budget: \(budgetAmount)")
                            .font(.subheadline)
                            .minimumScaleFactor(0.5)
                            .multilineTextAlignment(.center)
                            .foregroundColor(.lightBeige.opacity(0.7))
                    }
                    .padding(.top, 20)
                    .frame(width: 150, alignment: .center) // Center the text under the circle
                }
                .padding()
                
                VStack {
                    ZStack {
                        Circle()
                            .stroke(lineWidth: 20)
                            .opacity(0.3)
                            .foregroundColor(.lightBeige.opacity(0.7))
                        
                        Circle()
                            .trim(from: 0.0, to: min(last7DaysProgress, 1.0))
                            .stroke(style: StrokeStyle(lineWidth: 20, lineCap: .round, lineJoin: .round))
                            .foregroundColor(last7DaysProgressColor)
                            .rotationEffect(Angle(degrees: 270)) // Start the circle from the top
                            .animation(.easeInOut(duration: 0.5), value: last7DaysProgress) // Add animation here
                        
                        // Percentage text in the center
                        Text("\(Int(last7DaysProgress * 100))%")
                            .font(.largeTitle)
                            .minimumScaleFactor(0.5)
                            .foregroundColor(.lightBeige)
                            .fontWeight(.heavy)
                    }
                    .frame(width: 150, height: 150)
                    
                    VStack(spacing: 5) { // Add spacing for better appearance
                        Text("Last 7 Days: $\(last7DaysTotal, specifier: "%.2f")")
                            .font(.headline)
                            .minimumScaleFactor(0.5)
                            .multilineTextAlignment(.center)
                            .foregroundColor(.lightBeige)
                        Text("Budget: ~$\(Double(budgetAmount.filter { "0123456789.".contains($0) }) ?? 0 / 4, specifier: "%.2f")/Week")
                            .font(.subheadline)
                            .minimumScaleFactor(0.1)
                            .multilineTextAlignment(.center)
                            .foregroundColor(.lightBeige.opacity(0.7))
                    }
                    .padding(.top, 20)
                    .frame(width: 150, alignment: .center) // Center the text under the circle
                }
                .padding()
            }
            .onChange(of: selectedCategories) { newValue in
                print("CircleGraphView - Updated Selected Categories: \(newValue)") // Debugging print statement
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center) // Ensure the view is centered
        }
    }

    // Define color based on current month progress
    var currentMonthProgressColor: Color {
        if currentMonthProgress < 0.85 {
            return .darkGreen
        } else if currentMonthProgress < 1.0 {
            return .yellow.opacity(0.5)
        } else {
            return .red.opacity(0.5)
        }
    }

    // Define color based on last 7 days progress
    var last7DaysProgressColor: Color {
        if last7DaysProgress < 0.85 {
            return .darkGreen
        } else if last7DaysProgress < 1.0 {
            return .yellow.opacity(0.5)
        } else {
            return .red.opacity(0.5)
        }
    }
}
