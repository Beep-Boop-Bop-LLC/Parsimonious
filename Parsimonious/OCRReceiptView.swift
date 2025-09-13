//
//  OCRReceiptView.swift
//  Parsimonious
//
//  Created by Zach Venanzi on 9/13/25.
//

import SwiftUI
import Vision
import UIKit

struct OCRReceiptView: View {
    @EnvironmentObject var controller: ReceiptController
    
    @State private var pickedImage: UIImage?
    @State private var classification: String = "Pick or take a picture to start"
    @State private var showPhotoPicker = false
    @State private var showCameraPicker = false
    
    // Replace with your actual Gemini API key
    private let apiKey = "AIzaSyB9j6h_0kKvnCBLsxYfW-k2IMmkum4nzhU"
    
    var body: some View {
        ZStack {
            Image("Parsimonious")
                .resizable()
                .scaledToFill()
                .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
                .position(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height / 2)
                .opacity(0.04)
                .ignoresSafeArea()
            
            LinearGradient(
                gradient: Gradient(colors: [Color.midGreen.opacity(0.2), Color.midGreen.opacity(0.8)]),
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea(edges: .all)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            VStack(spacing: 20) {
                
                ParsimoniousHeaderView()

                if let image = pickedImage {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFit()
                        .frame(maxHeight: 200)
                        .clipShape(RoundedRectangle(cornerRadius: 22))
                        .padding(.horizontal)
                } else {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.gray.opacity(0.3))
                        .frame(height: 200)
                        .overlay(
                            Text("No Image Selected")
                                .foregroundColor(.secondary)
                        )
                        .padding(.horizontal)
                }
                
                HStack {
                    Button("Pick Image") { showPhotoPicker = true }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.white.opacity(0.2))
                        .cornerRadius(8)
                        .contentShape(Rectangle())
                    
                    Button("Take Photo") {
                        if UIImagePickerController.isSourceTypeAvailable(.camera) {
                            showCameraPicker = true
                        } else {
                            classification = "Camera not available"
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.white.opacity(0.3))
                    .cornerRadius(8)
                }
                .padding(.horizontal)
                
                Button(action: {
                    if let img = pickedImage {
                        analyze(image: img)
                    } else {
                        classification = "No image selected"
                    }
                }) {
                    Text("Analyze Image")
                        .font(.system(size: 20, weight: .semibold))
                        .padding()
                        .foregroundColor(.darkGreen) // or .lightBeige depending on your state
                        .frame(maxWidth: .infinity)
                        .shadow(color: .black.opacity(0.2), radius: 5, x: 2, y: 2)
                }
                .background(Color.white.opacity(0.2))
                .cornerRadius(12)
                .padding(.horizontal)
                
                ScrollView {
                    Text(classification)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding()
                        .background(Color.white.opacity(0.1))
                        .cornerRadius(12)
                }
                .frame(maxHeight: 150)
                .padding(.horizontal)
                
                Spacer()
            }
        }
        .sheet(isPresented: $showPhotoPicker) {
            ImagePicker(sourceType: .photoLibrary) { image in
                pickedImage = image
                classification = "Ready to analyze"
            }
        }
        .sheet(isPresented: $showCameraPicker) {
            ImagePicker(sourceType: .camera) { image in
                pickedImage = image
                classification = "Ready to analyze"
            }
        }
        .background(Color.lightGreen.ignoresSafeArea())
    }
    
    // MARK: - OCR
    private func analyze(image: UIImage) {
        let request = VNRecognizeTextRequest { request, _ in
            if let observations = request.results as? [VNRecognizedTextObservation] {
                let text = observations.compactMap {
                    $0.topCandidates(1).first?.string
                }.joined(separator: "\n")
                
                DispatchQueue.main.async {
                    classification = text.isEmpty ? "No text found" : text
                }
                
                if !text.isEmpty {
                    sendToGemini(ocrText: text)
                }
            }
        }
        request.recognitionLevel = .accurate
        request.usesLanguageCorrection = true
        
        guard let cgImage = image.cgImage else {
            classification = "Invalid image"
            return
        }
        
        let handler = VNImageRequestHandler(cgImage: cgImage)
        try? handler.perform([request])
    }
    
    // MARK: - Step 1: Parse Base Receipt
    private func sendToGemini(ocrText: String) {
        guard let url = URL(string: "https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-flash:generateContent?key=\(apiKey)") else {
            return
        }
        
        let prompt = """
        Extract a structured receipt from the OCR text. 
        Return ONLY valid JSON in this format:        
        {
          "date": { "year": 2025, "month": 9, "day": 13 },
          "description": "string",
          "note": "string or null",
          "category": "string",
          "amount": 12.34
        }
        Using context from the OCR reate a concise <3 word title in the description field.
        OCR text:
        \(ocrText)
        """
        
        let body: [String: Any] = [
            "contents": [
                ["parts": [["text": prompt]]]
            ],
            "generationConfig": [
                "responseMimeType": "application/json"
            ]
        ]
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try? JSONSerialization.data(withJSONObject: body)
        
        URLSession.shared.dataTask(with: request) { data, _, error in
            if let error = error {
                print("Gemini error:", error)
                return
            }
            guard let data = data else { return }
            
            do {
                let json = try JSONSerialization.jsonObject(with: data) as? [String: Any]
                if let candidates = json?["candidates"] as? [[String: Any]],
                   let content = candidates.first?["content"] as? [String: Any],
                   let parts = content["parts"] as? [[String: Any]],
                   let text = parts.first?["text"] as? String {
                    
                    let receipt = try JSONDecoder().decode(Receipt.self, from: Data(text.utf8))
                    print("✅ Base Receipt:", receipt)
                    
                    refineCategory(receipt: receipt, userCategories: Array(controller.categories), apiKey: apiKey) { result in
                        switch result {
                        case .success(let refined):
                            DispatchQueue.main.async {
                                classification = "Saved: \(refined.description) $\(refined.amount)"
                                controller.addReceipt(
                                    amount: refined.amount,
                                    description: refined.description,
                                    note: refined.note,
                                    category: refined.category
                                )
                                let generator = UINotificationFeedbackGenerator()
                                generator.notificationOccurred(.success)
                            }
                        case .failure(let error):
                            print("Refinement error:", error)
                        }
                    }
                    
                } else {
                    print("⚠️ Gemini returned unexpected format:", json ?? [:])
                }
            } catch {
                print("Decoding error:", error)
            }
        }.resume()
    }
    
    // MARK: - Step 2: Refine Category
    func refineCategory(receipt: Receipt, userCategories: [String], apiKey: String, completion: @escaping (Result<Receipt, Error>) -> Void) {
        print("📡 refineCategory called for receipt: \(receipt.description), categories: \(userCategories)")
        
        guard let url = URL(string: "https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-flash-lite:generateContent?key=\(apiKey)") else {
            return
        }
        
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        guard let receiptJSONData = try? encoder.encode(receipt),
              let receiptJSONString = String(data: receiptJSONData, encoding: .utf8) else {
            completion(.failure(NSError(domain: "EncodingError", code: 0)))
            return
        }
        
        let prompt = """
        You are a categorizer.
        Given this receipt JSON:
        
        \(receiptJSONString)
        
        Choose the **closest match** for "category" from this list:
        \(userCategories.joined(separator: ", "))
        
        Return the same JSON with only the "category" field updated.
        """
        
        let body: [String: Any] = [
            "contents": [
                ["parts": [["text": prompt]]]
            ],
            "generationConfig": [
                "responseMimeType": "application/json"
            ]
        ]
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try? JSONSerialization.data(withJSONObject: body)
        
        URLSession.shared.dataTask(with: request) { data, _, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            guard let data = data else { return }
            
            do {
                let json = try JSONSerialization.jsonObject(with: data) as? [String: Any]
                if let candidates = json?["candidates"] as? [[String: Any]],
                   let content = candidates.first?["content"] as? [String: Any],
                   let parts = content["parts"] as? [[String: Any]],
                   let text = parts.first?["text"] as? String {
                    
                    let refined = try JSONDecoder().decode(Receipt.self, from: Data(text.utf8))
                    print("🎯 Gemini refined category:", refined.category)
                    completion(.success(refined))
                } else {
                    throw NSError(domain: "Gemini", code: 0, userInfo: [NSLocalizedDescriptionKey: "Unexpected response"])
                }
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }


    // MARK: - Image Picker
    struct ImagePicker: UIViewControllerRepresentable {
        let sourceType: UIImagePickerController.SourceType
        let completion: (UIImage) -> Void
        
        func makeCoordinator() -> Coordinator {
            Coordinator(completion: completion)
        }
        
        func makeUIViewController(context: Context) -> UIImagePickerController {
            let picker = UIImagePickerController()
            picker.delegate = context.coordinator
            picker.sourceType = sourceType
            return picker
        }
        
        func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
        
        class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
            let completion: (UIImage) -> Void
            init(completion: @escaping (UIImage) -> Void) { self.completion = completion }
            
            func imagePickerController(_ picker: UIImagePickerController,
                                       didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
                if let image = info[.originalImage] as? UIImage {
                    completion(image)
                }
                picker.dismiss(animated: true)
            }
            func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
                picker.dismiss(animated: true)
            }
        }
    }

    // MARK: - Manual Flow
    struct ManualReceiptView: View {
        @State private var amount: String = ""
        @State private var description: String = ""
        @State private var note: String = ""
        
        var body: some View {
            NavigationView {
                Form {
                    Section(header: Text("Details")) {
                        TextField("Amount", text: $amount)
                            .keyboardType(.decimalPad)
                        TextField("Description", text: $description)
                        TextField("Note (optional)", text: $note)
                    }
                    
                    Section {
                        Button("Save Receipt") {
                            let generator = UINotificationFeedbackGenerator()
                            generator.notificationOccurred(.success)
                            resetFields()
                        }
                        .frame(maxWidth: .infinity, alignment: .center)
                    }
                }
                .navigationTitle("Manual Receipt")
            }
        }
        
        private func resetFields() {
            amount = ""
            description = ""
            note = ""
        }
    }
}
