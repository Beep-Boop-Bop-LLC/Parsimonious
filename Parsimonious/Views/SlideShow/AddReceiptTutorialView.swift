//
//  AddReceiptTutorialView.swift
//  Parsimonious
//
//  Created by Zach Venanzi on 11/9/25.
//


//
//  AddReceiptTutorialView.swift
//  Parsimonious
//
//  Tutorial Screen 2: Adding a Receipt
//

import SwiftUI

struct AddReceiptTutorialView: View {
    @State private var animateAmount = false
    
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
                Text("Step 1: Enter Amount")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .padding(.top, 50)
                
                // Example Amount Display
                Text("$25.99")
                    .font(.system(size: 70, weight: .heavy))
                    .foregroundColor(.darkGreen)
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color.white.opacity(0.3))
                    )
                    .shadow(color: .black.opacity(0.2), radius: 5, x: 2, y: 2)
                    .scaleEffect(animateAmount ? 1.05 : 1.0)
                    .animation(.easeInOut(duration: 1.0).repeatForever(autoreverses: true), value: animateAmount)
                
                VStack(alignment: .leading, spacing: 15) {
                    HStack(alignment: .top, spacing: 12) {
                        Image(systemName: "1.circle.fill")
                            .font(.title2)
                            .foregroundColor(.lightBeige)
                        
                        VStack(alignment: .leading, spacing: 5) {
                            Text("Tap the amount field")
                                .font(.headline)
                                .foregroundColor(.white)
                            Text("The keyboard will appear automatically")
                                .font(.subheadline)
                                .foregroundColor(.lightBeige.opacity(0.8))
                        }
                    }
                    
                    HStack(alignment: .top, spacing: 12) {
                        Image(systemName: "2.circle.fill")
                            .font(.title2)
                            .foregroundColor(.lightBeige)
                        
                        VStack(alignment: .leading, spacing: 5) {
                            Text("Type the amount")
                                .font(.headline)
                                .foregroundColor(.white)
                            Text("Just enter numbers - formatting happens automatically")
                                .font(.subheadline)
                                .foregroundColor(.lightBeige.opacity(0.8))
                        }
                    }
                    
                    HStack(alignment: .top, spacing: 12) {
                        Image(systemName: "info.circle.fill")
                            .font(.title2)
                            .foregroundColor(.softYellow)
                        
                        VStack(alignment: .leading, spacing: 5) {
                            Text("Pro Tip")
                                .font(.headline)
                                .foregroundColor(.white)
                            Text("Enter 2599 to get $25.99 - the last two digits are cents")
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
            animateAmount = true
        }
    }
}