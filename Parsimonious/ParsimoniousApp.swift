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
    static let paleBlue = Color(red: 0.27, green: 0.51, blue: 0.71)
    static let seafoamGreen = Color(red: 0.18, green: 0.55, blue: 0.34) // Steel Blue
}
