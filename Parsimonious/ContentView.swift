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
    @EnvironmentObject var receiptController: ReceiptController
    
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
            
            
            NavigationStack {
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
            preloadReceiptsFromCSV()
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

extension ContentView {
    func preloadReceiptsFromCSV() {
        guard let path = Bundle.main.path(forResource: "receipts_all", ofType: "csv") else {
            print("⚠️ receipts_all.csv not found in bundle")
            return
        }
        
        do {
            let csvString = try String(contentsOfFile: path)
            let rows = csvString.components(separatedBy: "\n").dropFirst() // drop header row
            
            var newReceipts: [Receipt] = []
            let existingIDs = Set(receiptController.receipts.map { $0.id })
            
            for row in rows {
                let cols = row.components(separatedBy: ",")
                guard cols.count >= 6 else { continue } // UUID,Date,Description,Category,Amount,Note
                
                let id = UUID(uuidString: cols[0]) ?? UUID()
                guard !existingIDs.contains(id) else { continue } // skip duplicates
                
                let dateParts = cols[1].split(separator: "-")
                guard dateParts.count == 3,
                      let year = Int(dateParts[0]),
                      let month = Int(dateParts[1]),
                      let day = Int(dateParts[2]) else { continue }
                let receiptDate = ReceiptDate(year, month, day)
                
                let description = cols[2]
                let category = cols[3]
                let amount = Double(cols[4]) ?? 0.0
                let note = cols.count > 5 ? cols[5] : nil
                
                let receipt = Receipt(
                    id: id,
                    date: receiptDate,
                    description: description,
                    note: note?.isEmpty == true ? nil : note,
                    category: category,
                    amount: amount
                )
                newReceipts.append(receipt)
            }
            
            // Append instead of replace
            let beforeCount = receiptController.receipts.count
            receiptController.receipts.append(contentsOf: newReceipts)
            
            print("✅ Appended \(newReceipts.count) new receipts (now \(receiptController.receipts.count) total, was \(beforeCount))")
            
        } catch {
            print("❌ Error loading receipts_all.csv: \(error.localizedDescription)")
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
