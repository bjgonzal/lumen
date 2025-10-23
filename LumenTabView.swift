//
//  LumenTabView.swift
//  Lumēn
//
//  Created by Brian J Gonzalez on 10/22/25.
//


//
//  LumenTabView.swift
//  Lūmen
//
//  Created by Brian J Gonzalez on 10/22/25.
//

import SwiftUI

struct LumenTabView: View {
    @EnvironmentObject var store: InsightStore
    @EnvironmentObject var profileStore: ProfileStore
    @StateObject private var feedViewModel = FeedViewModel()

    var body: some View {
        TabView {
            // Feed Tab
            FeedView()
                .environmentObject(feedViewModel)
                .environmentObject(store)
                .tabItem {
                    Label("Feed", systemImage: "sparkles")
                }

            // Profile Tab
            ProfileView()
                .environmentObject(profileStore)
                .tabItem {
                    Label("Profile", systemImage: "person.circle")
                }
        }
        .tint(.black) // matches your Lūmen brand tone
        .background(Color.clear)
        .lumenBackground()
    }
}
