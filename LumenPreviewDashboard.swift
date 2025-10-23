import SwiftUI

struct LumenPreviewDashboard: View {
    @StateObject private var feedVM = FeedViewModel()
    @State private var selectedMode: LumenThemeMode = .timeOfDay

    var body: some View {
        TabView {
            // 🌕 Main Feed
            FeedView()
                .environmentObject(feedVM)
                .tabItem {
                    Label("Feed", systemImage: "sun.max.fill")
                }

            // 🌗 Emotional Mode (Dark)
            FeedView()
                .environmentObject(feedVM)
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
                    .padding()

                    InsightCard(insight: Insight(
                        id: UUID(),
                        author: "Daileen",
                        text: "Silence refines perception.",
                        date: Date()
                    ))
                    .padding()
                }
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

