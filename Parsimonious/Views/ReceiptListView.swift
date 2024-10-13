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

                        .listRowBackground(Color.clear) // Set each row's background to white

                        .padding() // Optional padding for content inside the cell
                    }
                    .frame(maxHeight: 100)
                    //.background(Color.darkGreen.ignoresSafeArea())
                    .listRowInsets(EdgeInsets()) // Remove default insets to extend the background
                }
            }
            .listRowSpacing(3)
            .listStyle(PlainListStyle()) // Keep the inset list style
        }
    }
}

