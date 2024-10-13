//
//  GraphView.swift
//  Parsimonious
//
//  Created by Zach Venanzi on 10/11/24.
//

import SwiftUI

import SwiftUI

import SwiftUI

import SwiftUI

struct GraphView: View {
    
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
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            VStack{
                ParsimoniousHeaderView()
                
                List{
                    BarGraphView(receiptController: ReceiptController())
                        .listRowBackground(Color.clear) // Set each row's background to white
                    HeatMapView(receiptController: ReceiptController())
                        .listRowBackground(Color.clear) // Set each row's background to white
                }
                .listStyle(PlainListStyle()) // Optional: Change the list style if needed
                .scrollContentBackground(.hidden) // Hide the default scroll background (iOS 16+)
                .frame(maxWidth: .infinity)
                .padding(.bottom, 20)
            }
        }

        .background(Color.lightGreen.ignoresSafeArea())
    }
}
