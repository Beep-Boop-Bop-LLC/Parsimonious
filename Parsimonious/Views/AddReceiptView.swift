//
//  AddReceiptView.swift
//  Parsimonious
//
//  Created by Nick Venanzi on 10/2/24.
//
import SwiftUI

struct AddReceiptView: View {
    
    @EnvironmentObject var controller: ReceiptController
    @Binding var amount: String
    @Binding var description: String
    @Binding var note: String
    @Binding var category: String?
    
    var completion: () -> ()
    
    var isComplete: Bool {
        return amount != "$0.00" && description != "" && category != nil
    }
    
    var body: some View {
        GeometryReader { geometry in
            HStack {
                Button(action: {
                    let filtered = amount.filter { "0123456789".contains($0) }
                    if let cents = Int(filtered), let cat = category {
                        controller.addReceipt(amount: Double(cents)/100, description: description, note: note, category: cat)
                        completion()
                    }
                }) {
                    Text("Add")
                        .font(.system(size: 20, weight: .semibold))
                        .padding()
                        .foregroundColor(isComplete ? .darkGreen : .lightBeige)
                        .frame(maxWidth: .infinity)
                        .shadow(color: .black.opacity(0.2), radius: 5, x: 2, y: 2) // Adjust shadow parameters here
                }
                .padding(.horizontal)
                .disabled(!isComplete)
            }
            .frame(width: geometry.size.width)
            .background(isComplete ? Color.lightBeige.opacity(0.4) : Color.midGreen.opacity(0.4))
        }
        .frame(height: 50)
        .cornerRadius(8)
        .padding()
    }
}
