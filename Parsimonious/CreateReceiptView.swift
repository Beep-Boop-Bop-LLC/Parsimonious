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
    
    var body: some View {
        VStack {
            ParsimoniousHeaderView()
            
            AmountView(amount: $inputAmount, focus: $focusAmount)
            
            DescriptionView(description: $inputDescription, focusDescription: $focusDescription, focusAmount: $focusAmount, selection: $selectedCategory)
            
            NoteView(note: $inputNote)
            
            CategoryView(selection: $selectedCategory)
            
            Spacer()
            
            AddReceiptView(amount: $inputAmount, description: $inputDescription, note: $inputNote, category: $selectedCategory)
        }
        .background(Color.paleGreen.ignoresSafeArea())
        .onAppear {
            focusDescription = true
            focusAmount = false
        }
    }
}
