import SwiftUI
import Vision
import UIKit

// MARK: - Image Picker
struct ImagePicker: UIViewControllerRepresentable {
    let sourceType: UIImagePickerController.SourceType
    let completion: (UIImage) -> Void
    @EnvironmentObject var apiKeyStore: APIKeyStore
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

// MARK: - OCR + Gemini pipeline
func analyze(image: UIImage,
             apiKey: String,
             controller: ReceiptController,
             completion: @escaping (Receipt?) -> Void) {
    let request = VNRecognizeTextRequest { request, _ in
        if let observations = request.results as? [VNRecognizedTextObservation] {
            let text = observations.compactMap {
                $0.topCandidates(1).first?.string
            }.joined(separator: "\n")
            
            if !text.isEmpty {
                sendToGemini(ocrText: text, apiKey: apiKey, controller: controller, completion: completion)
            } else {
                completion(nil)
            }
        }
    }
    request.recognitionLevel = .accurate
    request.usesLanguageCorrection = true
    
    guard let cgImage = image.cgImage else { return }
    let handler = VNImageRequestHandler(cgImage: cgImage)
    try? handler.perform([request])
}

private func sendToGemini(ocrText: String,
                          apiKey: String,
                          controller: ReceiptController,
                          completion: @escaping (Receipt?) -> Void) {
    guard let url = URL(string: "https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-flash:generateContent?key=\(apiKey)") else {
        completion(nil); return
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
    Using context from the OCR create a concise <3 word title in the description field.
    OCR text:
    \(ocrText)
    """
    
    let body: [String: Any] = [
        "contents": [["parts": [["text": prompt]]]],
        "generationConfig": ["responseMimeType": "application/json"]
    ]
    
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
    request.httpBody = try? JSONSerialization.data(withJSONObject: body)
    
    URLSession.shared.dataTask(with: request) { data, _, _ in
        guard let data = data,
              let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
              let candidates = json["candidates"] as? [[String: Any]],
              let content = candidates.first?["content"] as? [String: Any],
              let parts = content["parts"] as? [[String: Any]],
              let rawText = parts.first?["text"] as? String else {
            completion(nil); return
        }
        
        let cleaned = extractJSON(from: rawText)
        if let receipt = try? JSONDecoder().decode(Receipt.self, from: Data(cleaned.utf8)) {
            completion(receipt)
        } else {
            completion(nil)
        }
    }.resume()
}

// MARK: - JSON Helper
private func extractJSON(from text: String) -> String {
    if let start = text.firstIndex(of: "{"),
       let end = text.lastIndex(of: "}") {
        return String(text[start...end])
    }
    return text
}
