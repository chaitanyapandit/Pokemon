//
//  PokemonButtonStyle.swift
//  Pokemon
//
//  Created by Chaitanya Pandit on 24/05/24.
//

import SwiftUI

struct PokemonButtonStyle: ButtonStyle {
    var isSelected: Bool
    var selectedBackground = LinearGradient(
        gradient: Gradient(colors: [Color.purple.opacity(0.8), Color.blue.opacity(0.8)]),
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    var unselectedBackground = LinearGradient(
        gradient: Gradient(colors: [Color.purple.opacity(0.3), Color.blue.opacity(0.3)]),
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    var selectedShadowColor = Color.primary.opacity(0.4)
    var unselectedShadowColor = Color.primary.opacity(0.2)
    var shadowRadius = 10
    var shadowX = 0
    var shadowY = 5
    var cornerRadius = 15
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding()
            .foregroundColor(.white)
            .background(isSelected ? selectedBackground : unselectedBackground)
            .cornerRadius(CGFloat(cornerRadius))
            .shadow(color: isSelected ? selectedShadowColor : unselectedShadowColor,
                    radius: CGFloat(shadowRadius),
                    x: CGFloat(shadowX),
                    y: CGFloat(shadowY))
    }
}
