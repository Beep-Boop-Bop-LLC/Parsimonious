//
//  DescriptionTutorialView.swift
//  Parsimonious
//
//  Created by Zach Venanzi on 11/9/25.
//


//
//  DescriptionTutorialView.swift
//  Parsimonious
//
//  Tutorial Screen 3: Adding Description
//

import SwiftUI

struct DescriptionTutorialView: View {
    @State private var animateDescription = false
    
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
                Text("Step 2: Add Description")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .padding(.top, 50)
                
                // Example Description Display
                Text("Coffee Shop")
                    .font(.system(size: 32, weight: .semibold))
                    .foregroundColor(.darkGreen)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color.white.opacity(0.3))
                    )
                    .shadow(color: .black.opacity(0.2), radius: 5, x: 2, y: 2)
                    .padding(.horizontal)
                    .scaleEffect(animateDescription ? 1.02 : 1.0)
                    .animation(.easeInOut(duration: 1.0).repeatForever(autoreverses: true), value: animateDescription)
                
                VStack(alignment: .leading, spacing: 15) {
                    HStack(alignment: .top, spacing: 12) {
                        Image(systemName: "1.circle.fill")
                            .font(.title2)
                            .foregroundColor(.lightBeige)
                        
                        VStack(alignment: .leading, spacing: 5) {
                            Text("Enter what you bought")
                                .font(.headline)
                                .foregroundColor(.white)
                            Text("Be specific: 'Starbucks Coffee' or 'Gas - Shell'")
                                .font(.subheadline)
                                .foregroundColor(.lightBeige.opacity(0.8))
                        }
                    }
                    
                    HStack(alignment: .top, spacing: 12) {
                        Image(systemName: "sparkles")
                            .font(.title2)
                            .foregroundColor(.softYellow)
                        
                        VStack(alignment: .leading, spacing: 5) {
                            Text("Smart Category Suggestions")
                                .font(.headline)
                                .foregroundColor(.white)
                            Text("The app learns from your descriptions and suggests categories automatically")
                                .font(.subheadline)
                                .foregroundColor(.lightBeige.opacity(0.8))
                        }
                    }
                    
                    HStack(alignment: .top, spacing: 12) {
                        Image(systemName: "keyboard")
                            .font(.title2)
                            .foregroundColor(.lightBeige)
                        
                        VStack(alignment: .leading, spacing: 5) {
                            Text("Quick Navigation")
                                .font(.headline)
                                .foregroundColor(.white)
                            Text("Press 'Return' to move to the amount field")
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
            animateDescription = true
        }
    }
}