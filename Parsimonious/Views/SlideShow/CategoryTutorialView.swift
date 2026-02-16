//
//  CategoryTutorialView.swift
//  Parsimonious
//
//  Created by Zach Venanzi on 11/9/25.
//


//
//  CategoryTutorialView.swift
//  Parsimonious
//
//  Tutorial Screen 4: Selecting Categories
//

import SwiftUI

struct CategoryTutorialView: View {
    let categories = ["Groceries", "Dining", "Transport", "Home"]
    @State private var selectedCategory = "Groceries"
    @State private var animateGrid = false
    
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
            
            VStack(spacing: 20) {
                Text("Step 3: Choose Category")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .padding(.top, 50)
                
                // Example Category Grid
                LazyVGrid(columns: [GridItem(.adaptive(minimum: 100), spacing: 12)], spacing: 12) {
                    ForEach(categories, id: \.self) { category in
                        Text(category)
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(category == selectedCategory ? .darkGreen : .lightBeige)
                            .padding(.vertical, 12)
                            .frame(maxWidth: .infinity)
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(category == selectedCategory ? Color.lightBeige.opacity(0.25) : Color.black.opacity(0.05))
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 12)
                                            .stroke(category == selectedCategory ? Color.lightBeige.opacity(0.6) : Color.black.opacity(0.1), lineWidth: 1)
                                    )
                            )
                            .shadow(color: .black.opacity(0.15), radius: 3, x: 2, y: 2)
                            .scaleEffect(animateGrid && category == selectedCategory ? 1.05 : 1.0)
                            .onTapGesture {
                                selectedCategory = category
                            }
                    }
                }
                .padding(.horizontal)
                .animation(.easeInOut(duration: 1.0).repeatForever(autoreverses: true), value: animateGrid)
                
                VStack(alignment: .leading, spacing: 15) {
                    HStack(alignment: .top, spacing: 12) {
                        Image(systemName: "square.grid.2x2.fill")
                            .font(.title2)
                            .foregroundColor(.lightBeige)
                        
                        VStack(alignment: .leading, spacing: 5) {
                            Text("Tap to select a category")
                                .font(.headline)
                                .foregroundColor(.white)
                            Text("The selected category will be highlighted")
                                .font(.subheadline)
                                .foregroundColor(.lightBeige.opacity(0.8))
                        }
                    }
                    
                    HStack(alignment: .top, spacing: 12) {
                        Image(systemName: "plus.circle.fill")
                            .font(.title2)
                            .foregroundColor(.lightBeige)
                        
                        VStack(alignment: .leading, spacing: 5) {
                            Text("Create new categories")
                                .font(.headline)
                                .foregroundColor(.white)
                            Text("Tap 'New' to add custom categories for your needs")
                                .font(.subheadline)
                                .foregroundColor(.lightBeige.opacity(0.8))
                        }
                    }
                    
                    HStack(alignment: .top, spacing: 12) {
                        Image(systemName: "hand.point.up.left.fill")
                            .font(.title2)
                            .foregroundColor(.softYellow)
                        
                        VStack(alignment: .leading, spacing: 5) {
                            Text("Long press to delete")
                                .font(.headline)
                                .foregroundColor(.white)
                            Text("Hold down on a category to see the delete option")
                                .font(.subheadline)
                                .foregroundColor(.lightBeige.opacity(0.8))
                        }
                    }
                }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.white.opacity(0.15))
                )
                .padding(.horizontal)
                
                Spacer()
            }
        }
        .background(Color.lightGreen.ignoresSafeArea())
        .onAppear {
            animateGrid = true
        }
    }
}