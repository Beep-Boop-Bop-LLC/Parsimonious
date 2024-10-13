import SwiftUI

struct BarGraphView: View {
    @ObservedObject var receiptController: ReceiptController

    var body: some View {
        let categoryExpenditures = aggregateExpenditures()
        let maxExpenditure = categoryExpenditures.map { $0.totalExpenditure }.max() ?? 1
        
        VStack {
            Text("Expenditure by Category")
                .font(.title)
                .padding()

            HStack(spacing: 16) { // Added spacing for better visualization
                ForEach(categoryExpenditures) { category in
                    BarView(category: category, maxExpenditure: maxExpenditure)
                }
            }
            .padding()
        }
    }

    // Aggregate total expenditures by category
    func aggregateExpenditures() -> [CategoryExpenditure] {
        var expenditures: [String: Double] = [:]

        // Sum up the amounts for each category
        for receipt in receiptController.receipts {
            expenditures[receipt.category, default: 0] += receipt.amount
        }

        return expenditures.map { CategoryExpenditure(category: $0.key, totalExpenditure: $0.value) }
    }
}

struct CategoryExpenditure: Identifiable {
    let id = UUID()
    let category: String
    let totalExpenditure: Double
}

struct BarView: View {
    var category: CategoryExpenditure
    var maxExpenditure: Double

    var body: some View {
        // Calculate the bar height separately for clarity
        let normalizedHeight: CGFloat = CGFloat(category.totalExpenditure / maxExpenditure) * 150
        
        return VStack {
            RoundedRectangle(cornerRadius: 5)
                .fill(Color.green.opacity(0.7))
                .frame(width: 30, height: normalizedHeight) // Separate height calculation

            Text(category.category)
                .font(.footnote)
                .foregroundColor(.black)
                .padding(.top, 4)
        }
    }
}
