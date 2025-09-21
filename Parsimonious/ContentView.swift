//
//  ContentView.swift
//  Parsimonious
//
//  Created by Nick Venanzi on 9/28/24.
//

import SwiftUI
import Firebase
import FirebaseAuth
import FirebaseFirestore

struct ContentView: View {
    @State private var selectedIndex: Int = 0

    var body: some View {
        TabView(selection: $selectedIndex) {
            
//            OCRReceiptView()
//                .tabItem {
//                    Label("Camera", systemImage: "camera.fill")
//                }
//                .tag(0)
//            
            CreateReceiptView(completion: { selectedIndex = 1 })
                .tabItem {
                    Label("Entry", systemImage: "rectangle.and.pencil.and.ellipsis")
                }
                .tag(0)
            
            NavigationView {
                GraphsView()
            }
            .tabItem {
                Label("Summary", systemImage: "chart.pie")
            }
            .tag(1)
        }
        .accentColor(.darkGreen)
        .preferredColorScheme(.dark)
        .onAppear {
            signInAndFetchAPIKey()
        }
    }

    private func signInAndFetchAPIKey() {
        if Auth.auth().currentUser == nil {
            Auth.auth().signInAnonymously { result, error in
                if let error = error {
                    print("❌ Sign-in failed: \(error.localizedDescription)")
                } else {
                    print("✅ Signed in anonymously as \(result?.user.uid ?? "unknown")")
                    fetchAPIKey()
                }
            }
        } else {
            fetchAPIKey()
        }
    }

    private func fetchAPIKey() {
        let db = Firestore.firestore()
        db.collection("config").document("apiKey").getDocument { document, error in
            if let error = error {
                print("❌ Error fetching API key: \(error.localizedDescription)")
                return
            }
            if let data = document?.data(), let key = data["key"] as? String {
                DispatchQueue.main.async {
                    APIKeyStore.shared.apiKey = key   // ✅ set globally
                }
                print("✅ Fetched API Key: \(key)")
            } else {
                print("⚠️ No API key found in Firestore")
            }
        }
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
