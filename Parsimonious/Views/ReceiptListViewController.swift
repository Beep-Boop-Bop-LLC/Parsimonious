//
//  ReceiptListViewController.swift
//  Parsimonious
//
//  Created by Zach Venanzi on 12/12/24.
//

import SwiftUI

struct ReceiptListViewController: View {
    
    @EnvironmentObject var controller: ReceiptController
    @Binding var categories: Set<String>
    
    var title: String

    var groupedReceipts: [(String, [Receipt])] {
        let grouped = Dictionary(grouping: receipts) { receipt in
            // Convert `ReceiptDate` to `Date`
            guard let receiptDate = receipt.date.toDate() else {
                return "Unknown"
            }
            let month = Calendar.current.dateComponents([.year, .month], from: receiptDate)
            let formatter = DateFormatter()
            formatter.dateFormat = "MMMM yyyy"
            return formatter.string(from: Calendar.current.date(from: month)!)
        }
        
        // Sort the groups by the most recent receipt's date in descending order
        return grouped
            .sorted { lhs, rhs in
                guard
                    let lhsMostRecentDate = lhs.value.compactMap({ $0.date.toDate() }).max(),
                    let rhsMostRecentDate = rhs.value.compactMap({ $0.date.toDate() }).max()
                else {
                    return false
                }
                return lhsMostRecentDate > rhsMostRecentDate
            }
    }
    
    var receipts: [Receipt] {
        controller.receipts.filter { categories.contains($0.category) }.reversed()
    }
    
    // Calculate the average number of receipts per month, excluding the current month
    var averageReceiptsPerMonth: Double {
        let completedMonths = groupedReceipts.filter { $0.0 != currentMonthName }
        let monthsCount = completedMonths.count
        guard monthsCount > 0 else { return 0 }
        let totalReceipts = completedMonths.reduce(0) { $0 + $1.1.count }
        return Double(totalReceipts) / Double(monthsCount)
    }

    // Calculate the average total per month, excluding the current month
    var averageTotalPerMonth: Double {
        let completedMonths = groupedReceipts.filter { $0.0 != currentMonthName }
        let monthsCount = completedMonths.count
        guard monthsCount > 0 else { return 0 }
        let totalAmount = completedMonths.reduce(0) { $0 + $1.1.reduce(0) { $0 + $1.amount } }
        return totalAmount / Double(monthsCount)
    }

    // Helper to get the current month in the same format as the groupedReceipts keys
    var currentMonthName: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        return formatter.string(from: Date())
    }


    var body: some View {
        ZStack {
            Image("Parsimonious")
                .resizable()
                .scaledToFill()
                .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
                .position(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height / 2)
                .opacity(0.04)
                .ignoresSafeArea()
            
            LinearGradient(
                gradient: Gradient(colors: [Color.midGreen.opacity(0.2), Color.midGreen.opacity(0.8)]),
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea(edges: .all)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            
            ZStack {
                VStack {
                    // Title and Averages
                    VStack {
                        Text(title)
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundColor(.lightBeige)
                        Text(String(format: "Avg. Receipts: %.1f | Avg. Total: $%.2f",
                                    averageReceiptsPerMonth,
                                    averageTotalPerMonth))
                            .font(.subheadline)
                            .foregroundColor(.lightBeige.opacity(0.8))
                    }
                    List {
                        ForEach(groupedReceipts, id: \.0) { (month, receipts) in
                            Section(
                                header: HStack {
                                    Text(month)
                                        .font(.headline)
                                        .foregroundColor(.lightBeige)
                                    Spacer()
                                    Text(String(format: "Total: $%.2f", receipts.reduce(0) { $0 + $1.amount }))
                                        .font(.headline)
                                        .foregroundColor(.lightBeige.opacity(0.8))
                                }
                            ) {
                                ForEach(receipts.sorted(by: { r1, r2 in
                                    if r1.date.year > r2.date.year {
                                        return true
                                    } else if r1.date.year < r2.date.year {
                                        return false
                                    }
                                    
                                    if r1.date.month > r2.date.month {
                                        return true
                                    } else if r1.date.month < r2.date.month {
                                        return false
                                    }
                                    
                                    if r1.date.day > r2.date.day {
                                        return true
                                    } else if r1.date.day < r2.date.day {
                                        return false
                                    } else {
                                        return r1.amount > r2.amount
                                    }
                                }), id: \.self) { receipt in
                                    ZStack {
                                        HStack {
                                            DateView(receipt.date)
                                                .frame(maxHeight: 50)
                                            
                                            VStack(alignment: .leading) {
                                                Text(receipt.description)
                                                    .font(.body)
                                                    .fontWeight(.heavy)
                                                    .foregroundStyle(Color.lightBeige)
                                                Text(receipt.category)
                                                    .font(.caption2)
                                                    .fontWeight(.heavy)
                                                    .multilineTextAlignment(.leading)
                                                    .foregroundStyle(Color.lightBeige.opacity(0.7))
                                            }
                                            Spacer()
                                            Text(String(format: "$%.2f", receipt.amount))
                                                .font(.largeTitle)
                                                .fontWeight(.heavy)
                                                .foregroundStyle(Color.lightBeige)
                                        }
                                        .padding() // Optional padding for content inside the cell
                                    }
                                    .listRowBackground(Color.clear) // Set each row's background to white
                                    .frame(maxHeight: 100)
                                    .listRowInsets(EdgeInsets()) // Remove default insets to extend the background
                                }
                                .onDelete(perform: { indexSet in
                                    deleteReceipt(at: indexSet, from: receipts)
                                }) // Enable swipe-to-delete
                            }
                        }
                    }
                    .listRowSpacing(3)
                    .listStyle(DefaultListStyle())
                    .scrollContentBackground(.hidden) // Makes the list background transparent
                    .padding(.bottom, 20)
                    .padding(.top, 20)
                }
            }
        }
        .background(Color.lightGreen.ignoresSafeArea())
    }
    
    // Function to delete receipts
    func deleteReceipt(at offsets: IndexSet, from receiptList: [Receipt]) {
        let toDelete = offsets.map { receiptList[$0] }
        toDelete.forEach { receipt in
            if let index = controller.receipts.firstIndex(of: receipt) {
                controller.receipts.remove(at: index)
            }
        }
        controller.storeInCache() // Update the cache after deleting
    }
}
