//
//  CompleteReceiptTutorialView.swift
//  Parsimonious
//
//  Created by Zach Venanzi on 11/9/25.
//


//
//  CompleteReceiptTutorialView.swift
//  Parsimonious
//
//  Tutorial Screen 6: Completing the Receipt
//

import SwiftUI

struct CompleteReceiptTutorialView: View {
    @State private var isComplete = true
    @State private var animateButton = false
    
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
                Text("Step 4: Add Receipt")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .padding(.top, 50)
                
                // Example receipt summary
                VStack(spacing: 15) {
                    HStack {
                        Text("Amount:")
                            .foregroundColor(.lightBeige.opacity(0.8))
                        Spacer()
                        Text("$25.99")
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                    }
                    
                    HStack {
                        Text("Description:")
                            .foregroundColor(.lightBeige.opacity(0.8))
                        Spacer()
                        Text("Coffee Shop")
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                    }
                    
                    HStack {
                        Text("Category:")
                            .foregroundColor(.lightBeige.opacity(0.8))
                        Spacer()
                        Text("Dining")
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                    }
                }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.white.opacity(0.2))
                )
                .padding(.horizontal)
                
                // Add Button Example
                Button(action: {}) {
                    Text("Add")
                        .font(.system(size: 20, weight: .semibold))
                        .padding()
                        .foregroundColor(isComplete ? .darkGreen : .lightBeige)
                        .frame(maxWidth: .infinity)
                        .shadow(color: .black.opacity(0.2), radius: 5, x: 2, y: 2)
                }
                .padding(.horizontal)
                .background(isComplete ? Color.lightBeige.opacity(0.4) : Color.midGreen.opacity(0.4))
                .cornerRadius(8)
                .padding(.horizontal)
                .scaleEffect(animateButton ? 1.03 : 1.0)
                .animation(.easeInOut(duration: 1.0).repeatForever(autoreverses: true), value: animateButton)
                
                VStack(alignment: .leading, spacing: 15) {
                    HStack(alignment: .top, spacing: 12) {
                        Image(systemName: "checkmark.circle.fill")
                            .font(.title2)
                            .foregroundColor(.lightBeige)
                        
                        VStack(alignment: .leading, spacing: 5) {
                            Text("Complete all fields")
                                .font(.headline)
                                .foregroundColor(.white)
                            Text("Amount, description, and category must all be filled")
                                .font(.subheadline)
                                .foregroundColor(.lightBeige.opacity(0.8))
                        }
                    }
                    
                    HStack(alignment: .top, spacing: 12) {
                        Image(systemName: "light.beacon.max.fill")
                            .font(.title2)
                            .foregroundColor(.softYellow)
                        
                        VStack(alignment: .leading, spacing: 5) {
                            Text("Button turns white when ready")
                                .font(.headline)
                                .foregroundColor(.white)
                            Text("The Add button becomes white when all required fields are complete")
                                .font(.subheadline)
                                .foregroundColor(.lightBeige.opacity(0.8))
                        }
                    }
                    
                    HStack(alignment: .top, spacing: 12) {
                        Image(systemName: "arrow.triangle.2.circlepath")
                            .font(.title2)
                            .foregroundColor(.lightBeige)
                        
                        VStack(alignment: .leading, spacing: 5) {
                            Text("Tap to save")
                                .font(.headline)
                                .foregroundColor(.white)
                            Text("Your receipt is saved and fields reset for the next entry")
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
            animateButton = true
        }
    }
}