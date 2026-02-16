//
//  CameraTutorialView.swift
//  Parsimonious
//
//  Created by Zach Venanzi on 11/9/25.
//


//
//  CameraTutorialView.swift
//  Parsimonious
//
//  Tutorial Screen 5: Using Camera & Photos
//

import SwiftUI

struct CameraTutorialView: View {
    @State private var animateButtons = false
    
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
                Text("AI-Powered Scanning")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .padding(.top, 50)
                
                // Example buttons in grid
                HStack(spacing: 16) {
                    VStack(spacing: 6) {
                        Image(systemName: "photo.on.rectangle")
                            .font(.system(size: 40))
                            .foregroundColor(.lightBeige)
                        Text("Library")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(.lightBeige)
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color.white.opacity(0.15))
                    )
                    .shadow(color: .black.opacity(0.15), radius: 3, x: 2, y: 2)
                    .scaleEffect(animateButtons ? 1.05 : 1.0)
                    
                    VStack(spacing: 6) {
                        Image(systemName: "camera.fill")
                            .font(.system(size: 40))
                            .foregroundColor(.lightBeige)
                        Text("Camera")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(.lightBeige)
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color.white.opacity(0.2))
                    )
                    .shadow(color: .black.opacity(0.15), radius: 3, x: 2, y: 2)
                    .scaleEffect(animateButtons ? 1.05 : 1.0)
                }
                .padding(.horizontal)
                .animation(.easeInOut(duration: 1.0).repeatForever(autoreverses: true), value: animateButtons)
                
                VStack(alignment: .leading, spacing: 15) {
                    HStack(alignment: .top, spacing: 12) {
                        Image(systemName: "camera.fill")
                            .font(.title2)
                            .foregroundColor(.lightBeige)
                        
                        VStack(alignment: .leading, spacing: 5) {
                            Text("Scan receipts instantly")
                                .font(.headline)
                                .foregroundColor(.white)
                            Text("Take a photo or choose from your library in the category grid")
                                .font(.subheadline)
                                .foregroundColor(.lightBeige.opacity(0.8))
                        }
                    }
                    
                    HStack(alignment: .top, spacing: 12) {
                        Image(systemName: "brain.head.profile")
                            .font(.title2)
                            .foregroundColor(.softYellow)
                        
                        VStack(alignment: .leading, spacing: 5) {
                            Text("AI extracts information")
                                .font(.headline)
                                .foregroundColor(.white)
                            Text("The app automatically reads amount, description, and suggests categories")
                                .font(.subheadline)
                                .foregroundColor(.lightBeige.opacity(0.8))
                        }
                    }
                    
                    HStack(alignment: .top, spacing: 12) {
                        Image(systemName: "checkmark.circle.fill")
                            .font(.title2)
                            .foregroundColor(.lightBeige)
                        
                        VStack(alignment: .leading, spacing: 5) {
                            Text("Review and confirm")
                                .font(.headline)
                                .foregroundColor(.white)
                            Text("Check the extracted data and make any corrections before adding")
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
                            Text("Make sure the receipt is well-lit and clearly visible for best results")
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
            animateButtons = true
        }
    }
}