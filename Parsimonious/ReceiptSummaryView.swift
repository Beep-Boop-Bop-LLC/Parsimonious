//
//  ReceiptSummaryView.swift
//  Parsimonious
//
//  Created by Nick Venanzi on 10/2/24.
//

import SwiftUI

struct ReceiptSummaryView: View {
    
    @EnvironmentObject var controller: ReceiptController
    @State var selectedCategories: Set<String> = Set()
    
    var body: some View {
        ZStack{
            LinearGradient(
                gradient: Gradient(colors: [Color.white.opacity(0.2), Color.white.opacity(0.8)]),
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea(edges: .all) // Ensures the gradient extends beyond the safe area
            .frame(maxWidth: .infinity, maxHeight: .infinity) // Fills the entire superview
            
            VStack {
                ParsimoniousHeaderView()
                
                SummaryCategoryView(categories: $selectedCategories)
                
                ReceiptListView(categories: $selectedCategories)
            }
            .padding(.bottom, 20) // Add some padding at the bottom for scrolling

        }
        .background(Color.paleGreen.ignoresSafeArea())
        .onAppear {
            selectedCategories.insert("All")
            for category in controller.categories {
                selectedCategories.insert(category)
            }
        }
    }
}
