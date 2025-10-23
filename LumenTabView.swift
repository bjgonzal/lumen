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

    var body: some View {
        TabView {
            // Feed Tab
            FeedView()
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
    }
}
