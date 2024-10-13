//
//  ContentView.swift
//  Parsimonious
//
//  Created by Nick Venanzi on 9/28/24.
//

import SwiftUI

struct ContentView: View {

    @State private var selectedIndex: Int = 0
    
    var body: some View {
        TabView(selection: $selectedIndex) {
            CreateReceiptView(completion: { selectedIndex = 1 })
                .tabItem {
                    Label("Add Receipt", systemImage: "plus.circle")
                }
                .tag(0)
            
            ReceiptSummaryView()
                .tabItem {
                    Label("Reciepts", systemImage: "list.number")
                }
                .tag(1)
            GraphView()
                .tabItem {
                    Label("Summary", systemImage: "chart.pie")
                }
                .tag(2)
        }
        .accentColor(.darkGreen)
    }
}

struct CustomTextFieldModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .multilineTextAlignment(.center)
            .foregroundColor(.darkGreen)
            .shadow(color: .black.opacity(0.2), radius: 5, x: 2, y: 2) // Adjust shadow parameters here
            .font(.system(size: 45, weight: .heavy))
            .frame(maxWidth: .infinity, alignment: .center)
            .background(Color.clear)
            .autocorrectionDisabled(true)
    }
}

extension View {
    func customTextField() -> some View {
        self.modifier(CustomTextFieldModifier())
    }
}
