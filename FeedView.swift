import SwiftUI

struct FeedView: View {
    @EnvironmentObject var viewModel: FeedViewModel
    @EnvironmentObject var store: InsightStore
    @EnvironmentObject private var theme: LumenThemeManager
    @State private var showingAddInsight = false

    private var themeModeBinding: Binding<LumenThemeMode> {
        Binding(
            get: { theme.mode },
            set: { theme.mode = $0 }
        )
    }

    var body: some View {
        NavigationStack {
            ZStack(alignment: .bottomTrailing) {
                ScrollView {
                    LazyVStack(spacing: 18) {
                        themeStatusCard

                        ForEach(store.insights) { insight in
                            InsightCard(insight: insight)
                        }
                    }
                    .padding(.top, 24)
                    .padding(.bottom, 120)
                }
                .scrollIndicators(.hidden)
                .navigationTitle("Lūmen")
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Menu {
                            Picker("Luminous Theme", selection: themeModeBinding) {
                                ForEach(LumenThemeMode.allCases) { mode in
                                    Label(mode.rawValue, systemImage: mode.systemImageName)
                                        .tag(mode)
                                }
                            }

                            Divider()

                            Button {
                                theme.refreshPalette()
                            } label: {
                                Label(
                                    theme.mode == .timeOfDay ? "Sync with Time" : "Refresh Noēsis Tone",
                                    systemImage: "arrow.triangle.2.circlepath"
                                )
                            }
                        } label: {
                            Image(systemName: theme.mode.systemImageName)
                                .symbolRenderingMode(.hierarchical)
                        }
                        .accessibilityLabel("Change luminous theme")
                    }
                }

                Button(action: {
                    showingAddInsight = true
                }) {
                    Image(systemName: "plus")
                        .font(.title2.bold())
                        .foregroundStyle(Color.white)
                        .padding()
                        .background(addButtonBackground)
                        .shadow(color: Color.black.opacity(0.2), radius: 8, x: 0, y: 6)
                }
                .padding()
                .accessibilityLabel("Add new insight")
            }
            .sheet(isPresented: $showingAddInsight) {
                AddInsightView()
                    .environmentObject(store)
            }
        }
    }

    private var addButtonBackground: some View {
        let palette = theme.colors
        let first = palette.first ?? Color.black
        let last = palette.last ?? Color.gray

        return Circle()
            .fill(
                LinearGradient(
                    colors: [first.opacity(0.9), last.opacity(0.75)],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
    }

    private var themeStatusCard: some View {
        VStack(alignment: .leading, spacing: 8) {
            Label(theme.mode.rawValue, systemImage: theme.mode.systemImageName)
                .font(.footnote.weight(.semibold))

            Text(theme.mode.summary(for: theme.activeTone))
                .font(.caption)
                .foregroundStyle(.secondary)

            if theme.mode == .emotionalTone, let tone = theme.activeTone {
                Text(tone.mantra)
                    .font(.caption2)
                    .foregroundStyle(.secondary)
                    .transition(.opacity)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .fill(.ultraThinMaterial)
                .overlay(
                    RoundedRectangle(cornerRadius: 24, style: .continuous)
                        .strokeBorder(
                            (theme.colors.first ?? Color.white).opacity(0.25),
                            lineWidth: 1
                        )
                )
        )
        .padding(.horizontal)
    }
}

