//
//  CreateReceiptView.swift
//  Parsimonious
//
//  Created by Nick Venanzi on 10/2/24.
//

import SwiftUI

struct CreateReceiptView: View {
    @EnvironmentObject var controller: ReceiptController
    
    @State var inputAmount: String = "$0.00"
    @State var inputDescription: String = ""
    @State var inputNote: String = ""
    @State var selectedCategory: String?
    @FocusState var focusDescription: Bool
    @FocusState var focusAmount: Bool
    
    var completion: () -> ()
    
    var body: some View {
        VStack {
            ParsimoniousHeaderView()
            
            AmountView(amount: $inputAmount, focus: $focusAmount)
            
            DescriptionView(description: $inputDescription, focusDescription: $focusDescription, focusAmount: $focusAmount, selection: $selectedCategory)
            
            NoteView(note: $inputNote)
            
            CategoryView(selection: $selectedCategory)
            
            Spacer()
            
            AddReceiptView(amount: $inputAmount, description: $inputDescription, note: $inputNote, category: $selectedCategory, completion: {
                completion()
                inputAmount = "$0.00"
                inputDescription = ""
                inputNote = ""
                selectedCategory = nil
                focusDescription = true
                focusAmount = false
            })
        }
        .background(Color.paleGreen.ignoresSafeArea())
        .onAppear {
            focusDescription = true
            focusAmount = false
        }
        .onTapGesture {
            // Dismiss the keyboard when tapping anywhere
            hideKeyboard()
        }
    }
    
    // Helper function to hide the keyboard
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

extension UIApplication {
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
