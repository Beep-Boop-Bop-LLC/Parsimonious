//
//  FinalTipsTutorialView.swift
//  Parsimonious
//
//  Created by Zach Venanzi on 11/9/25.
//


//
//  FinalTipsTutorialView.swift
//  Parsimonious
//
//  Tutorial Screen 7: Additional Tips
//

import SwiftUI

struct FinalTipsTutorialView: View {
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
            
            ScrollView {
                VStack(spacing: 25) {
                    Text("You're All Set!")
                        .font(.system(size: 36, weight: .bold))
                        .foregroundColor(.white)
                        .padding(.top, 50)
                    
                    Text("Here are some additional features:")
                        .font(.title3)
                        .foregroundColor(.lightBeige)
                    
                    VStack(spacing: 15) {
                        FeatureTile(
                            icon: "chart.bar.fill",
                            title: "View Your Receipts",
                            description: "Tap the list icon to see all your receipts organized by date and category"
                        )
                        
                        FeatureTile(
                            icon: "calendar.badge.plus",
                            title: "Set Budgets",
                            description: "Create monthly budgets for each category to track your spending"
                        )
                        
                        FeatureTile(
                            icon: "square.and.arrow.up",
                            title: "Export Data",
                            description: "Download a CSV file of your receipts for use in Excel or Google Sheets"
                        )
                        
                        FeatureTile(
                            icon: "magnifyingglass",
                            title: "Search & Filter",
                            description: "Easily find receipts by date, category, or description"
                        )
                        
                        FeatureTile(
                            icon: "clock.arrow.circlepath",
                            title: "Quick Entry",
                            description: "After adding a receipt, fields reset automatically for rapid entry"
                        )
                    }
                    .padding(.horizontal)
                    
                    VStack(spacing: 10) {
                        Text("Ready to start tracking?")
                            .font(.title3)
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                        
                        Text("Close this tutorial and add your first receipt!")
                            .font(.subheadline)
                            .foregroundColor(.lightBeige.opacity(0.8))
                            .multilineTextAlignment(.center)
                    }
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color.darkGreen.opacity(0.3))
                    )
                    .padding(.horizontal)
                    .padding(.bottom, 30)
                }
            }
        }
        .background(Color.lightGreen.ignoresSafeArea())
    }
}

struct FeatureTile: View {
    let icon: String
    let title: String
    let description: String
    
    var body: some View {
        HStack(alignment: .top, spacing: 15) {
            Image(systemName: icon)
                .font(.system(size: 28))
                .foregroundColor(.softYellow)
                .frame(width: 40)
            
            VStack(alignment: .leading, spacing: 5) {
                Text(title)
                    .font(.headline)
                    .foregroundColor(.white)
                
                Text(description)
                    .font(.subheadline)
                    .foregroundColor(.lightBeige.opacity(0.8))
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.white.opacity(0.15))
        )
        .shadow(color: .black.opacity(0.1), radius: 3, x: 2, y: 2)
    }
}