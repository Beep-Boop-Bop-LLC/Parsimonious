//
//  ParsimoniousHeader.swift
//  Parsimonious
//
//  Created by Nick Venanzi on 10/1/24.
//
import SwiftUI

struct ParsimoniousHeaderView: View {
    
    var body: some View {
        Text("Parsimonious")
            .multilineTextAlignment(.center)
            .font(.largeTitle)
            .fontWeight(.bold)
            .foregroundColor(.darkGreen)
            .shadow(color: .black.opacity(0.2), radius: 5, x: 2, y: 2) // Adjust shadow parameters here

    }
    
}
