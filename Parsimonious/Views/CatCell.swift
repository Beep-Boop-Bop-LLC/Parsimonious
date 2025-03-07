//
//  CatCell.swift
//  Parsimonious
//
//  Created by Zach Venanzi on 10/15/24.
//

import SwiftUI

struct CatCell: View {
    
    @EnvironmentObject var controller: ReceiptController
    @State private var budgetText: String = "$0.00"
    @State private var isFlashing: Bool = false // For flashing background
    
    let category: String
    var budget: Float {
        controller.categoriesToBudgets[category] ?? 0.0
    }
    
    var thisMonth: Double {
        let today = ReceiptDate()
        let month = today.month
        let year = today.year
        return controller.receipts.reduce(0) { partialResult, receipt in
            if receipt.category == category && receipt.date.month == month && receipt.date.year == year {
                return partialResult + receipt.amount
            }
            return partialResult
        }
    }
    
    var pastMonth: Double {
        let today = ReceiptDate()
        return controller.receipts.reduce(0) { partialResult, receipt in
            var previousMonth = today.month - 1
            var previousYear = today.year
            if previousMonth == 0 { previousMonth = 12; previousYear -= 1 }
            if receipt.category == category && receipt.date.month == previousMonth && receipt.date.year == previousYear {
                return partialResult + receipt.amount
            }
            return partialResult
        }
    }

    init(_ category: String) {
        self.category = category
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 2) {
            HStack {
                VStack {
                    HStack {
                        Text(category)
                            .font(.largeTitle)
                            .fontWeight(.medium)
                            .foregroundColor(.lightBeige)
                        Spacer()
                    }
                    HStack {
                        Text("$\(String(format: "%.2f", thisMonth))") // Current sum of all receipts in the month
                            .font(.title2)
                            .fontWeight(.medium)
                            .minimumScaleFactor(0.5)
                            .foregroundColor(.lightBeige)
                        Divider()
                        TextField("Budget", text: $budgetText)
                           .font(.title2)
                           .keyboardType(.decimalPad)
                           .fontWeight(.medium)
                           .minimumScaleFactor(0.5)
                           .foregroundColor(.lightBeige.opacity(0.7))
                           .background(isFlashing ? Color.red.opacity(0.3) : Color.clear) // Flashing background
                           .cornerRadius(6)
                           .onChange(of: budgetText) { _, newValue in
                               let filtered = newValue.filter { "0123456789".contains($0) }
                               if let cents = Int(filtered) {
                                   controller.categoriesToBudgets[category] = Float(cents) / 100.0
                                   budgetText = "$\(String(format: "%.2f", Float(cents) / 100.0))"
                                   controller.storeInCache()
                               }

                               if budgetText != "$0.00" {
                                   stopFlashing()
                               } else {
                                   startFlashing()
                               }
                           }
                           .onAppear {
                               if budgetText == "$0.00" {
                                   startFlashing()
                               }
                           }
                        Spacer()
                    }
                    HStack {
                        let deltaMonth = thisMonth - pastMonth
                        Text("\(deltaMonth > 0 ? "▲" : "▼") $\(String(format: "%.2f", abs(deltaMonth))) \(pastMonth < 0.01 ? "" : "(\(Int(abs(deltaMonth) / pastMonth * 100))%)")")
                            .font(.subheadline)
                            .fontWeight(.heavy)
                            .minimumScaleFactor(0.5)
                            .foregroundColor((deltaMonth <= 0 ? Color.green : Color.red).opacity(0.8))
                        Text("Past Month")
                            .font(.subheadline)
                            .fontWeight(.heavy)
                            .minimumScaleFactor(0.5)
                            .foregroundColor(.lightBeige)
                        Spacer()
                    }
                }
                Spacer()
                
                // Circle Chart
                ZStack {
                    Circle()
                        .stroke(lineWidth: 10)
                        .opacity(0.3)
                        .foregroundColor(.lightBeige.opacity(0.7))
                    
                    Circle()
                        .trim(from: 0.0, to: thisMonth / Double(budget))
                        .stroke(style: StrokeStyle(lineWidth: 10, lineCap: .round, lineJoin: .round))
                        .foregroundColor(circleColor)
                        .rotationEffect(Angle(degrees: 270))
                        .animation(.easeInOut(duration: 0.5))
                    
                    Text(budget > 0.001 ? "\(Int(thisMonth / Double(budget) * 100.0))%" : "N/A")
                        .font(.body)
                        .fontWeight(.heavy)
                        .multilineTextAlignment(.center)
                        .foregroundColor(.lightBeige)
                }
                .frame(width: 100, height: 100)
                .contentShape(Circle())
            }
        }
        .onAppear {
            self.budgetText = "$\(String(format: "%.2f", controller.categoriesToBudgets[category] ?? 0.0))"
        }
        .padding()
        .background(Color.white.opacity(0.1))
        .cornerRadius(10)
        .shadow(radius: 5)
        .onTapGesture {
            hideKeyboard() // Dismiss keyboard when tapping outside
        }
    }
    
    var circleColor: Color {
        let progress = thisMonth / Double(budget)
        if progress < 0.85 {
            return .darkGreen
        } else if progress < 1.01 {
            return .yellow.opacity(0.5)
        } else {
            return .red.opacity(0.5)
        }
    }
    
    private func startFlashing() {
        withAnimation(Animation.easeInOut(duration: 0.5).repeatForever(autoreverses: true)) {
            isFlashing = true
        }
    }

    private func stopFlashing() {
        withAnimation {
            isFlashing = false
        }
    }

    private func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
