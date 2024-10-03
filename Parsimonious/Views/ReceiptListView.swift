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
            Color.paleGreen.ignoresSafeArea()
            List {
                ForEach(receipts, id: \.self) { receipt in
                    HStack {
                        DateView(receipt.date).frame(maxHeight: 50)
                        
                        VStack {
                            Text(receipt.description)
                                .font(.body)
                                .fontWeight(.bold)
                            
                            Text(receipt.category)
                                .font(.caption2)
                                .foregroundStyle(.gray)
                        }
                        Spacer()
                        Text(String(format: "$%.2f", receipt.amount))
                            .font(.body)
                            .padding(.top, 10)
                            .foregroundStyle(Color.seafoamGreen)
                    }
                }
            }
            .scrollContentBackground(.hidden)
        }
    }
}
