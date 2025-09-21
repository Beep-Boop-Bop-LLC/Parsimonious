//
//  APIKeyStore.swift
//  Parsimonious
//
//  Created by Zach Venanzi on 9/13/25.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

class APIKeyStore: ObservableObject {
    static let shared = APIKeyStore()   // singleton if needed outside SwiftUI
    @Published var apiKey: String? = nil
}

