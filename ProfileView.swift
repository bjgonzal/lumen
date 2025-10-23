import SwiftUI
import PhotosUI
import UIKit

struct ProfileView: View {
    @EnvironmentObject var profileStore: ProfileStore
    @EnvironmentObject private var theme: LumenThemeManager
    @State private var showPhotoPicker = false
    @State private var selectedItem: PhotosPickerItem?

    var body: some View {
        ScrollView {
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
                            .frame(width: 110, height: 110)
                            .clipShape(Circle())
                            .shadow(radius: 8)
                    } else {
                        Circle()
                            .fill(avatarPlaceholderGradient)
                            .frame(width: 110, height: 110)
                            .overlay(
                                Image(systemName: "person.crop.circle.fill")
                                    .font(.system(size: 52))
                                    .foregroundStyle(.secondary)
                            )
                            .shadow(color: (theme.colors.last ?? Color.black).opacity(0.15), radius: 8, x: 0, y: 4)
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
                .background(
                    RoundedRectangle(cornerRadius: 20, style: .continuous)
                        .fill(.ultraThinMaterial)
                        .overlay(
                            RoundedRectangle(cornerRadius: 20, style: .continuous)
                                .strokeBorder((theme.colors.first ?? Color.white).opacity(0.18), lineWidth: 1)
                        )
                )

                luminousStatusCard
            }
            .padding(24)
            .frame(maxWidth: .infinity)
            .background(
                RoundedRectangle(cornerRadius: 32, style: .continuous)
                    .fill(.ultraThinMaterial)
                    .overlay(
                        RoundedRectangle(cornerRadius: 32, style: .continuous)
                            .strokeBorder((theme.colors.first ?? Color.white).opacity(0.14), lineWidth: 1)
                    )
            )
            .padding(.horizontal)
            .padding(.top)
            .padding(.bottom, 32)
        }
        .scrollIndicators(.hidden)
        .navigationTitle("Profile")
    }

    private var luminousStatusCard: some View {
        let isNoesis = theme.mode == .emotionalTone

        return VStack(alignment: .leading, spacing: 10) {
            Label(
                isNoesis ? "Noēsis Resonance" : "Daylight Rhythm",
                systemImage: isNoesis ? "waveform.path.ecg" : "sun.max.fill"
            )
            .font(.footnote.weight(.semibold))

            Text(theme.mode.summary(for: theme.activeTone))
                .font(.caption)
                .foregroundStyle(.secondary)

            if isNoesis, let tone = theme.activeTone {
                Text(tone.mantra)
                    .font(.caption2)
                    .foregroundStyle(.secondary)

                Button {
                    theme.refreshPalette()
                } label: {
                    Label("Refresh tone", systemImage: "arrow.triangle.2.circlepath")
                        .font(.caption.weight(.semibold))
                }
                .buttonStyle(.borderless)
                .tint(.primary)
                .padding(.top, 6)
            } else {
                Text("Tap refresh in the feed to sync with the current sky.")
                    .font(.caption2)
                    .foregroundStyle(.secondary)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .fill(.ultraThinMaterial)
                .overlay(
                    RoundedRectangle(cornerRadius: 24, style: .continuous)
                        .strokeBorder((theme.colors.first ?? Color.white).opacity(0.2), lineWidth: 1)
                )
        )
    }

    private var avatarPlaceholderGradient: LinearGradient {
        let palette = theme.colors
        let first = palette.first ?? Color.white
        let last = palette.last ?? Color.gray

        return LinearGradient(
            colors: [first.opacity(0.45), last.opacity(0.3)],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }
}
