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

    var recentReceipts: [Receipt] {
        controller.receipts.sorted {
            // Sort by year, month, day in descending order
            if $0.date.year != $1.date.year {
                return $0.date.year > $1.date.year
            }
            if $0.date.month != $1.date.month {
                return $0.date.month > $1.date.month
            }
            return $0.date.day > $1.date.day
        }
        .prefix(3) // Get the 3 most recent receipts
        .map { $0 } // Convert ArraySlice to Array
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
                
                ScrollView {
                    CircleGraphView()
                        .listRowBackground(Color.clear)
                    
                    HeatMapView()
                        .listRowBackground(Color.clear)
                        .padding(.horizontal)
                        .padding(.top, -20)
                    
                    // Add recent receipts
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Recent Receipts")
                            .font(.headline)
                            .foregroundColor(.lightBeige)
                            .padding(.leading)
                        
                        ForEach(recentReceipts, id: \.self) { receipt in
                            HStack {
                                DateView(receipt.date)
                                    .frame(maxHeight: 40)
                                
                                VStack(alignment: .leading) {
                                    Text(receipt.description)
                                        .font(.body)
                                        .foregroundColor(.lightBeige)
                                    Text(receipt.category)
                                        .font(.caption2)
                                        .foregroundColor(.lightBeige.opacity(0.7))
                                }
                                Spacer()
                                Text(String(format: "$%.2f", receipt.amount))
                                    .font(.body)
                                    .foregroundColor(.lightBeige)
                            }
                            .padding(.horizontal)
                            .background(Color.lightGreen.opacity(0.2))
                            .cornerRadius(8)
                        }
                    }
                    .padding(.top, 10)
                    
                    ForEach(Array(controller.categories).sorted(), id: \.self) { category in
                        NavigationLink(destination: ReceiptListViewController(categories: .constant([category]), title: category)
                                        .environmentObject(controller)) {
                            CatCell(category)
                        }
                    }
                    MailView()
                }
                .background(Color.clear) // Set ScrollView background to clear

            }
            .padding(.bottom, 20)
        }
        .background(Color.lightGreen.ignoresSafeArea())
        .onTapGesture {
            hideKeyboard()
        }
    }

    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
