import SwiftUI
import PhotosUI

struct EditProfileView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var profileStore: ProfileStore

    @State private var username = ""
    @State private var fullName = ""
    @State private var bio = ""
    @State private var avatar: UIImage?

    var body: some View {
        Form {
            Section {
                Circle()
                    .fill(Color.gray.opacity(0.3))
                    .frame(width: 80, height: 80)
                    .overlay(Image(systemName: "camera.fill"))
            }

            Section(header: Text("Info")) {
                TextField("Username", text: $username)
                TextField("Full Name", text: $fullName)
                TextField("Bio", text: $bio, axis: .vertical)
                    .lineLimit(3)
            }
        }
        .navigationTitle("Edit Profile")
        .toolbar {
            ToolbarItem(placement: .confirmationAction) {
                Button("Save") {
                    profileStore.updateProfile(username: username,
                                               fullName: fullName,
                                               bio: bio,
                                               avatar: avatar)
                    dismiss()
                }
            }
            ToolbarItem(placement: .cancellationAction) {
                Button("Cancel") { dismiss() }
            }
        }
        .onAppear {
            let profile = profileStore.profile
            username = profile.username
            fullName = profile.fullName
            bio = profile.bio
        }
    }
}

