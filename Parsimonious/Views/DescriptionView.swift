//
//  DescriptionView.swift
//  Parsimonious
//
//  Created by Nick Venanzi on 10/1/24.
//

import SwiftUI

struct DescriptionView: View {
    
    @EnvironmentObject var controller: ReceiptController
    @Binding var description: String
    @FocusState.Binding var focusDescription: Bool
    @FocusState.Binding var focusAmount: Bool
    @Binding var selection: String?
    
    var body: some View {
        ZStack {
            if description.isEmpty {
                Text("x")
                    .font(.system(size: 25, weight: .semibold))
                    .foregroundColor(.seafoamGreen)
                    .frame(maxWidth: .infinity, alignment: .center)
            }
            TextField("", text: $description)
                .customTextField()
                .focused($focusDescription)
                .onSubmit {
                    focusDescription = false
                    focusAmount = true
                }
                .onChange(of: description) { _, description in
                    if let categoryMatch = controller.retrieveCategory(description) {
                        selection = categoryMatch
                    }
                }
        }
    }
    
}

