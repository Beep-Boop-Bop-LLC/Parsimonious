//
//  SlideShowView.swift
//  Parsimonious
//
//  Updated comprehensive tutorial slideshow
//

import SwiftUI

struct SlideShowView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var currentIndex = 0
    
    var body: some View {
        ZStack {
            TabView(selection: $currentIndex) {
                WelcomeScreenView()
                    .tag(0)
                
                AddReceiptTutorialView()
                    .tag(1)
                
                DescriptionTutorialView()
                    .tag(2)
                
                CategoryTutorialView()
                    .tag(3)
                
                CameraTutorialView()
                    .tag(4)
                
                CompleteReceiptTutorialView()
                    .tag(5)
                
                FinalTipsTutorialView()
                    .tag(6)
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))
            .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .always))
            .edgesIgnoringSafeArea(.all)
            
            // Top-right dismiss button
            VStack {
                HStack {
                    Spacer()
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        ZStack {
                            Circle()
                                .fill(Color.black.opacity(0.5))
                                .frame(width: 40, height: 40)
                            
                            Image(systemName: "xmark")
                                .font(.system(size: 18, weight: .semibold))
                                .foregroundColor(.white)
                        }
                        .shadow(color: .black.opacity(0.3), radius: 5, x: 0, y: 2)
                    }
                    .padding(.trailing, 20)
                    .padding(.top, 50)
                }
                Spacer()
            }
            
            // Page indicator with count
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    Text("\(currentIndex + 1) / 7")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(.white)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(
                            Capsule()
                                .fill(Color.black.opacity(0.5))
                        )
                        .shadow(color: .black.opacity(0.3), radius: 5, x: 0, y: 2)
                    Spacer()
                }
                .padding(.bottom, 20)
            }
        }
    }
}
