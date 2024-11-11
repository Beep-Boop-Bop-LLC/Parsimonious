//
//  ReceiptListView.swift
//  Parsimonious
//
//  Created by Nick Venanzi on 10/2/24.
//
import SwiftUI

struct ReceiptListView: View {
    
    @EnvironmentObject var controller: ReceiptController
    @Binding var categories: Set<String>
    
    var receipts: [Receipt] {
        controller.receipts.filter { categories.contains($0.category) }.reversed()
    }

    var body: some View {
        ZStack {
            List {
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
                    .frame(maxHeight: 100)
                    .listRowInsets(EdgeInsets()) // Remove default insets to extend the background
                }
                .onDelete(perform: deleteReceipt) // Enable swipe-to-delete
                .listRowBackground(Color.clear) // Set each row's background to white
            }
            .listRowSpacing(3)
            .listStyle(PlainListStyle()) // Keep the inset list style
        }
    }
    
    // Function to delete receipts
    func deleteReceipt(at offsets: IndexSet) {
        let toDelete = offsets.map { receipts[$0] }
        toDelete.forEach { receipt in
            if let index = controller.receipts.firstIndex(of: receipt) {
                controller.receipts.remove(at: index)
            }
        }
        controller.storeInCache() // Update the cache after deleting
    }
}
