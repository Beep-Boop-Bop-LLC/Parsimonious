//
//  GraphView.swift
//  Parsimonious
//
//  Created by Zach Venanzi on 10/11/24.
//
import SwiftUI
import MessageUI

struct GraphsView: View {
    
    @EnvironmentObject var controller: ReceiptController
    @State private var showWarning = false // Controls warning visibility
    @State private var animateWarning = false

    var recentReceipts: [Receipt] {
        controller.receipts.sorted {
            if $0.date.year != $1.date.year {
                return $0.date.year > $1.date.year
            }
            if $0.date.month != $1.date.month {
                return $0.date.month > $1.date.month
            }
            return $0.date.day > $1.date.day
        }
        .prefix(3)
        .map { $0 }
    }

    var hasZeroBudgetCategory: Bool {
        return controller.categories.contains { category in
            (controller.categoriesToBudgets[category] ?? 0.0) == 0.00
        }
    }

    var body: some View {
        ZStack {
            // Background elements
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
                // Red Warning Banner with Smooth Animation
                if showWarning {
                    HStack {
                        Text("⚠️ Warning: One or more categories have a budget of $0.00")
                            .font(.body)
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                            .padding(.leading)
                        
                        Spacer()

                        Button(action: {
                            withAnimation(.easeOut(duration: 0.3)) {
                                showWarning = false
                            }
                        }) {
                            Image(systemName: "xmark.circle.fill")
                                .foregroundColor(.white)
                                .font(.title3)
                                .padding()
                        }
                    }
                    .padding()
                    .background(Color.red.opacity(0.3))
                    .cornerRadius(10)
                    .padding(.horizontal)
                    .opacity(animateWarning ? 1 : 0)
                    .offset(y: animateWarning ? 0 : -20) // Slide down effect
                    .onAppear {
                        withAnimation(.easeInOut(duration: 0.4)) {
                            animateWarning = true
                        }
                    }
                }


                // Header
                ParsimoniousHeaderView()
                
                ScrollView {
                    HorizontalBarGraph()
                    
                    ReceiptChartView(controller: controller)
                        .environmentObject(controller)
                    
                    HeatMapView()
                        .listRowBackground(Color.clear)
                        .padding(.horizontal)
                        .padding(.top, -20)
                    
                    .padding(.top, 10)
                    
                    // Category List
                    ForEach(Array(controller.categories).sorted(), id: \.self) { category in
                        NavigationLink(destination: ReceiptListViewController(categories: .constant([category]), title: category)
                                        .environmentObject(controller)) {
                            CatCell(category)
                        }
                    }

                    MailView()
                }
                .background(Color.clear)
            }
            .padding(.bottom, 20)
        }
        .background(Color.lightGreen.ignoresSafeArea())
        .onTapGesture {
            hideKeyboard()
        }
        .onAppear {
            showWarning = hasZeroBudgetCategory // Show warning on load if needed
        }
        .onChange(of: controller.categoriesToBudgets) { _ in
            // Check dynamically if any category becomes $0.00
            if hasZeroBudgetCategory {
                showWarning = true
            }
        }
    }

    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
