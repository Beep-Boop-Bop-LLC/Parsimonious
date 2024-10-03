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
                    .foregroundColor(.seafoamGreen)
                    .frame(maxWidth: .infinity, alignment: .center)
            }
            TextField("", text: $note).customTextField()
        }
    }
}
