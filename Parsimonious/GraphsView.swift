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
