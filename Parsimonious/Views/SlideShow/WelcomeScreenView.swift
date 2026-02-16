//
//  WelcomeScreenView.swift
//  Parsimonious
//
//  Created by Zach Venanzi on 11/9/25.
//


//
//  WelcomeScreenView.swift
//  Parsimonious
//
//  Tutorial Screen 1: Welcome
//

import SwiftUI

struct WelcomeScreenView: View {
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
            
            VStack(spacing: 30) {
                Spacer()
                
                Image(systemName: "receipt.fill")
                    .font(.system(size: 80))
                    .foregroundColor(.lightBeige)
                    .shadow(color: .black.opacity(0.3), radius: 10, x: 0, y: 5)
                
                Text("Welcome to\nParsimonious")
                    .font(.system(size: 42, weight: .bold))
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .shadow(color: .black.opacity(0.2), radius: 5, x: 2, y: 2)
                
                Text("Your simple receipt tracker")
                    .font(.title3)
                    .fontWeight(.medium)
                    .foregroundColor(.lightBeige)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                
                Spacer()
                
                VStack(spacing: 15) {
                    HStack(spacing: 15) {
                        Image(systemName: "bolt.fill")
                            .foregroundColor(.softYellow)
                        Text("Quick & Easy Entry")
                            .foregroundColor(.white)
                            .fontWeight(.semibold)
                    }
                    
                    HStack(spacing: 15) {
                        Image(systemName: "square.grid.2x2.fill")
                            .foregroundColor(.softYellow)
                        Text("Smart Categories")
                            .foregroundColor(.white)
                            .fontWeight(.semibold)
                    }
                    
                    HStack(spacing: 15) {
                        Image(systemName: "camera.fill")
                            .foregroundColor(.softYellow)
                        Text("AI-Powered Scanning")
                            .foregroundColor(.white)
                            .fontWeight(.semibold)
                    }
                    
                    HStack(spacing: 15) {
                        Image(systemName: "chart.bar.fill")
                            .foregroundColor(.softYellow)
                        Text("Budget Tracking")
                            .foregroundColor(.white)
                            .fontWeight(.semibold)
                    }
                }
                .padding(.vertical, 20)
                
                Text("Swipe to learn how to use the app →")
                    .font(.subheadline)
                    .foregroundColor(.lightBeige.opacity(0.8))
                    .padding(.bottom, 30)
                
                Spacer()
            }
            .padding()
        }
        .background(Color.lightGreen.ignoresSafeArea())
    }
}