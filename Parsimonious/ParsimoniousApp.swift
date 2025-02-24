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
    // Existing Colors
    static let paleGreen = Color(red: 0.7, green: 1.0, blue: 0.7)
    static let lightBeige = Color(red: 235 / 255, green: 233 / 255, blue: 220 / 255)
    static let lightGreen = Color(red: 159 / 255, green: 179 / 255, blue: 150 / 255)
    static let midGreen = Color(red: 96 / 255, green: 124 / 255, blue: 99 / 255)
    static let darkGreen = Color(red: 67 / 255, green: 103 / 255, blue: 88 / 255)
    
    // Gradient
    static let gradient = LinearGradient(
        gradient: Gradient(colors: [
            Color.darkGreen.opacity(0.1),
            Color.darkGreen.opacity(0.95)
        ]),
        startPoint: .top,
        endPoint: .bottom
    )
    
    
    // Additional 20 Distinct Colors
    static let softYellow = Color(red: 252 / 255, green: 224 / 255, blue: 134 / 255)
    static let mustard = Color(red: 206 / 255, green: 160 / 255, blue: 58 / 255)
    static let burntOrange = Color(red: 186 / 255, green: 104 / 255, blue: 23 / 255)
    static let deepRed = Color(red: 150 / 255, green: 40 / 255, blue: 27 / 255)
    static let brickRed = Color(red: 178 / 255, green: 62 / 255, blue: 52 / 255)
    
    static let warmBrown = Color(red: 145 / 255, green: 90 / 255, blue: 52 / 255)
    static let mocha = Color(red: 115 / 255, green: 75 / 255, blue: 50 / 255)
    static let taupe = Color(red: 170 / 255, green: 142 / 255, blue: 115 / 255)
    static let sand = Color(red: 225 / 255, green: 205 / 255, blue: 170 / 255)
    static let mutedPink = Color(red: 215 / 255, green: 160 / 255, blue: 155 / 255)
    
    static let softLavender = Color(red: 200 / 255, green: 180 / 255, blue: 225 / 255)
    static let deepPurple = Color(red: 110 / 255, green: 90 / 255, blue: 180 / 255)
    static let slateBlue = Color(red: 88 / 255, green: 120 / 255, blue: 180 / 255)
    static let oceanBlue = Color(red: 70 / 255, green: 130 / 255, blue: 180 / 255)
    static let teal = Color(red: 75 / 255, green: 150 / 255, blue: 150 / 255)
    
    static let forestGreen = Color(red: 50 / 255, green: 110 / 255, blue: 50 / 255)
    static let mossGreen = Color(red: 100 / 255, green: 135 / 255, blue: 100 / 255)
    static let emerald = Color(red: 70 / 255, green: 180 / 255, blue: 100 / 255)
    static let seafoam = Color(red: 150 / 255, green: 220 / 255, blue: 190 / 255)
    static let coolGray = Color(red: 180 / 255, green: 180 / 255, blue: 180 / 255)
}
