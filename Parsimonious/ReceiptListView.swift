//
//  ListView.swift
//  Parsimonious
//
//  Created by Zach Venanzi on 8/11/24.
//
import SwiftUI

struct ReceiptListView: View {
    @Binding var receipts: [Receipt]
    var category: String?

    @State private var showingDeleteConfirmation = false
    @State private var receiptToDelete: Receipt?

    var body: some View {
        ScrollView {
            VStack(spacing: 8) {
                ForEach(groupedReceipts, id: \.date) { date, receipts in
                    Section(header: sectionHeader(for: date)) {
                        ForEach(receipts) { receipt in
                            receiptRow(for: receipt)
                        }
                        .onDelete(perform: deleteReceipt) // Default swipe-to-delete
                    }
                }
            }
            .padding()
        }
        .navigationTitle(category ?? "Receipts")
        .background(Color.paleGreen.ignoresSafeArea())
        .alert(isPresented: $showingDeleteConfirmation) {
            Alert(
                title: Text("Confirm Deletion"),
                message: Text("Are you sure you want to delete this receipt?"),
                primaryButton: .destructive(Text("Delete")) {
                    if let receipt = receiptToDelete {
                        if let index = receipts.firstIndex(where: { $0.id == receipt.id }) {
                            receipts.remove(at: index)
                            saveReceipts()
                        }
                    }
                },
                secondaryButton: .cancel()
            )
        }
    }

    // MARK: - Private Views

    private func sectionHeader(for date: Date) -> some View {
        Text(dateFormatter.string(from: date))
            .font(.system(size: 20, weight: .heavy))
            .fontWeight(.heavy)
            .padding(.vertical, 1)
            .padding(.bottom, 1)
    }

    private func receiptRow(for receipt: Receipt) -> some View {
        HStack {
            VStack(alignment: .leading) {
                Text(receipt.description)
                    .font(.system(size: 30, weight: .heavy))
                    .minimumScaleFactor(0.5) // Allow text to scale down if needed
                    .lineLimit(1) 
                    .foregroundColor(.green)
// Prevent text from wrapping to a new line
            }
            Spacer()
            Text(String(format: "$%.2f", receipt.amount))
                .font(.system(size: 40, weight: .bold))
                .foregroundColor(.green)
                .minimumScaleFactor(0.5) // Allow text to scale down if needed
                .lineLimit(1) // P
            deleteButton(for: receipt)
        }
        .padding()
        .background(.white)
        .cornerRadius(8)
    }

    private func deleteButton(for receipt: Receipt) -> some View {
        Button(action: {
            receiptToDelete = receipt
            showingDeleteConfirmation = true
        }) {
            Image(systemName: "trash")
                .resizable()
                .frame(width: 20, height: 20)
                .foregroundColor(.green)
        }
    }

    // MARK: - Private Methods

    private var groupedReceipts: [(date: Date, receipts: [Receipt])] {
        let grouped = Dictionary(grouping: filteredReceipts) { receipt in
            dateFormatter.string(from: receipt.date)
        }
        
        let sortedGroupedReceipts = grouped.map { key, value in
            (date: dateFormatter.date(from: key) ?? Date(), receipts: value)
        }
        
        return sortedGroupedReceipts.sorted { $0.date < $1.date }
    }

    private var filteredReceipts: [Receipt] {
        if let category = category {
            return receipts.filter { $0.category == category }
        }
        return receipts
    }

    private func deleteReceipt(at offsets: IndexSet) {
        // Swipe-to-delete fallback if needed
        offsets.forEach { index in
            receipts.remove(at: index)
        }
        saveReceipts() // Save after deleting
    }

    private func saveReceipts() {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(receipts) {
            UserDefaults.standard.set(encoded, forKey: "savedReceipts")
        }
    }

    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .none
        return formatter
    }
}
