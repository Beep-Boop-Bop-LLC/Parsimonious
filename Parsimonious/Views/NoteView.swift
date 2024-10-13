//
//  NoteView.swift
//  Parsimonious
//
//  Created by Nick Venanzi on 10/1/24.
//

import SwiftUI

struct NoteView: View {
    
    @Binding var note: String
    
    var body: some View {
        ZStack {
            if note.isEmpty {
                Text("note")
                    .font(.system(size: 25, weight: .semibold))
                    .foregroundColor(.darkGreen)
                    .shadow(color: .black.opacity(0.2), radius: 5, x: 2, y: 2) // Adjust shadow parameters here
                    .frame(maxWidth: .infinity, alignment: .center)
            }
            TextField("", text: $note).customTextField()
        }
    }
}
