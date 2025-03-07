//
//  FirstScreenView.swift
//  Parsimonious
//
//  Created by Zach Venanzi on 1/27/25.
//
import SwiftUI

struct FirstScreenView: View {
    
    let points = [
            ("Efficient", "Prioritizing seamless receipt input."),
            ("Simple", "No excess, just inputing receipts and budgets."),
            ("Export", "Download a CSV of your receipts for use in Excel, Google Sheets, or any analysis tool.")
        ]
    
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
                Text("Welcome to Parsimonious!")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .padding()
                VStack(alignment: .center, spacing: 20) {
                    Text("Our Mission:")
                        .font(.title2)
                        .foregroundColor(.white.opacity(0.8))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                        .padding(.top, 10)
                    
                    ForEach(points, id: \.0) { title, description in
                        VStack {
                            Text(title)
                                .font(.title3)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                                .multilineTextAlignment(.center)
                            
                            Text(description)
                                .font(.body)
                                .fontWeight(.semibold)
                                .foregroundColor(.white.opacity(0.7))
                                .multilineTextAlignment(.center)
                                .padding(.horizontal, 20)
                        }
                        .padding()
                        .background(Color.white.opacity(0.2))
                        .cornerRadius(12)
                        .shadow(radius: 5)
                    }
                }
                Spacer()
            }
        }
        .background(Color.lightGreen.ignoresSafeArea())
    }
}
