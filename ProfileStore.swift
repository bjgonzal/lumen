import SwiftUI
import Combine
import UIKit

@MainActor
final class ProfileStore: ObservableObject {
    @Published var profile: UserProfile = UserProfile(username: "", fullName: "", bio: "", avatarData: nil)
    private let saveKey = "user_profile"

    init() {
        load()
    }

    // MARK: - Persistence
    func updateAvatar(_ image: UIImage) {
        profile.avatarData = image.pngData()
        saveProfile()
    }

    func updateProfile(username: String, fullName: String, bio: String, avatar: UIImage?) {
        profile.username = username
        profile.fullName = fullName
        profile.bio = bio
        if let avatar = avatar {
            profile.avatarData = avatar.pngData()
        }
        saveProfile()
    }

    func saveProfile() {
        if let data = try? JSONEncoder().encode(profile) {
            UserDefaults.standard.set(data, forKey: saveKey)
        }
    }

    private func load() {
        guard let data = UserDefaults.standard.data(forKey: saveKey),
              let decoded = try? JSONDecoder().decode(UserProfile.self, from: data) else { return }
        profile = decoded
    }
}



