import Foundation

struct ChatMessage: Identifiable, Codable {
    enum Role: String, Codable {
        case user
        case bot
    }

    let id: UUID
    let text: String
    let role: Role
    let timestamp: Date

    init(id: UUID = UUID(), text: String, role: Role, timestamp: Date = Date()) {
        self.id = id
        self.text = text
        self.role = role
        self.timestamp = timestamp
    }
}
