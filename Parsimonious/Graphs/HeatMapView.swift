//
//  HeatMapView.swift
//  Parsimonious
//
//  Created by Zach Venanzi on 10/11/24.
//

import SwiftUI

struct HeatMapView: View {
    @ObservedObject var receiptController: ReceiptController
    let calendar = Calendar.current
    let daysOfWeek = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]
   
    private var currentMonth: Date {
        let now = Date()
        return calendar.date(from: calendar.dateComponents([.year, .month], from: now))!
    }

    var body: some View {
        VStack {
            ScrollViewReader { scrollView in
                ScrollView(.horizontal) {
                    HStack(alignment: .top) {
                        // Sort the months to have the current month last
                        ForEach(monthsWithReceipts().sorted(by: { $0 < $1 }), id: \.self) { month in
                            VStack {
                                Text(monthName(for: month))
                                    .font(.headline)
                                    .foregroundColor(.lightBeige)
                                Text("\(currentMonthReceiptCount(for: month)) Receipts")
                                    .foregroundColor(.lightBeige.opacity(0.7))
                                    .font(.subheadline)

                                // Day labels
                                dayLabels()

                                // Create a grid for each week of the month
                                let (daysInMonth, firstWeekday) = daysInMonthInfo(for: month)
                                let totalRows = (daysInMonth + firstWeekday - 1) / 7 + 1

                                ForEach(0..<totalRows, id: \.self) { week in
                                    weekRow(for: week, daysInMonth: daysInMonth, firstWeekday: firstWeekday, month: month)
                                }
                            }
                            .padding(.horizontal, 4)
                            .id(month) // Add this line to uniquely identify each month
                        }
                    }
                    .padding()
                }
                .onAppear {
                    if let lastMonth = monthsWithReceipts().first {
                        scrollView.scrollTo(lastMonth, anchor: .trailing) // Scroll to the current month
                    }
                }
                .scrollIndicators(.never)
            }
            .padding(1)
        }
    }
    // Update: Count receipts for the given month, not just the current month
    private func currentMonthReceiptCount(for month: Date) -> Int {
        let monthComponents = calendar.dateComponents([.month, .year], from: month)
        return receiptController.receipts.filter {
            $0.date.year == monthComponents.year && $0.date.month == monthComponents.month
        }.count
    }

    // Generate day labels
    private func dayLabels() -> some View {
        HStack(spacing: 4) {
            ForEach(daysOfWeek, id: \.self) { day in
                Text(day)
                    .foregroundColor(.lightBeige)
                    .font(.footnote)
                    .frame(width: 35, height: 20)
            }
        }
    }

    // Get days in month info
    private func daysInMonthInfo(for date: Date) -> (Int, Int) {
        let daysInMonth = calendar.range(of: .day, in: .month, for: date)?.count ?? 30
        let firstWeekday = firstDayOfMonthWeekday(for: date)
        return (daysInMonth, firstWeekday)
    }

    // Create a week row
    private func weekRow(for week: Int, daysInMonth: Int, firstWeekday: Int, month: Date) -> some View {
        HStack(spacing: 4) {
            ForEach(0..<7, id: \.self) { day in
                let dateIndex = day + (week * 7) - firstWeekday + 1
                if dateIndex > 0 && dateIndex <= daysInMonth {
                    let date = getDateForDay(dayIndex: dateIndex, month: month)
                    let count = receiptCount(for: date)
                    daySquare(for: count)
                } else {
                    emptyDaySquare()
                }
            }
        }
    }

    // Create a square for days with receipts
    private func daySquare(for count: Int) -> some View {
        Rectangle()
            .fill(color(for: count))
            .frame(width: 35, height: 35)
            .cornerRadius(8) // Rounded corners
            .overlay(
                Text(count > 0 ? "\(count)" : "")
                    .foregroundColor(.white)
                    .font(.footnote)
            )
    }

    // Create a square for empty days
    private func emptyDaySquare() -> some View {
        Rectangle()
            .fill(Color.clear.opacity(0.3)) // Fill with gray
            .frame(width: 35, height: 35)
            .cornerRadius(8) // Rounded corners
    }

    // Filter months to show only those with receipts
    func monthsWithReceipts() -> [Date] {
        let monthsWithReceipts = Set(receiptController.receipts.map { receipt in
            let receiptDate = receipt.date
            let components = DateComponents(year: receiptDate.year, month: receiptDate.month)
            return calendar.date(from: components)!
        })

        return monthsWithReceipts.sorted(by: >)  // Sort by most recent
    }

    // Get the name of the month for a given date
    func monthName(for date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        return formatter.string(from: date)
    }

    // Get the weekday (1 = Sunday) of the first day of the month
    func firstDayOfMonthWeekday(for date: Date) -> Int {
        var calendar = Calendar.current
        calendar.firstWeekday = 1 // Set Sunday as the first day of the week

        let firstDayOfMonth = calendar.date(from: calendar.dateComponents([.year, .month], from: date))!
        let weekday = calendar.component(.weekday, from: firstDayOfMonth)
        
        // Adjust to make it zero-based (0 = Sunday, 1 = Monday, etc.)
        return (weekday - calendar.firstWeekday + 7) % 7
    }

    // Get a specific date for a day index within a month
    func getDateForDay(dayIndex: Int, month: Date) -> Date {
        let components = DateComponents(year: calendar.component(.year, from: month), month: calendar.component(.month, from: month), day: dayIndex)
        return calendar.date(from: components)!
    }

    // Count the number of receipts for a specific date
    func receiptCount(for date: Date) -> Int {
        let receiptDate = ReceiptDate.fromString(dateString(from: date))
        return receiptController.receipts.filter { $0.date == receiptDate }.count
    }

    // Convert a Date object to a string that matches ReceiptDate format
    func dateString(from date: Date) -> String {
        let components = calendar.dateComponents([.year, .month, .day], from: date)
        return "\(components.year!)-\(components.month!)-\(components.day!)"
    }

    // Determine the color intensity based on the count of receipts
    func color(for count: Int) -> Color {
        switch count {
        case 0:
            return Color.lightBeige.opacity(0.1)
        case 1:
            return Color.darkGreen.opacity(0.1)
        case 2:
            return Color.darkGreen.opacity(0.30)
        case 3:
            return Color.darkGreen.opacity(0.50)
        case 4:
            return Color.darkGreen.opacity(0.70)
        case 5:
            return Color.darkGreen.opacity(0.90)
        case 6...100:
            return Color.darkGreen.opacity(0.95)
        default:
            return Color.darkGreen.opacity(0.95)
        }
    }
}
