import SwiftUI
import Combine

@main
struct LumenApp: App {
    @StateObject private var store = InsightStore()
    @StateObject private var profileStore = ProfileStore()
    @StateObject private var themeManager = LumenThemeManager()

    var body: some Scene {
        WindowGroup {
            LumenTabView()
                .environmentObject(store)
                .environmentObject(profileStore)
                .environmentObject(themeManager)
        }
    }
}

