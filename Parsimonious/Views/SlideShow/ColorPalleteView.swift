//
//  ColorPalleteView.swift
//  Parsimonious
//
//  Created by Zach Venanzi on 2/23/25.
//

import SwiftUI

struct ColorPaletteView: View {
    // Array of colors and their names
    let colors: [(Color, String)] = [
        (.paleGreen, "Pale Green"),
        (.lightBeige, "Light Beige"),
        (.lightGreen, "Light Green"),
        (.midGreen, "Mid Green"),
        (.darkGreen, "Dark Green"),
        (.softYellow, "Soft Yellow"),
        (.mustard, "Mustard"),
        (.burntOrange, "Burnt Orange"),
        (.deepRed, "Deep Red"),
        (.brickRed, "Brick Red"),
        (.warmBrown, "Warm Brown"),
        (.mocha, "Mocha"),
        (.taupe, "Taupe"),
        (.sand, "Sand"),
        (.mutedPink, "Muted Pink"),
        (.softLavender, "Soft Lavender"),
        (.deepPurple, "Deep Purple"),
        (.slateBlue, "Slate Blue"),
        (.oceanBlue, "Ocean Blue"),
        (.teal, "Teal"),
        (.forestGreen, "Forest Green"),
        (.mossGreen, "Moss Green"),
        (.emerald, "Emerald"),
        (.seafoam, "Seafoam"),
        (.coolGray, "Cool Gray")
    ]

    var body: some View {
        ScrollView {
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 100), spacing: 10)], spacing: 10) {
                ForEach(colors, id: \.1) { color, name in
                    VStack {
                        RoundedRectangle(cornerRadius: 8)
                            .fill(color)
                            .frame(height: 50)
                        Text(name)
                            .font(.caption)
                            .foregroundColor(.primary)
                            .lineLimit(1)
                            .truncationMode(.tail)
                    }
                    .frame(width: 100)
                }
            }
            .padding()
        }
        .navigationTitle("Color Palette")
    }
}
