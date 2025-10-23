import SwiftUI
import Combine

@main
struct LumenApp: App {
    @StateObject private var store = InsightStore()
    @StateObject private var profileStore = ProfileStore()

    var body: some Scene {
        WindowGroup {
            LumenTabView()
                .environmentObject(store)
                .environmentObject(profileStore)
        }
    }
}

