//
//  MyPlanComponents.swift
//  FitnessApp
//
//  Created by Vanesa Orcikova on 01/02/2026.
//

import SwiftUI

struct TagChip: View {
    let text: String
    let accent: Color
    let accent2: Color

    var body: some View {
        Text(text)
            .font(.system(size: 11, weight: .bold))
            .foregroundColor(accent)
            .padding(.horizontal, 10)
            .padding(.vertical, 6)
            .background(
                LinearGradient(
                    colors: [accent.opacity(0.12), accent2.opacity(0.12)],
                    startPoint: .leading,
                    endPoint: .trailing
                )
            )
            .clipShape(Capsule())
    }
}

struct EmptyStateCard: View {
    let card: Color

    var body: some View {
        VStack(spacing: 10) {
            Text("No plan items yet ✨")
                .font(.system(size: 16, weight: .bold))
                .foregroundColor(.black.opacity(0.8))

            Text("Tap “Add new item” to create your first goal.")
                .font(.system(size: 13, weight: .semibold))
                .foregroundColor(.black.opacity(0.55))
                .multilineTextAlignment(.center)
        }
        .padding(18)
        .frame(maxWidth: .infinity)
        .background(card)
        .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
        .shadow(radius: 8, y: 3)
    }
}


