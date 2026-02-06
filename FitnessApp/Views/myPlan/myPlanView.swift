import SwiftUI
import UIKit
import FirebaseAuth
import GoogleSignIn

struct myPlanView: View {

    @StateObject private var store = MyPlanStore()

    @State private var page: Int = 0              // 0 = My Plan, 1 = Logout
    @State private var showAddSheet = false
    @State private var editingItem: PlanItem? = nil

    @State private var showGlow = false
    @State private var showLogoutConfirm = false

    private let bg = Color(red: 1.0, green: 0.97, blue: 0.99)
    private let accent = Color(red: 0.85, green: 0.20, blue: 0.70)
    private let accent2 = Color(red: 0.98, green: 0.67, blue: 0.83)
    private let card = Color.white.opacity(0.9)

    var body: some View {
        NavigationStack {
            ZStack {
                bg.ignoresSafeArea()

                ScrollView(showsIndicators: false) {
                    VStack(spacing: 12) {

                        // ✅ Swipe header: My Plan / Logout
                        MyPlanBlogHeaderPager(
                            selection: $page,
                            streak: store.currentStreak,
                            done: store.todayDoneCount,
                            total: store.todayTotalCount
                        )
                        .padding(.top, -100)

                        if page == 0 {
                            myPlanSection
                        } else {
                            logoutSection
                        }
                    }
                    .padding(.top, 6)
                }

                if showGlow {
                    Text("✨")
                        .font(.system(size: 80, weight: .bold))
                        .foregroundColor(accent2.opacity(0.95))
                        .transition(.scale.combined(with: .opacity))
                        .shadow(radius: 10)
                }
            }
            .sheet(isPresented: $showAddSheet) {
                PlanItemEditorSheet(
                    mode: .add,
                    accent: accent,
                    accent2: accent2,
                    bg: bg,
                    initialItem: nil
                ) { newItem in
                    store.add(item: newItem)
                    showAddSheet = false
                }
            }
            .sheet(item: $editingItem) { item in
                PlanItemEditorSheet(
                    mode: .edit,
                    accent: accent,
                    accent2: accent2,
                    bg: bg,
                    initialItem: item
                ) { updated in
                    store.update(item, updated: updated)
                    editingItem = nil
                }
            }
            .alert("Sign out?", isPresented: $showLogoutConfirm) {
                Button("Cancel", role: .cancel) { }
                Button("Sign out", role: .destructive) {
                    signOutUser()
                }
            } message: {
                Text("You will be returned to the login screen.")
            }
        }
    }

    // MARK: - Sections

    private var myPlanSection: some View {
        VStack(spacing: 12) {

            Button {
                showAddSheet = true
            } label: {
                HStack {
                    Image(systemName: "plus")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(.white)

                    Text("Add new item")
                        .font(.system(size: 15, weight: .bold))
                        .foregroundColor(.white)

                    Spacer()
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 14)
                .background(
                    LinearGradient(colors: [accent, accent2],
                                   startPoint: .leading,
                                   endPoint: .trailing)
                )
                .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
                .shadow(radius: 10, y: 4)
            }
            .padding(.horizontal, 14)

            VStack(spacing: 14) {
                if store.items.isEmpty {
                    EmptyStateCard(card: card)
                } else {
                    myPlanDailyView(
                        items: store.items.filter { $0.section == .workout },
                        accent: accent,
                        accent2: accent2,
                        card: card,
                        onToggleDone: { didToggle($0) },
                        onEdit: { editingItem = $0 },
                        onDelete: { store.delete($0) }
                    )

                    myPlanMealView(
                        items: store.items.filter { $0.section == .meal },
                        accent: accent,
                        accent2: accent2,
                        card: card,
                        onToggleDone: { didToggle($0) },
                        onEdit: { editingItem = $0 },
                        onDelete: { store.delete($0) },
                        onToggleGrocery: { item, grocery in
                            store.toggleGrocery(to: item, grocery: grocery)
                        }
                    )
                }
            }
            .padding(.horizontal, 14)
            .padding(.bottom, 24)
        }
    }

    private var logoutSection: some View {
        VStack(spacing: 12) {

            VStack(alignment: .leading, spacing: 10) {
                HStack {
                    Text("Log out")
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(.black)

                    Spacer()
                }

                Text("You’ll be logged out of the app. You can sign in again anytime 💗")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(.gray)
            }

            Button {
                showLogoutConfirm = true
            } label: {
                HStack(spacing: 10) {
                    Image(systemName: "rectangle.portrait.and.arrow.right.fill")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(.white.opacity(0.95))

                    Text("Log out")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(.white)

                    Spacer()
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 14)
                .background(
                    LinearGradient(colors: [accent, accent2],
                                   startPoint: .leading,
                                   endPoint: .trailing)
                )
                .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
                .shadow(radius: 10, y: 4)
            }
        }
        .padding(18)
        .background(card)
        .clipShape(RoundedRectangle(cornerRadius: 22, style: .continuous))
        .shadow(radius: 10, y: 4)
        .padding(.horizontal, 14)
        .padding(.top, 6)
        .padding(.bottom, 24)
    }

    // MARK: - Helpers

    private func didToggle(_ item: PlanItem) {
        let nowDone = store.toggleDone(item)
        if nowDone {
            let gen = UIImpactFeedbackGenerator(style: .light)
            gen.impactOccurred()

            withAnimation(.spring(response: 0.35, dampingFraction: 0.6)) {
                showGlow = true
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
                withAnimation(.easeOut(duration: 0.25)) {
                    showGlow = false
                }
            }
        }
    }

    // ✅ jediné miesto odhlásenia
    private func signOutUser() {
        do {
            try Auth.auth().signOut()
            GIDSignIn.sharedInstance.signOut()
            print("✅ Signed out")
        } catch {
            print("❌ Sign out error: \(error.localizedDescription)")
        }
    }
}
