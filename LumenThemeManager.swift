import SwiftUI

@MainActor
final class LumenThemeManager: ObservableObject {
    @Published var mode: LumenThemeMode {
        didSet {
            updatePalette()
        }
    }

    @Published private(set) var colors: [Color]
    @Published private(set) var activeTone: NoesisGradient.Tone?

    init(mode: LumenThemeMode = .timeOfDay) {
        self.mode = mode
        self.colors = []
        self.activeTone = nil
        updatePalette(forceRefresh: true)
    }

    func refreshPalette() {
        updatePalette(forceRefresh: true)
    }

    private func updatePalette(forceRefresh: Bool = false) {
        switch mode {
        case .timeOfDay:
            activeTone = nil
            colors = TimeGradient.colors()
        case .emotionalTone:
            if forceRefresh || activeTone == nil {
                activeTone = NoesisGradient.currentTone()
            }
            if let tone = activeTone {
                colors = tone.colors
            } else {
                let fallbackTone = NoesisGradient.fallbackTone
                activeTone = fallbackTone
                colors = fallbackTone.colors
            }
        }
    }
}

private struct LumenBackgroundModifier: ViewModifier {
    @EnvironmentObject private var theme: LumenThemeManager

    func body(content: Content) -> some View {
        let palette = theme.colors.isEmpty ? TimeGradient.colors() : theme.colors

        return ZStack {
            LinearGradient(
                colors: palette,
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            .animation(.easeInOut(duration: 0.6), value: theme.mode)
            .animation(
                .easeInOut(duration: 0.6),
                value: theme.activeTone?.name ?? ""
            )

            content
        }
    }
}

extension View {
    func lumenBackground() -> some View {
        modifier(LumenBackgroundModifier())
    }
}
