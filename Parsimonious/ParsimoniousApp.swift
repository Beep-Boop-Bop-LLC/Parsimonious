//
//  ParsimoniousApp.swift
//  Parsimonious
//
//  Created by Zach Venanzi on 8/11/24.
//
import SwiftUI

struct ContentView: View {
    @State private var receipts: [Receipt] = []
    @State private var categories: [Category] = []
    @State private var projectedBudgets: [String: Double] = [
        "Groceries": 500.00,
        "Rent": 1500.00,
        "Transportation": 200.00,
        "Entertainment": 100.00,
        "Utilities": 250.00
    ] // Sample projected budgets for each category
    
    var body: some View {
        TabView {
            CreateView(receipts: $receipts, categories: $categories) // Pass the bindings here too
                .tabItem {
                    Label("Add Receipt", systemImage: "plus.circle")
                }
            SummaryView(receipts: $receipts, categories: $categories) // Pass the bindings here too
                .tabItem {
                    Label("Summary", systemImage: "chart.pie")
                }
        }
        .accentColor(.seafoamGreen)
        .background(Color.paleGreen.ignoresSafeArea())
        .onAppear {
            prepopulateCommonCategories()
        }
        .onChange(of: receipts) { _ in
            updateCategoriesBasedOnReceipts()
        }
    }
    
    private func prepopulateCommonCategories() {
        // Common budget categories
        let commonCategories = ["Groceries", "Rent", "Transportation", "Entertainment", "Utilities"]
        
        // Add these common categories only if they are not already in the categories list
        for category in commonCategories {
            if !categories.contains(where: { $0.category == category }) {
                categories.append(Category(category: category, currentMonth: 0.0, projectedMonth: projectedBudgets[category, default: 0.0], previousMonth: 0.0))
            }
        }
    }
    
    private func updateCategoriesBasedOnReceipts() {
        let categoriesSet = Set(receipts.map { $0.category })
        
        categories = categoriesSet.map { category in
            let currentMonthTotal = calculateCurrentMonthTotal(for: receipts.filter { $0.category == category })
            let projectedBudget = projectedBudgets[category, default: 0.0]
            let previousMonthTotal = calculatePreviousMonthTotal(for: receipts.filter { $0.category == category })
            
            return Category(
                category: category,
                currentMonth: currentMonthTotal,
                projectedMonth: projectedBudget,
                previousMonth: previousMonthTotal
            )
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
}

@main
struct ReceiptApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
