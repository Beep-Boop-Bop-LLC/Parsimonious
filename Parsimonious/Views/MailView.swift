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
    
    func getUserEmail() -> String {
        // Retrieve saved email or return an empty string
        return UserDefaults.standard.string(forKey: "userEmail") ?? ""
    }

    func saveUserEmail(_ email: String) {
        UserDefaults.standard.set(email, forKey: "userEmail")
    }

    

    @EnvironmentObject var controller: ReceiptController

    func makeUIViewController(context: Context) -> MFMailComposeViewController {
        let mailComposeVC = MFMailComposeViewController()
        mailComposeVC.mailComposeDelegate = context.coordinator

        // Generate the email subject and body
        let (subject, body) = createEmailBody(receipts: controller.receipts)

        let userEmail = getUserEmail()
        
        let formatter = DateFormatter()
            formatter.dateFormat = "MMMM yyyy" // e.g., "December 2023"
        let currentMonthYear = formatter.string(from: Date())


        if userEmail.isEmpty {
            // Prompt user to enter their email (this should happen in your app's UI)
            // After entering, call `saveUserEmail(newEmail)` to store it.
        } else {
            mailComposeVC.setToRecipients([userEmail])
        }

        // Set email fields
        mailComposeVC.setSubject(subject)
        mailComposeVC.setMessageBody(body, isHTML: true)

        // Generate CSV data
        let csvFiles = generateCSV()

        mailComposeVC.addAttachmentData(csvFiles.yearToDate, mimeType: "text/csv", fileName: "receipts_YTD.csv")
        mailComposeVC.addAttachmentData(csvFiles.currentMonth, mimeType: "text/csv", fileName: "receipts \(currentMonthYear).csv")

        return mailComposeVC
    }
    
    // Helper to filter receipts for the current month
    func filterReceiptsForCurrentMonth(_ receipts: [Receipt]) -> [Receipt] {
        let calendar = Calendar.current
        let now = Date()
        let currentMonth = calendar.component(.month, from: now)
        let currentYear = calendar.component(.year, from: now)

        return receipts.filter {
            $0.date.year == currentYear && $0.date.month == currentMonth
        }
    }

    func createEmailBody(receipts: [Receipt]) -> (subject: String, body: String) {
        // Helper to get the current month and year
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        let currentMonthYear = formatter.string(from: Date())

        // Filter receipts for the current month
        let calendar = Calendar.current
        let now = Date()
        let currentMonth = calendar.component(.month, from: now)
        let currentYear = calendar.component(.year, from: now)

        let currentMonthReceipts = receipts.filter {
            $0.date.year == currentYear && $0.date.month == currentMonth
        }

        // Total number of receipts
        let totalReceipts = currentMonthReceipts.count

        // Total amount from receipts
        let totalAmount = currentMonthReceipts.reduce(0) { $0 + $1.amount }

        // Summary of categories
        let categoriesSummary = Array(Set(currentMonthReceipts.map { $0.category })).joined(separator: ", ")

        // Email subject
        let subject = "Parsimonious Receipts \(currentMonthYear)"

        // Email body
        let body = """
        <html>
        <body>
            <h2 style="color: #4CAF50;">Parsimonious User,</h2>
            <p>We've attached your exported receipts in CSV format for your records.</p>
            <p><strong>Summary of Receipts \(currentMonthYear):</strong></p>
            <ul>
                <li><strong>Total Receipts:</strong> \(totalReceipts)</li>
                <li><strong>Total Amount:</strong> $\(String(format: "%.2f", totalAmount))</li>
                <li><strong>Categories:</strong> \(categoriesSummary)</li>
            </ul>
            <br>
            <p>Best regards,</p>
            <p><strong>The Parsimonious Team</strong></p>
            <hr>
            <small style="color: gray;">This email was generated by the Parsimonious app. Please do not reply directly to this email.</small>
        </body>
        </html>
        """

        return (subject, body)
    }

    // Helper function to generate the current date string for the filename
    func currentDateString() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: Date())
    }

    func generateCSV() -> (yearToDate: Data, currentMonth: Data) {
        let calendar = Calendar.current
        let now = Date()
        let currentYear = calendar.component(.year, from: now)
        let currentMonth = calendar.component(.month, from: now)

        // Filter receipts for YTD
        let yearToDateReceipts = receiptController.receipts.filter {
            $0.date.year == currentYear
        }

        // Filter receipts for the current month
        let currentMonthReceipts = receiptController.receipts.filter {
            $0.date.year == currentYear && $0.date.month == currentMonth
        }

        // Generate CSV strings
        let ytdCSVString = generateCSVString(for: yearToDateReceipts)
        let currentMonthCSVString = generateCSVString(for: currentMonthReceipts)

        // Convert strings to Data
        return (Data(ytdCSVString.utf8), Data(currentMonthCSVString.utf8))
    }

    // Helper function to generate CSV string for a given list of receipts
    func generateCSVString(for receipts: [Receipt]) -> String {
        var csvString = "Date,Description,Category,Amount,Note\n" // Add headers
        for receipt in receipts {
            let date = "\(receipt.date.year)-\(String(format: "%02d", receipt.date.month))-\(String(format: "%02d", receipt.date.day))"
            let note = receipt.note ?? ""
            csvString += "\(date),\(receipt.description),\(receipt.category),\(receipt.amount),\(note)\n"
        }
        return csvString
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
