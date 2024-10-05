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
        controller.receipts.filter { categories.contains($0.category) }
    }
        
    var body: some View {
        ZStack {
            List {
                ForEach(receipts, id: \.self) { receipt in
                    ZStack {
                        // Extend the white background to cover the entire cell
                        Color.white
                        
                        HStack {
                            DateView(receipt.date)
                                .frame(maxHeight: 50)
                            
                            VStack {
                                Text(receipt.description)
                                    .font(.body)
                                    .fontWeight(.heavy)
                                    .foregroundStyle(Color.seafoamGreen)
                                Text(receipt.category)
                                    .font(.caption2)
                                    .fontWeight(.heavy)
                                    .foregroundStyle(.gray)
                            }
                            Spacer()
                            Text(String(format: "$%.2f", receipt.amount))
                                .font(.largeTitle)
                                .fontWeight(.heavy)
                                .foregroundStyle(Color.seafoamGreen)
                        }
                        .padding() // Optional padding for content inside the cell
                    }
                    .listRowInsets(EdgeInsets()) // Remove default insets to extend the background
                }
            }
            .scrollContentBackground(.hidden)
        }
    }
}
