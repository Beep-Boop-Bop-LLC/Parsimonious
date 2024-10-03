//
//  ContentView.swift
//  Parsimonious
//
//  Created by Nick Venanzi on 9/28/24.
//

import SwiftUI

struct ContentView: View {

    var body: some View {
        TabView {
            CreateReceiptView()
                .tabItem {
                    Label("Add Receipt", systemImage: "plus.circle")
                }
            
//            ReceiptSummaryView()
//                .tabItem {
//                    Label("Summary", systemImage: "chart.pie")
//                }
        }
    }
    
}

struct CustomTextFieldModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .multilineTextAlignment(.center)
            .foregroundColor(.seafoamGreen)
            .font(.system(size: 25, weight: .semibold))
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
