//
//  InsightStore.swift
//  Lūmen
//
//  Created by Brian J Gonzalez on 10/22/25.
//

import SwiftUI
import Foundation   // For UUID, Date, JSONEncoder, UserDefaults
import Combine      // For ObservableObject and @Published

// MARK: - InsightStore

@MainActor
final class InsightStore: ObservableObject {
    @Published private(set) var insights: [Insight] = []
    private let saveKey = "saved_insights"

    // MARK: - Initialization
    init() {
        load()
        print("🧠 Loaded \(insights.count) insights from UserDefaults.")

        // Seed starter insights if empty
        if insights.isEmpty {
            insights = [
                Insight(
                    id: UUID(),
                    author: "Brian",
                    text: "Nature mirrors the hidden self.",
                    date: Date(),
                    isFavorite: false
                ),
                Insight(
                    id: UUID(),
                    author: "Daileen",
                    text: "Transformation begins with awareness.",
                    date: Date(),
                    isFavorite: false
                )
            ]
            save()
        }
    }

    // MARK: - Actions

    func toggleFavorite(for insight: Insight) {
        guard let index = insights.firstIndex(of: insight) else { return }
        insights[index].isFavorite.toggle()
        save()
    }

    func add(_ insight: Insight) {
        insights.append(insight)
        save()
    }

    func delete(at offsets: IndexSet) {
        insights.remove(atOffsets: offsets)
        save()
    }

    // MARK: - Persistence

    private func load() {
        guard
            let data = UserDefaults.standard.data(forKey: saveKey),
            let decoded = try? JSONDecoder().decode([Insight].self, from: data)
        else {
            insights = []
            return
        }
        insights = decoded
    }

    private func save() {
        if let data = try? JSONEncoder().encode(insights) {
            UserDefaults.standard.set(data, forKey: saveKey)
        }
    }
}

