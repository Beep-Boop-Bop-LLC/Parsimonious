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

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    func makeUIViewController(context: Context) -> MFMailComposeViewController {
        let mail = MFMailComposeViewController()
        mail.mailComposeDelegate = context.coordinator
        mail.setSubject("Parsimonious")
        mail.setMessageBody(emailBody(), isHTML: false)
        mail.addAttachmentData(csvData(), mimeType: "text/csv", fileName: "\(currentMonthAndYear()).csv")
        return mail
    }

    func updateUIViewController(_ uiViewController: MFMailComposeViewController, context: Context) {
    }

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
        let calendar = Calendar.current
        let month = calendar.component(.month, from: Date())
        let year = calendar.component(.year, from: Date())
        let fileName = "\(month)-\(year)"
        
        var csvString = "Date,Description,Category,Amount\n"

        for receipt in receipts {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            let dateString = dateFormatter.string(from: receipt.date)
            let amountString = String(format: "%.2f", receipt.amount)
            csvString += "\(dateString),\(receipt.description),\(receipt.category),\(amountString)\n"
        }

        return Data(csvString.utf8)
    }

    private func currentMonthAndYear() -> String {
        let calendar = Calendar.current
        let month = calendar.component(.month, from: Date())
        let year = calendar.component(.year, from: Date())
        return "\(month)-\(year)"
    }

    class Coordinator: NSObject, MFMailComposeViewControllerDelegate {
        var parent: MailView

        init(_ parent: MailView) {
            self.parent = parent
        }

        func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
            if error != nil {
                parent.result = .failure(error!)
            } else {
                parent.result = .success(result)
            }
            parent.isShowingMailView = false
        }
    }
}
