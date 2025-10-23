import SwiftUI
import PhotosUI
import UIKit

struct ProfileView: View {
    @EnvironmentObject var profileStore: ProfileStore
    @State private var showPhotoPicker = false
    @State private var selectedItem: PhotosPickerItem?

    var body: some View {
        VStack(spacing: 24) {

            // MARK: - Avatar
            Button {
                showPhotoPicker = true
            } label: {
                if let data = profileStore.profile.avatarData,
                   let uiImage = UIImage(data: data) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 100, height: 100)
                        .clipShape(Circle())
                        .shadow(radius: 6)
                } else {
                    Circle()
                        .fill(.ultraThinMaterial)
                        .frame(width: 100, height: 100)
                        .overlay(
                            Image(systemName: "person.crop.circle.fill")
                                .font(.system(size: 50))
                                .foregroundStyle(.secondary)
                        )
                }
            }
            .photosPicker(isPresented: $showPhotoPicker, selection: $selectedItem)
            // ✅ Modern iOS 17+ safe change
            .onChange(of: selectedItem) { _, newValue in
                guard let newValue else { return }
                Task {
                    if let data = try? await newValue.loadTransferable(type: Data.self),
                       let image = UIImage(data: data) {
                        profileStore.updateAvatar(image)
                    }
                }
            }

            // MARK: - Username
            TextField(
                "Username",
                text: Binding(
                    get: { profileStore.profile.username },
                    set: {
                        profileStore.profile.username = $0
                        profileStore.saveProfile()
                    }
                )
            )
            .font(.title2.bold())
            .multilineTextAlignment(.center)

            // MARK: - Bio
            TextField(
                "Write something luminous...",
                text: Binding(
                    get: { profileStore.profile.bio },
                    set: {
                        profileStore.profile.bio = $0
                        profileStore.saveProfile()
                    }
                ),
                axis: .vertical
            )
            .multilineTextAlignment(.center)
            .padding()

            Spacer()
        }
        .padding()
        .background(.ultraThinMaterial)
        .navigationTitle("Profile")
    }
}


