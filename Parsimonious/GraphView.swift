//
//  GraphView.swift
//  Parsimonious
//
//  Created by Zach Venanzi on 10/11/24.
//

import SwiftUI

struct GraphView: View {
    
    @EnvironmentObject var controller: ReceiptController
    @State private var selectedCategory: Set<String> = []

    var categories: [String] {
        let allCategories = ["All"]
        return allCategories + controller.categories.sorted()
    }

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
                
                SummaryCategoryView(categories: $selectedCategory) // Updated binding

                List {
                    CircleGraphView(receiptController: controller, selectedCategories: selectedCategory) // Pass selected categories
                    .frame(height: 175)
                    .listRowBackground(Color.clear)
                    BarGraphView(receiptController: controller, selectedCategories: selectedCategory)
                        .listRowBackground(Color.clear)
                    HeatMapView(receiptController: controller)
                        .listRowBackground(Color.clear)
                        .padding()
                }
                .listStyle(PlainListStyle())
                .scrollContentBackground(.hidden)
                .frame(maxWidth: .infinity)
                .padding(.bottom, 20)
            }
        }
        .background(Color.lightGreen.ignoresSafeArea())
        .onChange(of: selectedCategory) { newValue in
            print("Selected Categories: \(newValue)") // Debugging print statement
        }
    }
}
