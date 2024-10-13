//
//  CircleGraphVIew.swift
//  Parsimonious
//
//  Created by Zach Venanzi on 10/12/24.
//
import SwiftUI

struct CircleGraphView: View {

    @ObservedObject var receiptController: ReceiptController
    
    var selectedCategories: Set<String>

    let budgetedAmount: Double = 2000.0
    let calendar = Calendar.current

    // Calculate the total of receipts for the current month based on selected categories
    var currentMonthTotal: Double {
        let currentMonth = calendar.component(.month, from: Date())
        let currentYear = calendar.component(.year, from: Date())
        
        // Filter receipts based on selected categories and current month/year
        let receiptsForCurrentMonth = receiptController.receipts.filter { receipt in
            (selectedCategories.isEmpty || selectedCategories.contains(receipt.category)) && // Only include selected categories
            receipt.date.month == currentMonth &&
            receipt.date.year == currentYear
        }
        
        return receiptsForCurrentMonth.reduce(0) { $0 + $1.amount }
    }

    // Calculate the progress based on the total receipts of the current month
    var progress: Double {
        currentMonthTotal / budgetedAmount
    }

    var body: some View {
        VStack {
            // Circle chart representing the total budget and filled based on receipts
            ZStack {
                Circle()
                    .stroke(lineWidth: 20)
                    .opacity(0.3)
                    .foregroundColor(.gray)

                Circle()
                    .trim(from: 0.0, to: min(progress, 1.0))
                    .stroke(style: StrokeStyle(lineWidth: 20, lineCap: .round, lineJoin: .round))
                    .foregroundColor(progressColor)
                    .rotationEffect(Angle(degrees: 270)) // Start the circle from the top

                VStack {
                    Text("Total: $\(currentMonthTotal, specifier: "%.2f")")
                        .font(.headline)
                        .foregroundColor(.lightGreen)
                    Text("Budget: $\(budgetedAmount, specifier: "%.2f")")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
            }
            .frame(width: 150, height: 150)
        }
        .onChange(of: selectedCategories) { newValue in
            print("CircleGraphView - Updated Selected Categories: \(newValue)") // Debugging print statement
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center) // Ensure the view is centered
        .padding()
    }

    // Define color based on progress
    var progressColor: Color {
        if progress < 0.5 {
            return .green
        } else if progress < 1.0 {
            return .yellow
        } else {
            return .red
        }
    }
}
