//
//  BlogDescriptionView.swift
//  FitnessApp
//
//  Created by Vanesa Orcikova on 06/02/2026.
//

import SwiftUI

struct BlogDescriptionView: View {
    let post: BlogPostModel

    @State private var isTextExpanded: Bool = false

    private let accent = Color(red: 0.85, green: 0.20, blue: 0.70)
    private let softBg = Color(red: 1.0, green: 0.97, blue: 0.99)

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 0) {

                // MARK: - HEADER IMAGE (ako RecipeDescriptionView)
                ZStack {
                    Image(post.imageName)
                        .resizable()
                        .scaledToFill()
                        .frame(height: 340)
                        .clipped()

                    LinearGradient(
                        colors: [.black.opacity(0.35), .clear],
                        startPoint: .top,
                        endPoint: .center
                    )
                }

                // MARK: - CONTENT (zjednodušené)
                VStack(alignment: .leading, spacing: 14) {

                    Text(post.title)
                        .font(.system(size: 26, weight: .bold))
                        .foregroundColor(.black.opacity(0.85))

                    InfoPill(text: "BLOG", color: accent)

                    Text(post.subtitle)
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundColor(.black.opacity(0.65))
                        .padding(.top, 2)

                    Divider().opacity(0.25)

                    VStack(alignment: .leading, spacing: 8) {
                        Text(post.text)
                            .font(.system(size: 15))
                            .foregroundColor(.black.opacity(0.72))
                            .lineSpacing(4)
                            .lineLimit(isTextExpanded ? nil : 6)
                            .frame(maxWidth: .infinity, alignment: .leading)

                        Button {
                            withAnimation(.easeInOut) {
                                isTextExpanded.toggle()
                            }
                        } label: {
                            Text(isTextExpanded ? "Show less" : "Read more")
                                .font(.system(size: 14, weight: .bold))
                                .foregroundColor(accent)
                        }
                    }

                    Spacer(minLength: 20)
                }
                .padding(20)
                .background(softBg)
                .clipShape(RoundedRectangle(cornerRadius: 28, style: .continuous))
                .offset(y: -30)
            }
        }
        .ignoresSafeArea(edges: .top)
        .background(softBg)
        .navigationBarTitleDisplayMode(.inline)
    }
}

// MARK: - Small UI

private struct InfoPill: View {
    let text: String
    let color: Color

    var body: some View {
        Text(text)
            .font(.system(size: 13, weight: .bold))
            .foregroundColor(.white)
            .padding(.horizontal, 12)
            .padding(.vertical, 6)
            .background(color)
            .clipShape(Capsule())
    }
}
