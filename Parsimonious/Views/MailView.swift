//
//  MailView.swift
//  Parsimonious
//
//  Created by Zach Venanzi on 8/27/24.
//
import SwiftUI
import MessageUI

struct MailView: UIViewControllerRepresentable {
    @Binding var result: Result<MFMailComposeResult, Error>?
    @Binding var isShowingMailView: Bool
    var receipts: [Receipt]
    var circleGraphView: CircleGraphView // Include CircleGraphView as a property

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    func makeUIViewController(context: Context) -> MFMailComposeViewController {
        let mail = MFMailComposeViewController()
        mail.mailComposeDelegate = context.coordinator
        mail.setSubject("Parsimonious")
        mail.setMessageBody(emailBody(), isHTML: false)
        
        // Attach the CSV data
        mail.addAttachmentData(csvData(), mimeType: "text/csv", fileName: "\(currentMonthAndYear()).csv")
        
        // Render CircleGraphView to image and attach it
        if let imageData = renderCircleGraphViewAsImage() {
            mail.addAttachmentData(imageData, mimeType: "image/png", fileName: "CircleGraph.png")
        }

        return mail
    }

    func updateUIViewController(_ uiViewController: MFMailComposeViewController, context: Context) {}

    private func emailBody() -> String {
        let totalMonth = receipts.reduce(0) { $0 + $1.amount }
        let categories = Dictionary(grouping: receipts, by: { $0.category })
        let categoryTotals = categories.map { (category, receipts) in
            let total = receipts.reduce(0) { $0 + $1.amount }
            return "\(category): $\(total)"
        }.joined(separator: "\n")

        return "Total for the month: $\(totalMonth)\n\nCategory totals:\n\n\(categoryTotals)\n\nParsimonious Team"
    }

    private func csvData() -> Data {
        var csvString = "Date,Description,Category,Amount\n"
        for receipt in receipts {
            if let date = receipt.date.toDate() {
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd"
                let dateString = dateFormatter.string(from: date)
                let amountString = String(format: "%.2f", receipt.amount)
                csvString += "\(dateString),\(receipt.description),\(receipt.category),\(amountString)\n"
            }
        }
        print("Generated CSV: \(csvString)") // Debugging line
        return Data(csvString.utf8)
    }

    private func currentMonthAndYear() -> String {
        let calendar = Calendar.current
        let month = calendar.component(.month, from: Date())
        let year = calendar.component(.year, from: Date())
        return "\(month)-\(year)"
    }

    // New function to render CircleGraphView as UIImage
    private func renderCircleGraphViewAsImage() -> Data? {
        let controller = UIHostingController(rootView: circleGraphView)
        let view = controller.view
        
        // Set the preferred size for the view
        let size = CGSize(width: 300, height: 300) // Adjust size as needed
        view?.bounds = CGRect(origin: .zero, size: size)
        view?.backgroundColor = .clear
        
        // Render the view to an image
        let renderer = UIGraphicsImageRenderer(size: size)
        return renderer.pngData { context in
            view?.layer.render(in: context.cgContext)
        }
    }

    class Coordinator: NSObject, MFMailComposeViewControllerDelegate {
        var parent: MailView

        init(_ parent: MailView) {
            self.parent = parent
        }

        func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
            if let error = error {
                print("Mail error: \(error.localizedDescription)") // Debugging line
                parent.result = .failure(error)
            } else {
                print("Mail result: \(result)") // Debugging line
                parent.result = .success(result)
            }
            parent.isShowingMailView = false
        }
    }
}

struct SendEmailButton: View {
    @State private var result: Result<MFMailComposeResult, Error>?
    @State private var isShowingMailView = false
    @ObservedObject var receiptController: ReceiptController
    @Binding var selectedCategory: Set<String> // Change to Binding<Set<String>>

    var body: some View {
        HStack {
            Spacer()
            Button(action: {
                guard MFMailComposeViewController.canSendMail() else {
                    print("Mail services are not available.")
                    return
                }
                print("SendEmailButton clicked") // Print statement for debugging
                isShowingMailView = true
            }) {
                Text("✉️") // Using a text symbol for the envelope
                    .font(.system(size: 100)) // Increased font size for visibility
                    .foregroundColor(.lightBeige)
                    .padding(40) // Increased padding for a bigger touch target
                    .background(Color.red.opacity(0.5)) // Temporary for debugging
                    .cornerRadius(20) // Optional: Round corners for better appearance
                    .shadow(radius: 5)
                    .frame(width: 300, height: 300) // Set a larger frame size
            }
            .sheet(isPresented: $isShowingMailView) {
                MailView(result: $result, isShowingMailView: $isShowingMailView, receipts: actualReceipts(), circleGraphView: CircleGraphView(receiptController: receiptController, selectedCategories: selectedCategory))
            }
            Spacer()
        }
    }

    private func actualReceipts() -> [Receipt] {
        let filteredReceipts = receiptController.receipts.filter { !$0.description.starts(with: "Debug") }
        print("Filtered Receipts: \(filteredReceipts)") // Debugging line
        return filteredReceipts
    }
}
