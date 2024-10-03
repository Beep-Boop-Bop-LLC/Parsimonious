//
//  ReceiptSummaryView.swift
//  Parsimonious
//
//  Created by Nick Venanzi on 10/2/24.
//

import SwiftUI

struct ReceiptSummaryView: View {
    
    @EnvironmentObject var controller: ReceiptController
    @State var selectedCategories: Set<String> = Set()
    
    var body: some View {
        VStack {
            SummaryCategoryView(categories: $selectedCategories)
            
            ReceiptListView(categories: $selectedCategories)
        }
        .background(Color.paleGreen.ignoresSafeArea())
        .onAppear {
            selectedCategories.insert("All")
            for category in controller.categories {
                selectedCategories.insert(category)
            }
        }
    }
}
