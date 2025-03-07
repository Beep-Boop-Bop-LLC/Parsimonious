//
//  SlideShowView.swift
//  Parsimonious
//
//  Created by Zach Venanzi on 1/27/25.
//

import SwiftUI

struct SlideShowView: View {
    @Environment(\.presentationMode) var presentationMode // To dismiss the view
    @State private var currentIndex = 0 // To track the current page

    // Sample screens with different content
    var body: some View {
        ZStack {
            TabView(selection: $currentIndex) {
                // First screen: Custom view
                FirstScreenView()
                    .tag(0) // Track the first screen
                
                SecondScreenView()
                    .tag(1)
            }
            .tabViewStyle(PageTabViewStyle()) // Enables swipeable pages
            .edgesIgnoringSafeArea(.all) // Covers the entire screen
            
            // Top-right dismiss button
            VStack {
                HStack {
                    Spacer()
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Image(systemName: "xmark")
                            .font(.title)
                            .foregroundColor(.white)
                            .padding()
                    }
                }
                Spacer()
            }
        }
    }
}
