//
//  CreateReceiptView.swift
//  Parsimonious
//
//  Created by Nick Venanzi on 10/2/24.
//

import SwiftUI
import UIKit // Import UIKit for haptic feedback

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
        ZStack {
            Image("Parsimonious")
                .resizable()
                .scaledToFill()
                .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
                .position(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height / 2)
                .opacity(0.04)
                .ignoresSafeArea()
            
            LinearGradient(
                gradient: Gradient(colors: [Color.midGreen.opacity(0.2), Color.midGreen.opacity(0.8)]),
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea(edges: .all)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            
            VStack {
                ParsimoniousHeaderView()
                
                AmountView(amount: $inputAmount, focus: $focusAmount)
                
                DescriptionView(description: $inputDescription, focusDescription: $focusDescription, focusAmount: $focusAmount, selection: $selectedCategory)
                
                NoteView(note: $inputNote)
                
                CategoryView(selection: $selectedCategory)
                
                Spacer()
                
                AddReceiptView(amount: $inputAmount, description: $inputDescription, note: $inputNote, category: $selectedCategory, completion: {
                    // Trigger success haptic feedback
                    let notificationGenerator = UINotificationFeedbackGenerator()
                    notificationGenerator.notificationOccurred(.success)

                    completion()
                    inputAmount = "$0.00"
                    inputDescription = ""
                    inputNote = ""
                    selectedCategory = nil
                    focusDescription = true
                    focusAmount = false
                })
            }
        }
        .background(Color.lightGreen.ignoresSafeArea())
        .onAppear {
            focusDescription = true
            focusAmount = false
        }
        .onTapGesture {
            hideKeyboard()
        }
    }
    
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

extension UIApplication {
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
