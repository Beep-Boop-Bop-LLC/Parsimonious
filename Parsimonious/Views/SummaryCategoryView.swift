//
//  SummaryCategoryView.swift
//  Parsimonious
//
//  Created by Nick Venanzi on 10/2/24.
//

import SwiftUI

struct SummaryCategoryView: View {
    
    @EnvironmentObject var controller: ReceiptController
    @Binding var categories: Set<String>

    var body: some View {
        ScrollViewReader { scrollViewProxy in
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 10) {
                    ForEach(["All"] + Array(controller.categories), id: \.self) { category in
                        SummaryCategoryButton(category: category, categories: $categories)
                    }
                }
                .padding(.horizontal)
            }
            .frame(height: 60)
        }
    }
}

struct SummaryCategoryButton: View {
    let category: String
    @Binding var categories: Set<String>
    @EnvironmentObject var controller: ReceiptController

    var body: some View {
        Button(action: {
            if category == "All" {
                if categories.contains("All") {
                    categories = Set()
                } else {
                    categories = Set(controller.categories)
                    categories.insert("All")
                }
                return
            }

            if categories.contains(category) {
                categories.remove(category)
                categories.remove("All")
            } else {
                categories.insert(category)
                if categories.count == controller.categories.count {
                    categories.insert("All")
                }
            }
        }) {
            Text(category)
                .font(.system(size: 20, weight: .semibold))
                .foregroundColor(categories.contains(category) ? .darkGreen : .lightBeige)
                .padding()
                .background(categories.contains(category) ? Color.lightBeige.opacity(0.5) : Color.clear)
                .cornerRadius(8)
        }
    }
}
