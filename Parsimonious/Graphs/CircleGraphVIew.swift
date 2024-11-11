//
//  CircleGraphVIew.swift
//  Parsimonious
//
//  Created by Zach Venanzi on 10/12/24.
//
import SwiftUI

struct CircleGraphView: View {
    @EnvironmentObject var controller: ReceiptController
    
    var totalExpenditure: Double {
        return controller.receipts.reduce(0.0) { partialResult, receipt in
            let month = ReceiptDate().month
            let year = ReceiptDate().year
            if receipt.date.month == month && receipt.date.year == year {
                return partialResult + receipt.amount
            }
            return partialResult
        }
    }
    
    var totalBudget: Double {
        var budget = 0.0
        for category in controller.categories {
            budget += Double(controller.categoriesToBudgets[category] ?? 0.0)
        }
        return budget
    }

    // Calculate the total of receipts for the last 7 days
    var weekExpenditure: Double {
        var day: ReceiptDate = ReceiptDate()
        var pastWeek: Set<ReceiptDate> = Set([day])
        for _ in 0..<6 {
            day = day.dayBefore()
            pastWeek.insert(day)
        }

        return controller.receipts.reduce(0.0, { partialResult, receipt in
            if (pastWeek.contains(receipt.date)) {
                return partialResult + receipt.amount
            }
            return partialResult
        })
    }

    // Calculate the progress based on the total receipts of the current month
    var currentMonthProgress: Double {
        if totalBudget < 0.001 {
            return 0.0
        }
        return totalExpenditure / totalBudget
    }

    // Calculate the progress based on the total receipts of the last 7 days
    var last7DaysProgress: Double {
        if totalBudget < 0.001 {
            return 0.0
        }
        return weekExpenditure / (totalBudget / 4.0)
    }
    
    var body: some View {
        HStack(alignment: .top) {
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
                    Text("Month Total: $\(totalExpenditure, specifier: "%.2f")")
                        .font(.headline)
                        .minimumScaleFactor(0.5)
                        .multilineTextAlignment(.center)
                        .foregroundColor(.lightBeige)
                    Text("Budget: $\(totalBudget, specifier: "%.2f")")
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
                    Text("Last 7 Days: $\(weekExpenditure, specifier: "%.2f")")
                        .font(.headline)
                        .minimumScaleFactor(0.5)
                        .multilineTextAlignment(.center)
                        .foregroundColor(.lightBeige)
                    Text("Budget: $\(totalBudget / 4.0, specifier: "%.2f")/Week")
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
