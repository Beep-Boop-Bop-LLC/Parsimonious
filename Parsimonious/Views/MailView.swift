//
//  MailView.swift
//  Parsimonious
//
//  Created by Zach Venanzi on 12/1/24.
//

import SwiftUI
import MessageUI

struct MailView: View {
    
    @State private var showMailComposer = false
    @State private var mailError: MailError?
    @EnvironmentObject var receiptController: ReceiptController // Access receipts

    var body: some View {
        VStack {
            Spacer()
            
            Button(action: {
                // Open the mail composer
                if MFMailComposeViewController.canSendMail() {
                    showMailComposer = true
                } else {
                    mailError = .cannotSendMail
                }
            }) {
                HStack {
                    Spacer()
                    Image(systemName: "envelope") // SF Symbol for mail icon
                        .font(.system(size: 24))
                    Spacer()
                }
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color.lightBeige.opacity(0.4))
            .foregroundColor(.darkGreen)
            .cornerRadius(8)
            .padding(.horizontal)
            .shadow(color: .black.opacity(0.2), radius: 5, x: 2, y: 2)
            .sheet(isPresented: $showMailComposer) {
                MailComposeView(
                    isPresented: $showMailComposer,
                    resultHandler: { result in
                        switch result {
                        case .sent: print("Email sent successfully!")
                        case .failed: mailError = .failedToSend
                        case .saved: print("Email draft saved.")
                        case .cancelled: print("Email sending cancelled.")
                        @unknown default: break
                        }
                    }
                )
            }
            .alert(item: $mailError) { error in
                Alert(title: Text("Error"), message: Text(error.message), dismissButton: .default(Text("OK")))
            }
            
            Spacer()
        }
    }
}

// Helper Enum for Mail Errors
enum MailError: Identifiable {
    case cannotSendMail
    case failedToSend

    var id: String { UUID().uuidString }

    var message: String {
        switch self {
        case .cannotSendMail: return "Mail services are not available. Please configure your email account."
        case .failedToSend: return "Failed to send the email. Please try again."
        }
    }
}

// Representable for MFMailComposeViewController
struct MailComposeView: UIViewControllerRepresentable {
    @Binding var isPresented: Bool
    @EnvironmentObject var receiptController: ReceiptController // Access receipts

    var resultHandler: ((MFMailComposeResult) -> Void)?

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    func makeUIViewController(context: Context) -> MFMailComposeViewController {
        let mailComposeVC = MFMailComposeViewController()
        mailComposeVC.mailComposeDelegate = context.coordinator
        
        // Set email fields
        mailComposeVC.setSubject("Exported Receipts")
        mailComposeVC.setToRecipients(["example@example.com"])
        mailComposeVC.setMessageBody("Please find attached the exported receipts in CSV format.", isHTML: false)
        
        // Generate CSV data
        let csvData = generateCSV()
        
        // Attach CSV file
        mailComposeVC.addAttachmentData(csvData, mimeType: "text/csv", fileName: "receipts.csv")
        
        return mailComposeVC
    }

    func generateCSV() -> Data {
        var csvString = ""
        for receipt in receiptController.receipts {
            let date = "\(receipt.date.year)-\(receipt.date.month)-\(receipt.date.day)"
            let note = receipt.note ?? ""
            csvString += "\(date),\(receipt.description),\(receipt.category),\(receipt.amount),\(note)\n"
        }
        return Data(csvString.utf8)
    }

    func updateUIViewController(_ uiViewController: MFMailComposeViewController, context: Context) {}

    class Coordinator: NSObject, MFMailComposeViewControllerDelegate {
        let parent: MailComposeView

        init(_ parent: MailComposeView) {
            self.parent = parent
        }

        func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
            parent.resultHandler?(result)
            parent.isPresented = false
        }
    }
}
