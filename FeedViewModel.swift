import Foundation
import Combine

final class FeedViewModel: ObservableObject {
    @Published var insights: [Insight] = []

    init() {
        loadMockData()
    }

    func loadMockData() {
        insights = [
            Insight(id: UUID(), author: "Brian", text: "Nature mirrors the hidden self.", date: Date()),
            Insight(id: UUID(), author: "Daileen", text: "Transformation begins with awareness.", date: Date().addingTimeInterval(-3600))
        ]
    }
}

