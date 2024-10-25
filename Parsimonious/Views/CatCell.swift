//
//  CatCell.swift
//  Parsimonious
//
//  Created by Zach Venanzi on 10/15/24.
//

import SwiftUI

struct CatCell: View {
    let categoryName: String = "Groceries"
    let budget: Double
    let currentSum: Double
    let averageSum: Double
    let relativePercentChangeCurrent: Double
    let relativePercentChangeAverage: Double
    
    var body: some View {
            VStack(alignment: .leading, spacing: 2) {
                HStack{
                    VStack{
                        HStack {
                            Text(categoryName)
                                .font(.largeTitle)
                                .fontWeight(.medium)
                                .foregroundColor(.lightBeige)
                            Spacer()
                        }
                        HStack {
                            Text("$\(String(format: "%.2f", currentSum))") //This will be the current sum of all receipts in the month
                                .font(.title2)
                                .fontWeight(.medium)
                                .minimumScaleFactor(0.5)

                                .foregroundColor(.lightBeige)
                            Text("/ $500") ///This will be a TEXTFIELD where you will then be able to input your budgets for category
                                .font(.title2)
                                .fontWeight(.medium)
                                .minimumScaleFactor(0.5)

                                .foregroundColor(.lightBeige.opacity(0.7))
                            Spacer()
                        }
                        HStack {
                            Text("▲ $153.30 (31.04%)") // This is a percent greater than last 30 days
                                .font(.subheadline)
                                .fontWeight(.heavy)
                                .minimumScaleFactor(0.5)
                                .foregroundColor(.red.opacity(0.8))
                            Text("Past Month")
                                .font(.subheadline)
                                .fontWeight(.heavy)
                                .minimumScaleFactor(0.5)
                                .foregroundColor(.lightBeige)
                            Spacer()

                        }
                        HStack {
                            Text("▼ 150.00 (30.0%)") // this is a percent under budget (Maybe last week)
                                .font(.subheadline)
                                .fontWeight(.heavy)
                                .minimumScaleFactor(0.5)

                                .foregroundColor(.lightGreen)
                            Text("Past Week")
                                .font(.subheadline)
                                .fontWeight(.heavy)
                                .minimumScaleFactor(0.5)

                                .foregroundColor(.lightBeige)
                            Spacer()
                        }
                    }
                    Spacer()
                        // Circle chart for current month
                        // you can maybe refer to the CircleGraphView for this
                        ZStack {
                            Circle()
                                .stroke(lineWidth: 10)
                                .opacity(0.3)
                                .foregroundColor(.lightBeige.opacity(0.7))
                            
                            // Circle filled to 75%
                            Circle()
                                .trim(from: 0.0, to: 0.75) // Set to 75% filled
                                .stroke(style: StrokeStyle(lineWidth: 10, lineCap: .round, lineJoin: .round))
                                .foregroundColor(.lightGreen) // Existing color
                                .rotationEffect(Angle(degrees: 270)) // Start the circle from the top
                                .animation(.easeInOut(duration: 0.5)) // Animation for smoothness
                            
                            // Percentage text in the center
                            Text("75%") // Static percentage text
                                .font(.body)
                                .fontWeight(.heavy)
                                .multilineTextAlignment(.center)
                                .foregroundColor(.lightBeige)
                        }
                        .frame(width: 100, height: 100) // Adjusted size for centering
                        .contentShape(Circle()) // Ensure the touchable area is circular
                }
            }
            .padding()
            .background(Color.white.opacity(0.1))
            .cornerRadius(10)
            .shadow(radius: 5)
        }
    
}
