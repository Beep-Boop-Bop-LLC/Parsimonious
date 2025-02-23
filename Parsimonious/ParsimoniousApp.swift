//
//  ParsimoniousApp.swift
//  Parsimonious
//
//  Created by Nick Venanzi on 9/28/24.
//

import SwiftUI

@main
struct ParsimoniousApp: App {
    
    @StateObject var controller: ReceiptController = ReceiptController()
    
    var body: some Scene {
        WindowGroup {
            ContentView().environmentObject(controller)
        }
    }
}

extension Color {
    static let paleGreen = Color(red: 0.7, green: 1.0, blue: 0.7)
    static let lightBeige = Color(red: 235 / 255, green: 233 / 255, blue: 220 / 255)
    static let lightGreen = Color(red: 159 / 255, green: 179 / 255, blue: 150 / 255)
    static let midGreen = Color(red: 96 / 255, green: 124 / 255, blue: 99 / 255)
    static let darkGreen = Color(red: 67 / 255, green: 103 / 255, blue: 88 / 255)
    static let gradient = LinearGradient(
            gradient: Gradient(colors: [
                Color.darkGreen.opacity(0.1),
                Color.darkGreen.opacity(0.95)
            ]),
            startPoint: .top,
            endPoint: .bottom
    )
}
