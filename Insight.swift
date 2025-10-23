import Foundation

struct Insight: Identifiable, Codable, Equatable {
    let id: UUID
    let author: String
    let text: String
    let date: Date
    var isFavorite: Bool = false
}


