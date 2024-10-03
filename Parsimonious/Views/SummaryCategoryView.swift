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
                        Button(action: {
                            if category == "All" {
                                categories = Set()
                                if !categories.contains("All") {
                                    categories.insert("All")
                                    for otherCategory in controller.categories {
                                        categories.insert(otherCategory)
                                    }
                                }
                                return
                            }
                            
                            if categories.contains(category) {
                                categories.remove(category)
                            } else {
                                categories.insert(category)
                            }
                        }) {
                            Text(category)
                                .font(.system(size: 20, weight: .semibold))
                                .foregroundColor(categories.contains(category) ? .seafoamGreen : .gray)
                                .padding()
                                .background(categories.contains(category) ? Color.white : Color.clear)
                                .cornerRadius(8)
                        }
                    }
                }
                .padding(.horizontal)
            }
            .frame(height: 60)
        }
    }
}
