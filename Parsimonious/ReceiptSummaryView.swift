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
        ZStack {
            // Background Image
            Image("Parsimonious")
                .resizable()
                .scaledToFill()
                .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
                .position(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height / 2)
                .opacity(0.04)
                .ignoresSafeArea()

            // Gradient Overlay
            LinearGradient(
                gradient: Gradient(colors: [Color.midGreen.opacity(0.2), Color.midGreen.opacity(0.8)]),
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            .frame(maxWidth: .infinity, maxHeight: .infinity)

            VStack(spacing: 0) { // Ensures stable layout
                ParsimoniousHeaderView()

                ScrollView {
                    Text("Recent Receipts")
                        .font(.headline)
                        .foregroundColor(.lightBeige)
                        .padding(.leading)

                    ReceiptListView(categories: $selectedCategories)

                    List(Array(controller.categories).sorted(), id: \.self) { category in
                        NavigationLink(destination: ReceiptListViewController(categories: .constant([category]), title: category)
                                        .environmentObject(controller)) {
                            CatCell(category)
                        }
                    }
                    .listStyle(PlainListStyle()) // ✅ Ensures a clean appearance
                    .frame(maxHeight: 300) // ✅ Prevents excessive resizing

                }
            }

            .frame(maxHeight: UIScreen.main.bounds.height - 20)
            .padding(.bottom, 20) // Padding at the bottom for smooth scrolling
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
