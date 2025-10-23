import Foundation

struct UserProfile: Codable, Identifiable {
    var id = UUID()
    var username: String
    var fullName: String
    var bio: String
    var avatarData: Data?
}

