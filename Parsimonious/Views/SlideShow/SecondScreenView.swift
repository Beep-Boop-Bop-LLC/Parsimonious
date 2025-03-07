//
//  SecondScreenView.swift
//  Parsimonious
//
//  Created by Zach Venanzi on 1/27/25.
//

import SwiftUI


struct SecondScreenView: View {
    
    let categories = ["Home", "Utilities", "Groceries"]
    @State private var selectedCategory = "Groceries" // Default selection

    var body: some View {
        ZStack {
            Image("Parsimonious")
                .resizable()
                .scaledToFill()
                .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height) // Full screen size
                .position(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height / 2) // Center the image
                .opacity(0.04)
                .ignoresSafeArea() // Extend beyond safe areas
            
            LinearGradient(
                gradient: Gradient(colors: [Color.lightBeige.opacity(0.2), Color.lightBeige.opacity(0.8)]),
                startPoint: .top,
                endPoint: .bottom
            )
            
            .ignoresSafeArea(edges: .all) // Ensures the gradient extends beyond the safe area
            .frame(maxWidth: .infinity, maxHeight: .infinity) //
            VStack {
                Spacer()
                Text("$10.00")
                    .customTextField()
                    .font(.system(size: 70, weight: .heavy))
                    .shadow(color: .black.opacity(0.1), radius: 5, x: 2, y: 2) // Adjust shadow parameters here
                Text("Vegetables")
                    .customTextField()
                    .shadow(color: .black.opacity(0.1), radius: 5, x: 2, y: 2) // Adjust shadow parameters here
                HStack(spacing: 10) {
                        ForEach(categories, id: \.self) { category in
                            Text(category)
                                .font(.system(size: 20, weight: .semibold))
                                .foregroundColor(category == selectedCategory ? .darkGreen : .lightBeige) // Green text for both
                                .padding()
                                .background(category == selectedCategory ? Color.white : Color.clear) // White background for selected
                                .cornerRadius(8)
                                .shadow(color: category == selectedCategory ? .black.opacity(0.2) : .clear, radius: 5, x: 2, y: 2)
                                .onTapGesture {
                                    selectedCategory = category
                                }
                        }
                            }
                Text("Add")
                    .font(.system(size: 20, weight: .semibold))
                    .padding()
                    .foregroundColor(.lightBeige)
                    .frame(maxWidth: .infinity)
                    .shadow(color: .black.opacity(0.2), radius: 5, x: 2, y: 2)
                    .padding(.horizontal)
                    .background(Color.lightBeige.opacity(0.4))
                    .cornerRadius(8)
                    .padding()
                Spacer()
                Text("""
                • Amount: $10.00
                • Description: Vegetables
                • Category: Groceries.

                This is a complete receipt, and a confirmation is that the Add button turns white.
                """)
                .font(.title3)
                .foregroundColor(Color.darkGreen.opacity(0.4))
                .multilineTextAlignment(.center)
                .padding()

                Spacer()


                
            }
        }
        .background(Color.lightGreen.ignoresSafeArea())
    }
}
