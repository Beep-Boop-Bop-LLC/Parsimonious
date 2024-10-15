//
//  GraphView.swift
//  Parsimonious
//
//  Created by Zach Venanzi on 10/11/24.
//

import SwiftUI

struct GraphsView: View {
    
    @ObservedObject var receiptController = ReceiptController()
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
                
                SummaryCategoryView(categories: $selectedCategory)

                List {
                    CircleGraphView(receiptController: controller, selectedCategories: selectedCategory)
                        .listRowBackground(Color.clear)
                    
                    HeatMapView(receiptController: controller)
                        .listRowBackground(Color.clear)
                        .padding(.horizontal)
                        .padding(.top, -20)
                    
                    ForEach(receiptController.categories.sorted(), id: \.self) { category in
                        let currentMonthTotal = receiptController.receipts
                            .filter { $0.category == category && $0.date.month == ReceiptDate().month }
                            .reduce(0) { $0 + $1.amount }
                        
                        let averageMonthTotal = receiptController.receipts
                            .filter { $0.category == category }
                            .reduce(0) { $0 + $1.amount } / 12 // Assuming a 12-month average
                        
                        CategoryCellView(
                            category: category,
                            currentMonthTotal: currentMonthTotal,
                            averageMonthTotal: averageMonthTotal
                        )
                        .listRowBackground(Color.clear)
                    }
                }
                .listStyle(PlainListStyle())
                .listRowSeparator(.hidden)
                .scrollContentBackground(.hidden)
                .frame(maxWidth: .infinity)
            }
            .padding(.bottom, 20)
        }
        .background(Color.lightGreen.ignoresSafeArea())
        .onChange(of: selectedCategory) { newValue in
            print("Selected Categories: \(newValue)")
        }
        .onTapGesture {
            hideKeyboard()
        }
    }

    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
