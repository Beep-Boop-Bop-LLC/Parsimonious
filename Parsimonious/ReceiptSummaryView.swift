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
            Image("Parsimonious")
                .resizable()
                .scaledToFill()
                .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height) // Full screen size
                .position(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height / 2) // Center the image
                .opacity(0.04)
                .ignoresSafeArea() // Extend beyond safe areas
            
            LinearGradient(
                gradient: Gradient(colors: [Color.midGreen.opacity(0.2), Color.midGreen.opacity(0.8)]),
                startPoint: .top,
                endPoint: .bottom
            )
            
            .ignoresSafeArea(edges: .all) // Ensures the gradient extends beyond the safe area
            .frame(maxWidth: .infinity, maxHeight: .infinity) //
            
            VStack {
                ParsimoniousHeaderView()
                
                SummaryCategoryView(categories: $selectedCategories)
                
                ReceiptListView(categories: $selectedCategories)

            }
            .padding(.bottom, 20) // Add some padding at the bottom for scrolling

        }
        .background(Color.lightGreen.ignoresSafeArea())
        .onAppear {
            selectedCategories.insert("All")
            for category in controller.categories {
                selectedCategories.insert(category)
            }
        }
    }
}
