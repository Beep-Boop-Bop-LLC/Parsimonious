//
//  APIKeyManager.swift
//  Parsimonious
//
//  Created by Zach Venanzi on 9/13/25.
//


import FirebaseFirestore
import FirebaseAuth

class APIKeyManager {
    static let shared = APIKeyManager()
    
    private(set) var apiKey: String?   // read-only outside
    
    private init() { }
    
    func loadAPIKey() {
        if Auth.auth().currentUser == nil {
            Auth.auth().signInAnonymously { result, error in
                if let error = error {
                    print("Sign-in failed: \(error.localizedDescription)")
                } else {
                    self.fetchKey()
                }
            }
        } else {
            fetchKey()
        }
    }
    
    private func fetchKey() {
        let db = Firestore.firestore()
        db.collection("config").document("apiKey").getDocument { document, error in
            if let error = error {
                print("Error fetching API key: \(error)")
                return
            }
            if let data = document?.data(), let key = data["key"] as? String {
                self.apiKey = key
                print("Fetched API Key: \(key)")
            } else {
                print("No API key found in Firestore")
            }
        }
    }
}
