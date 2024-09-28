//
//  CategoryView.swift
//  Parsimonious
//
//  Created by Zach Venanzi on 8/11/24.
//

import SwiftUI
import Foundation

struct Receipt: Identifiable, Codable, Equatable { // Add Equatable conformance
    var id = UUID()
    var date: Date
    var description: String
    var note: String
    var category: String
    var amount: Double
}

import Foundation

struct Category: Identifiable, Codable, Equatable {
    var id = UUID()
    var category: String
    var currentMonth: Double
    var projectedMonth: Double
    var previousMonth: Double
    
    // Initialize with default values if data is missing
    init(category: String, currentMonth: Double = 0.0, projectedMonth: Double = 0.0, previousMonth: Double = 0.0) {
        self.category = category
        self.currentMonth = currentMonth
        self.projectedMonth = projectedMonth
        self.previousMonth = previousMonth
    }
}

private func calculateCurrentMonthTotal(for receipts: [Receipt]) -> Double {
    let calendar = Calendar.current
    let now = Date()
    let startOfMonth = calendar.date(from: calendar.dateComponents([.year, .month], from: now))!
    let endOfMonth = calendar.date(byAdding: .month, value: 1, to: startOfMonth)!

    return receipts.filter { receipt in
        return receipt.date >= startOfMonth && receipt.date < endOfMonth
    }.reduce(0) { $0 + $1.amount }
}


private func calculateProjectedMonthTotal(for receipts: [Receipt]) -> Double {
    // Implement your logic here
    return 1000.00 // Placeholder
}

private func calculatePreviousMonthTotal(for receipts: [Receipt]) -> Double {
    let calendar = Calendar.current
    let now = Date()
    let startOfMonth = calendar.date(from: calendar.dateComponents([.year, .month], from: now))!
    let startOfPreviousMonth = calendar.date(byAdding: .month, value: -1, to: startOfMonth)!
    let endOfPreviousMonth = startOfMonth

    return receipts.filter { receipt in
        return receipt.date >= startOfPreviousMonth && receipt.date < endOfPreviousMonth
    }.reduce(0) { $0 + $1.amount }
}


struct TextStyle {
    let font: Font
    let foregroundColor: Color
}

let textStyle = TextStyle(
    font: .system(size: 30, weight: .bold),
    foregroundColor: .black
)

extension Color {
    static let paleGreen = Color(red: 0.7, green: 1.0, blue: 0.7)
    static let paleBlue = Color(red: 0.27, green: 0.51, blue: 0.71)
    static let seafoamGreen = Color(red: 0.18, green: 0.55, blue: 0.34) // Steel Blue
}

struct LimitTextLength: ViewModifier {
    var maxLength: Int

    func body(content: Content) -> some View {
        content
            .onReceive(NotificationCenter.default.publisher(for: UITextField.textDidChangeNotification)) { output in
                if let textField = output.object as? UITextField {
                    if let text = textField.text, text.count > maxLength {
                        textField.text = String(text.prefix(maxLength))
                    }
                }
            }
    }
}
