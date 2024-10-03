//
//  AmountView.swift
//  Parsimonious
//
//  Created by Nick Venanzi on 10/1/24.
//

import SwiftUI

struct AmountView: View {
    
    @Binding var amount: String
    @FocusState.Binding var focus: Bool
    
    var body: some View {
        TextField("Amount", text: $amount)
            .customTextField()
            .font(.system(size: 70, weight: .heavy))
            .keyboardType(.decimalPad)
            .onChange(of: amount) { _, newValue in
                let filtered = newValue.filter { "0123456789".contains($0) }
                // Parse to integer and update amountInCents
                if let cents = Int(filtered) {
                    amount = String(format: "$%.2f", Double(cents)/100)
                }
            }
            .focused($focus)
    }
    
}
