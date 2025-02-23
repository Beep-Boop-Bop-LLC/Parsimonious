//
//  ThirdSlideVIew.swift
//  Parsimonious
//
//  Created by Zach Venanzi on 1/27/25.
//

import Foundation
import SwiftUI

struct ThirdScreenView: View {
    var body: some View {
        ZStack {
            Color.lightGreen // Background color
                .edgesIgnoringSafeArea(.all)
            
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
    }
}
