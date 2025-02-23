//
//  SecondScreenView.swift
//  Parsimonious
//
//  Created by Zach Venanzi on 1/27/25.
//

import SwiftUI


struct SecondScreenView: View {
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
                Text("Every Receipt must have the following:")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .padding()
                Text("$10")
                    .font(.system(size: 70, weight: .heavy))
                    .shadow(color: .black.opacity(0.1), radius: 5, x: 2, y: 2) // Adjust shadow parameters here
                    .foregroundColor(.darkGreen)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                Text("An Amount")
                    .font(.title3)
                    .foregroundColor(.white.opacity(0.8))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                    .underline()
                Text("Pizza")
                    .font(.system(size: 45, weight: .heavy))
                    .shadow(color: .black.opacity(0.1), radius: 5, x: 2, y: 2) // Adjust shadow parameters here
                    .foregroundColor(.darkGreen)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                Text("A Description")
                    .font(.title3)
                    .foregroundColor(.white.opacity(0.8))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                    .underline()
                HStack{
                    Text("Home")
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundColor(.darkGreen)
                        .shadow(color: .black.opacity(0.2), radius: 5, x: 2, y: 2) // Adjust shadow parameters here
                        .padding()
                        //.background(selection == category ? Color.lightBeige : Color.clear)
                    Text("Food")
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundColor(.darkGreen)
                        .shadow(color: .black.opacity(0.2), radius: 5, x: 2, y: 2) // Adjust shadow parameters here
                        .padding()
                        .background(Color.lightBeige)
                        .cornerRadius(8)
                    Text("Utilities")
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundColor(.darkGreen)
                        .shadow(color: .black.opacity(0.2), radius: 5, x: 2, y: 2) // Adjust shadow parameters here
                        .padding()
                        //.background(selection == category ? Color.lightBeige : Color.clear)
                }
                Text("A Category")
                    .font(.title3)
                    .foregroundColor(.white.opacity(0.8))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                    .underline()
                Text("Press and hold on categories to delete them. Or add by selecting the '+'")
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundColor(.darkGreen)
                    .shadow(color: .black.opacity(0.2), radius: 5, x: 2, y: 2) // Adjust shadow parameters here
                    .padding()
                    .frame(alignment: .center)
                Text("Categories will be automatically switched to if there is a prior receipt with the same description.")
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundColor(.darkGreen)
                    .shadow(color: .black.opacity(0.2), radius: 5, x: 2, y: 2) // Adjust shadow parameters here
                    .padding()
                    .frame(alignment: .center)
                Spacer()

                
            }
        }
        .background(Color.lightGreen.ignoresSafeArea())
    }
}
