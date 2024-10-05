import SwiftUI

struct MonthlyExpenditure: Identifiable {
    let id = UUID()
    let month: String
    let expenditure: Double
    let budget: Double
}

struct BarGraphView: View {
    @State private var selectedMonth: MonthlyExpenditure? = nil
    @State private var currentYear = 2024
    
    // Sample data for expenditures and budgets
    var months: [MonthlyExpenditure] = [
        MonthlyExpenditure(month: "Jan", expenditure: 400, budget: 500),
        MonthlyExpenditure(month: "Feb", expenditure: 600, budget: 500),
        MonthlyExpenditure(month: "Mar", expenditure: 550, budget: 500),
        MonthlyExpenditure(month: "Apr", expenditure: 480, budget: 500),
        MonthlyExpenditure(month: "May", expenditure: 620, budget: 500),
        MonthlyExpenditure(month: "Jun", expenditure: 500, budget: 500),
        MonthlyExpenditure(month: "Jul", expenditure: 450, budget: 500),
        MonthlyExpenditure(month: "Aug", expenditure: 700, budget: 500),
        MonthlyExpenditure(month: "Sep", expenditure: 670, budget: 500),
        MonthlyExpenditure(month: "Oct", expenditure: 530, budget: 500),
        MonthlyExpenditure(month: "Nov", expenditure: 590, budget: 500),
        MonthlyExpenditure(month: "Dec", expenditure: 550, budget: 500)
    ]
    
    var maxExpenditure: Double {
        months.map { $0.expenditure }.max() ?? 0
    }
    
    var body: some View {
        VStack {
            // Main graph container
            ZStack {
                // Y-axis and bars
                HStack(alignment: .bottom, spacing: 10) {
                    // Y-Axis labels
                    VStack {
                        ForEach([0, 200, 400, 600, 800], id: \.self) { amount in
                            Text("$\(amount)")
                                .font(.caption)
                            Spacer()
                        }
                    }
                    .frame(width: 40)
                    
                    // Scrollable bar graph
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(alignment: .bottom, spacing: 20) {
                            ForEach(months) { month in
                                BarView(month: month,
                                        isSelected: month.id == selectedMonth?.id)
                                .onTapGesture {
                                    selectedMonth = month
                                }
                            }
                        }
                        .padding()
                    }
                }
                
                // Dashed budget line (overlaid on the bars)
                GeometryReader { geo in
                    let maxHeight = geo.size.height
                    let budgetLineY = maxHeight - CGFloat(500 / maxExpenditure * maxHeight)
                    
                    Path { path in
                        path.move(to: CGPoint(x: 0, y: budgetLineY))
                        path.addLine(to: CGPoint(x: geo.size.width, y: budgetLineY))
                    }
                    .stroke(style: StrokeStyle(lineWidth: 2, dash: [5]))
                    .foregroundColor(.red)
                }
            }
            .frame(height: 250)
            .padding(.leading)
            
            // Detailed view below the graph
            if let selected = selectedMonth {
                VStack {
                    Text("Detailed Info for \(selected.month)")
                        .font(.headline)
                        .padding(.top, 20)
                    Text("Expenditure: $\(selected.expenditure, specifier: "%.2f")")
                    Text("Budget: $\(selected.budget, specifier: "%.2f")")
                        .foregroundColor(.red)
                    Spacer()
                }
                .padding()
            } else {
                Text("Select a month to see details")
                    .padding()
            }
        }
        .padding()
    }
}

struct BarView: View {
    var month: MonthlyExpenditure
    var isSelected: Bool
    
    var body: some View {
        VStack {
            Spacer()
            
            // Bar representing expenditure
            Rectangle()
                .fill(isSelected ? Color.blue : Color.green)
                .frame(width: 30, height: CGFloat(month.expenditure) / 800 * 200) // Normalize to max height
            
            // Month label below the bar
            Text(month.month)
                .font(.caption)
        }
        .padding(.top)
    }
}
