//
//  PrettyLoginView.swift
//  FitnessApp
//
//  Created by Vanesa Orcikova on 06/02/2026.
//

import SwiftUI

struct PrettyLoginView: View {

    // sem si zapojíš tvoju existujúcu login akciu
    let onGoogleTap: () -> Void

    var body: some View {
        ZStack {
            // Background
            LinearGradient(
                colors: [
                    Color(red: 1.0, green: 0.93, blue: 0.96),
                    Color.white
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            VStack(spacing: 18) {

                Spacer().frame(height: 30)

                // App "logo" (môžeš nahradiť obrázkom)
                ZStack {
                    Circle()
                        .fill(Color.white)
                        .frame(width: 96, height: 96)
                        .shadow(color: .black.opacity(0.08), radius: 14, x: 0, y: 10)

                    Image(systemName: "heart.fill")
                        .font(.system(size: 40, weight: .semibold))
                        .foregroundStyle(
                            LinearGradient(
                                colors: [
                                    Color(red: 1.0, green: 0.35, blue: 0.60),
                                    Color(red: 0.95, green: 0.15, blue: 0.45)
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                }

                VStack(spacing: 8) {
                    Text("Healthy Fit Me")
                        .font(.system(size: 34, weight: .bold, design: .rounded))
                        .foregroundColor(.black)

                    Text("Sign in to continue")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.black.opacity(0.55))
                }
                .padding(.top, 6)

                // Card
                VStack(spacing: 14) {
                    // benefits
                    VStack(alignment: .leading, spacing: 10) {
                        BenefitRow(icon: "sparkles", title: "Daily motivation", subtitle: "Quotes & mini-challenges")
                        BenefitRow(icon: "checkmark.seal.fill", title: "My Plan", subtitle: "Simple, interactive tasks")
                        BenefitRow(icon: "flame.fill", title: "Workouts & recipes", subtitle: "Everything in one place")
                    }
                    .padding(.bottom, 6)

                    Button(action: onGoogleTap) {
                        HStack(spacing: 10) {
                            Image(systemName: "globe")
                                .font(.system(size: 18, weight: .semibold))
                            Text("Continue with Google")
                                .font(.system(size: 17, weight: .semibold))
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                        .background(Color.white)
                        .foregroundColor(.black)
                        .cornerRadius(16)
                        .shadow(color: .black.opacity(0.10), radius: 12, x: 0, y: 8)
                    }
                    .buttonStyle(.plain)

                    Text("By continuing, you agree to our Terms & Privacy Policy.")
                        .font(.system(size: 12, weight: .regular))
                        .foregroundColor(.black.opacity(0.45))
                        .multilineTextAlignment(.center)
                        .padding(.top, 2)
                }
                .padding(18)
                .background(Color.white.opacity(0.70))
                .cornerRadius(22)
                .overlay(
                    RoundedRectangle(cornerRadius: 22)
                        .stroke(Color.black.opacity(0.06), lineWidth: 1)
                )
                .padding(.horizontal, 18)
                .padding(.top, 14)

                Spacer()

                // little footer
                Text("✨ Your wellness, one day at a time")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundColor(.black.opacity(0.45))
                    .padding(.bottom, 14)
            }
        }
    }
}

private struct BenefitRow: View {
    let icon: String
    let title: String
    let subtitle: String

    var body: some View {
        HStack(spacing: 12) {
            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.white)
                    .frame(width: 44, height: 44)
                    .shadow(color: .black.opacity(0.06), radius: 10, x: 0, y: 6)

                Image(systemName: icon)
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(Color(red: 1.0, green: 0.35, blue: 0.60))
            }

            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundColor(.black)
                Text(subtitle)
                    .font(.system(size: 13, weight: .medium))
                    .foregroundColor(.black.opacity(0.55))
            }

            Spacer()
        }
    }
}
