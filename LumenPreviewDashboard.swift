import SwiftUI

struct LumenPreviewDashboard: View {
    @StateObject private var feedVM = FeedViewModel()
    @StateObject private var insightStore = InsightStore()
    @StateObject private var dayThemeManager = LumenThemeManager(mode: .timeOfDay)
    @StateObject private var noesisThemeManager = LumenThemeManager(mode: .emotionalTone)

    var body: some View {
        TabView {
            // 🌕 Main Feed
            FeedView()
                .environmentObject(feedVM)
                .environmentObject(insightStore)
                .environmentObject(dayThemeManager)
                .tabItem {
                    Label("Feed", systemImage: "sun.max.fill")
                }

            // 🌗 Emotional Mode (Dark)
            FeedView()
                .environmentObject(feedVM)
                .environmentObject(insightStore)
                .environmentObject(noesisThemeManager)
                .environment(\.colorScheme, .dark)
                .tabItem {
                    Label("Noēsis", systemImage: "moon.stars.fill")
                }

            // 💡 Card Preview
            ScrollView {
                VStack(spacing: 32) {
                    InsightCard(insight: Insight(
                        id: UUID(),
                        author: "Brian",
                        text: "Light moves where attention lingers.",
                        date: Date()
                    ))

                    InsightCard(insight: Insight(
                        id: UUID(),
                        author: "Daileen",
                        text: "Silence refines perception.",
                        date: Date()
                    ))
                }
                .padding()
                .environmentObject(noesisThemeManager)
            }
            .tabItem {
                Label("Cards", systemImage: "rectangle.on.rectangle.angled")
            }
        }
        .tabViewStyle(.automatic)
    }
}

#Preview {
    LumenPreviewDashboard()
}

