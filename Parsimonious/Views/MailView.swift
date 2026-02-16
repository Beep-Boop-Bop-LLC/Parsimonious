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

        mailComposeVC.addAttachmentData(csvFiles.history,
                                        mimeType: "text/csv",
                                        fileName: "receipts_all.csv")

        mailComposeVC.addAttachmentData(csvFiles.yearToDate,
                                        mimeType: "text/csv",
                                        fileName: "receipts_YTD.csv")

        mailComposeVC.addAttachmentData(csvFiles.currentMonth,
                                        mimeType: "text/csv",
                                        fileName: "receipts_month.csv")

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
        
        let yearToDateReceipts = receipts.filter {
            $0.date.year == currentYear
        }

        // Calculate statistics
        let totalReceipts = currentMonthReceipts.count
        let totalAmount = currentMonthReceipts.reduce(0) { $0 + $1.amount }
        let ytdTotal = yearToDateReceipts.reduce(0) { $0 + $1.amount }
        let ytdReceiptCount = yearToDateReceipts.count
        
        // Calculate average per receipt
        let averagePerReceipt = totalReceipts > 0 ? totalAmount / Double(totalReceipts) : 0.0
        
        // Group by category and calculate totals
        var categoryTotals: [String: (count: Int, amount: Double)] = [:]
        for receipt in currentMonthReceipts {
            let existing = categoryTotals[receipt.category] ?? (count: 0, amount: 0.0)
            categoryTotals[receipt.category] = (count: existing.count + 1, amount: existing.amount + receipt.amount)
        }
        
        // Sort categories by amount (highest first)
        let sortedCategories = categoryTotals.sorted { $0.value.amount > $1.value.amount }
        
        // Build category breakdown HTML
        var categoryRowsHTML = ""
        for (category, data) in sortedCategories {
            let percentage = totalAmount > 0 ? (data.amount / totalAmount) * 100 : 0
            categoryRowsHTML += """
                <tr>
                    <td style="padding: 12px; border-bottom: 1px solid #e0e0e0;">
                        <strong style="color: #2c5f2d;">\(category)</strong>
                    </td>
                    <td style="padding: 12px; border-bottom: 1px solid #e0e0e0; text-align: center;">
                        \(data.count)
                    </td>
                    <td style="padding: 12px; border-bottom: 1px solid #e0e0e0; text-align: right;">
                        <strong>$\(String(format: "%.2f", data.amount))</strong>
                    </td>
                    <td style="padding: 12px; border-bottom: 1px solid #e0e0e0; text-align: right;">
                        <span style="background: #e8f5e9; padding: 4px 8px; border-radius: 4px; font-size: 12px;">
                            \(String(format: "%.1f", percentage))%
                        </span>
                    </td>
                </tr>
            """
        }

        // Email subject
        let subject = "📊 Your Parsimonious Report – \(currentMonthYear)"

        // Email body with professional styling
        let body = """
        <!DOCTYPE html>
        <html>
        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
        </head>
        <body style="margin: 0; padding: 0; font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, 'Helvetica Neue', Arial, sans-serif; background-color: #f5f5f5;">
            <table width="100%" cellpadding="0" cellspacing="0" style="background-color: #f5f5f5; padding: 20px;">
                <tr>
                    <td align="center">
                        <table width="600" cellpadding="0" cellspacing="0" style="background-color: #ffffff; border-radius: 12px; box-shadow: 0 4px 12px rgba(0,0,0,0.1); overflow: hidden;">
                            
                            <!-- Header -->
                            <tr>
                                <td style="background: linear-gradient(135deg, #2c5f2d 0%, #97c4a0 100%); padding: 40px 30px; text-align: center;">
                                    <h1 style="margin: 0; color: #ffffff; font-size: 28px; font-weight: 700;">
                                        📊 Parsimonious
                                    </h1>
                                    <p style="margin: 10px 0 0 0; color: #e8f5e9; font-size: 16px;">
                                        Your Financial Snapshot
                                    </p>
                                </td>
                            </tr>
                            
                            <!-- Main Content -->
                            <tr>
                                <td style="padding: 30px;">
                                    <h2 style="color: #2c5f2d; font-size: 22px; margin: 0 0 20px 0;">
                                        Hello! 👋
                                    </h2>
                                    <p style="color: #555555; font-size: 16px; line-height: 1.6; margin: 0 0 25px 0;">
                                        Here's your receipt summary for <strong>\(currentMonthYear)</strong>. We've attached three CSV files containing your complete transaction history.
                                    </p>
                                    
                                    <!-- Key Metrics Cards -->
                                    <table width="100%" cellpadding="0" cellspacing="0" style="margin-bottom: 30px;">
                                        <tr>
                                            <td width="48%" style="background: #e8f5e9; border-radius: 8px; padding: 20px; vertical-align: top;">
                                                <div style="font-size: 14px; color: #2c5f2d; margin-bottom: 8px; font-weight: 600;">
                                                    💰 THIS MONTH
                                                </div>
                                                <div style="font-size: 32px; font-weight: 700; color: #2c5f2d; margin-bottom: 5px;">
                                                    $\(String(format: "%.2f", totalAmount))
                                                </div>
                                                <div style="font-size: 14px; color: #666666;">
                                                    \(totalReceipts) receipt\(totalReceipts != 1 ? "s" : "")
                                                </div>
                                            </td>
                                            <td width="4%"></td>
                                            <td width="48%" style="background: #fff3e0; border-radius: 8px; padding: 20px; vertical-align: top;">
                                                <div style="font-size: 14px; color: #f57c00; margin-bottom: 8px; font-weight: 600;">
                                                    📅 YEAR TO DATE
                                                </div>
                                                <div style="font-size: 32px; font-weight: 700; color: #f57c00; margin-bottom: 5px;">
                                                    $\(String(format: "%.2f", ytdTotal))
                                                </div>
                                                <div style="font-size: 14px; color: #666666;">
                                                    \(ytdReceiptCount) receipt\(ytdReceiptCount != 1 ? "s" : "")
                                                </div>
                                            </td>
                                        </tr>
                                    </table>
                                    
                                    <!-- Quick Stats -->
                                    <table width="100%" cellpadding="0" cellspacing="0" style="margin-bottom: 30px; background: #f9f9f9; border-radius: 8px; padding: 15px;">
                                        <tr>
                                            <td width="33%" style="text-align: center; padding: 10px; border-right: 1px solid #e0e0e0;">
                                                <div style="font-size: 24px; font-weight: 700; color: #2c5f2d;">
                                                    $\(String(format: "%.2f", averagePerReceipt))
                                                </div>
                                                <div style="font-size: 12px; color: #666666; margin-top: 5px;">
                                                    Avg per Receipt
                                                </div>
                                            </td>
                                            <td width="33%" style="text-align: center; padding: 10px; border-right: 1px solid #e0e0e0;">
                                                <div style="font-size: 24px; font-weight: 700; color: #2c5f2d;">
                                                    \(categoryTotals.count)
                                                </div>
                                                <div style="font-size: 12px; color: #666666; margin-top: 5px;">
                                                    Categories
                                                </div>
                                            </td>
                                            <td width="34%" style="text-align: center; padding: 10px;">
                                                <div style="font-size: 24px; font-weight: 700; color: #2c5f2d;">
                                                    \(currentMonth)/\(currentYear)
                                                </div>
                                                <div style="font-size: 12px; color: #666666; margin-top: 5px;">
                                                    Period
                                                </div>
                                            </td>
                                        </tr>
                                    </table>
                                    
                                    <!-- Category Breakdown -->
                                    <h3 style="color: #2c5f2d; font-size: 18px; margin: 0 0 15px 0;">
                                        📂 Spending by Category
                                    </h3>
                                    <table width="100%" cellpadding="0" cellspacing="0" style="border-collapse: collapse; border-radius: 8px; overflow: hidden; border: 1px solid #e0e0e0; margin-bottom: 30px;">
                                        <thead>
                                            <tr style="background: #f5f5f5;">
                                                <th style="padding: 12px; text-align: left; font-size: 14px; color: #666666; border-bottom: 2px solid #e0e0e0;">
                                                    Category
                                                </th>
                                                <th style="padding: 12px; text-align: center; font-size: 14px; color: #666666; border-bottom: 2px solid #e0e0e0;">
                                                    Count
                                                </th>
                                                <th style="padding: 12px; text-align: right; font-size: 14px; color: #666666; border-bottom: 2px solid #e0e0e0;">
                                                    Total
                                                </th>
                                                <th style="padding: 12px; text-align: right; font-size: 14px; color: #666666; border-bottom: 2px solid #e0e0e0;">
                                                    % of Total
                                                </th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            \(categoryRowsHTML)
                                        </tbody>
                                        <tfoot>
                                            <tr style="background: #f5f5f5; font-weight: 700;">
                                                <td style="padding: 12px; border-top: 2px solid #2c5f2d;">
                                                    TOTAL
                                                </td>
                                                <td style="padding: 12px; text-align: center; border-top: 2px solid #2c5f2d;">
                                                    \(totalReceipts)
                                                </td>
                                                <td style="padding: 12px; text-align: right; border-top: 2px solid #2c5f2d;">
                                                    $\(String(format: "%.2f", totalAmount))
                                                </td>
                                                <td style="padding: 12px; text-align: right; border-top: 2px solid #2c5f2d;">
                                                    100%
                                                </td>
                                            </tr>
                                        </tfoot>
                                    </table>
                                    
                                    <!-- Attachments Info -->
                                    <div style="background: #e3f2fd; border-left: 4px solid #2196F3; padding: 15px; border-radius: 4px; margin-bottom: 25px;">
                                        <div style="font-size: 14px; font-weight: 600; color: #1976D2; margin-bottom: 8px;">
                                            📎 Attached Files
                                        </div>
                                        <div style="font-size: 14px; color: #555555; line-height: 1.6;">
                                            • <strong>receipts_all.csv</strong> – Complete transaction history<br>
                                            • <strong>receipts_YTD.csv</strong> – Year-to-date transactions<br>
                                            • <strong>receipts_month.csv</strong> – Current month only
                                        </div>
                                    </div>
                                    
                                    <p style="color: #555555; font-size: 14px; line-height: 1.6; margin: 0;">
                                        Keep up the great work tracking your expenses! 🎯
                                    </p>
                                </td>
                            </tr>
                            
                            <!-- Footer -->
                            <tr>
                                <td style="background: #f5f5f5; padding: 25px 30px; border-top: 1px solid #e0e0e0;">
                                    <p style="margin: 0 0 10px 0; font-size: 14px; font-weight: 600; color: #2c5f2d;">
                                        Best regards,<br>
                                        The Parsimonious Team
                                    </p>
                                    <p style="margin: 0; font-size: 12px; color: #999999; line-height: 1.5;">
                                        This email was generated automatically by the Parsimonious app.<br>
                                        Questions? Visit our support page or contact us within the app.
                                    </p>
                                </td>
                            </tr>
                            
                        </table>
                    </td>
                </tr>
            </table>
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

    func generateCSV() -> (history: Data, yearToDate: Data, currentMonth: Data) {
        let calendar = Calendar.current
        let now = Date()
        let currentYear = calendar.component(.year, from: now)
        let currentMonth = calendar.component(.month, from: now)

        // Filter receipts for history (all receipts)
        let historyReceipts = receiptController.receipts

        // Filter receipts for YTD
        let yearToDateReceipts = receiptController.receipts.filter {
            $0.date.year == currentYear
        }

        // Filter receipts for the current month
        let currentMonthReceipts = receiptController.receipts.filter {
            $0.date.year == currentYear && $0.date.month == currentMonth
        }

        // Generate CSV strings
        let historyCSVString = generateCSVString(for: historyReceipts)
        let ytdCSVString = generateCSVString(for: yearToDateReceipts)
        let currentMonthCSVString = generateCSVString(for: currentMonthReceipts)

        // Convert strings to Data
        return (
            Data(historyCSVString.utf8),
            Data(ytdCSVString.utf8),
            Data(currentMonthCSVString.utf8)
        )
    }

    // Helper function to generate CSV string for a given list of receipts
    func generateCSVString(for receipts: [Receipt]) -> String {
        var csvString = "UUID,Date,Description,Category,Amount,Note\n" // Add headers
        for receipt in receipts {
            let date = "\(receipt.date.year)-\(String(format: "%02d", receipt.date.month))-\(String(format: "%02d", receipt.date.day))"
            let note = receipt.note?.replacingOccurrences(of: ",", with: ";") ?? ""
            csvString += "\(receipt.id.uuidString),\(date),\(receipt.description),\(receipt.category),\(receipt.amount),\(note)\n"
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
