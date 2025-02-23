//
//  FirstScreenView.swift
//  Parsimonious
//
//  Created by Zach Venanzi on 1/27/25.
//
import SwiftUI

struct FirstScreenView: View {
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
                Text("Welcome to Parsimonious!")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                
                Text("The main goal of this app is to most efficiently input and categorize receitps.")
                    .font(.title2)
                    .foregroundColor(.white.opacity(0.8))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                    .padding(.top, 10)
                Text("In order to do that, we highly reccomend to turn on notifications on all credit cards using their native app or Apple Wallet. \n\nThis prevents missing or forgetting")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.white.opacity(0.8))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                    .padding(.top, 10)
                
                Spacer()
                
                Image(systemName: "wallet.pass")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 150, height: 150)
                    .foregroundColor(.white.opacity(0.9))
                    .padding(.bottom, 50)
            }
        }
        .background(Color.lightGreen.ignoresSafeArea())
    }
}
