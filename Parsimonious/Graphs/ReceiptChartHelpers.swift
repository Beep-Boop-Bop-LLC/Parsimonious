//
//  RecieptChartView.swift
//  BarGraphTest
//
//  Created by Zach Venanzi on 1/28/25.
//

import Foundation

// Structure to hold processed data for each day of the week
struct DailyReceiptData {
    let date: ReceiptDate
    let amount: Double?
}

// Ensures a full week (Monday-Sunday) is represented even if no receipts exist for a day
func completeWeekData(receipts: [Receipt]) -> [DailyReceiptData] {
    guard let firstReceipt = receipts.min(by: { $0.date < $1.date }) else { return [] }

    let calendar = Calendar.current
    let startDate = firstReceipt.date.toDate() ?? Date()
    let endDate = Date()

    var weekData: [DailyReceiptData] = []
    var currentDate = startDate

    while currentDate <= endDate {
        let receiptDate = ReceiptDate.fromDate(currentDate)
        let receiptTotal = receipts
            .filter { $0.date == receiptDate }
            .reduce(0) { $0 + $1.amount }

        weekData.append(DailyReceiptData(date: receiptDate, amount: receiptTotal > 0 ? receiptTotal : nil))

        if let nextDate = calendar.date(byAdding: .day, value: 1, to: currentDate) {
            currentDate = nextDate
        } else {
            break
        }
    }

    return weekData
}

// Calculates the weekly average expenditure based on total receipts
func calculateWeeklyAverage(receipts: [Receipt]) -> Double? {
    let totalAmount = receipts.reduce(0) { $0 + $1.amount }
    let uniqueDays = Set(receipts.map { $0.date }).count
    return uniqueDays > 0 ? totalAmount / Double(uniqueDays) : nil
}

// Converts a `Date` to `ReceiptDate`
extension ReceiptDate {
    static func fromDate(_ date: Date) -> ReceiptDate {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month, .day], from: date)
        return ReceiptDate(components.year ?? 0, components.month ?? 0, components.day ?? 0)
    }
}

func completeWeeklyData(receipts: [Receipt]) -> [[DailyReceiptData]] {
    guard let firstReceipt = receipts.min(by: { $0.date < $1.date }) else { return [] }

    let calendar = Calendar.current
    let firstWeekStart = calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: firstReceipt.date.toDate() ?? Date())) ?? Date()
    let lastWeekStart = Date()

    var weeklyData: [[DailyReceiptData]] = []
    var currentWeekStart = firstWeekStart

    while currentWeekStart <= lastWeekStart {
        var weekData: [DailyReceiptData] = []
        
        for dayOffset in 0..<7 {
            if let currentDate = calendar.date(byAdding: .day, value: dayOffset, to: currentWeekStart) {
                let receiptDate = ReceiptDate.fromDate(currentDate)
                let receiptTotal = receipts
                    .filter { $0.date == receiptDate }
                    .reduce(0) { $0 + $1.amount }
                
                weekData.append(DailyReceiptData(date: receiptDate, amount: receiptTotal > 0 ? receiptTotal : nil))
            }
        }

        weeklyData.append(weekData)

        // Move to the next week's Monday
        if let nextWeekStart = calendar.date(byAdding: .day, value: 7, to: currentWeekStart) {
            currentWeekStart = nextWeekStart
        } else {
            break
        }
    }

    return weeklyData
}

