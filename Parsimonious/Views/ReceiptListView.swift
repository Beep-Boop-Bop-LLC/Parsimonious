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
    
    var myReceipts: [Receipt] {
        controller.receipts.filter { categories.contains($0.category) }
    }
    
    var body: some View {
        List {
            ForEach(myReceipts.indices, id: \.self) { receipt in
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
                    
                    Text("$\((100.0*receipt.amount).rounded() / 100.0)")
                        .font(.body)
                        .padding(.top, 10)
                        .foregroundStyle(.seafoamGreen)
                }
            }
        }
    }
}
