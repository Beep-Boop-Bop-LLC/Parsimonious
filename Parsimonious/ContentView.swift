//
//  ContentView.swift
//  Parsimonious
//
//  Created by Zach Venanzi on 8/11/24.
//

import SwiftUI

struct AddReceipt: View {
    @State private var receiptAmountString: String = ""
    @State private var receiptAmount: Double? = nil
    @State private var isTextFieldFocused: Bool = false
    @State private var selectedCategory: String? = nil // To store selected category
    
    var body: some View {
        NavigationView {
            VStack {
                Text("Enter Receipt Amount")
                    .font(.headline)
                    .padding(.bottom, 10)
                
                TextField("Amount", text: $receiptAmountString)
                    .keyboardType(.decimalPad) // Restricts input to numbers and decimal point
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .font(.title) // Change text size here
                    .padding()
                    .multilineTextAlignment(.center) // Center align the text within the TextField
                    .focused($isTextFieldFocused) // Bind the focus state to the TextField
                    .onAppear {
                        // Make the TextField the first responder when the view appears
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                            isTextFieldFocused = true
                        }
                    }
                    .onChange(of: receiptAmountString) { newValue in
                        // Convert string to double and handle errors
                        if let amount = Double(newValue) {
                            receiptAmount = amount
                        } else {
                            // Handle invalid input or reset if needed
                            receiptAmount = nil
                        }
                    }
                
                if let amount = receiptAmount {
                    Text("Amount: \(amount, specifier: "%.2f")")
                } else {
                    Text("Invalid amount")
                        .foregroundColor(.red)
                }
                
                NavigationLink(destination: CategorySelectionView(selectedCategory: $selectedCategory)) {
                    Text("Next")
                        .font(.title2)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding()
                
                Spacer()
            }
            .padding()
            .navigationTitle("Add Receipt")
        }
    }
}

struct AddReceipt_Previews: PreviewProvider {
    static var previews: some View {
        AddReceipt()
    }
}
