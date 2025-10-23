import SwiftUI

struct InsightCard: View {
    let insight: Insight
    @EnvironmentObject private var theme: LumenThemeManager
    @State private var isGlowing = false

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(insight.text)
                .font(.headline)
                .foregroundStyle(.primary)
            Text("– \(insight.author)")
                .font(.subheadline)
                .foregroundStyle(.secondary)
            Text(insight.date, style: .time)
                .font(.caption)
                .foregroundStyle(.tertiary)
        }
        .padding(20)
        .background(
            ZStack {
                LinearGradient(
                    colors: gradientColors,
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                RoundedRectangle(cornerRadius: 24, style: .continuous)
                    .fill(.ultraThinMaterial)
            }
        )
        .cornerRadius(24)
        .overlay(
            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .strokeBorder(accentStrokeColor, lineWidth: 1)
        )
        .shadow(color: shadowColor, radius: 10, x: 0, y: 6)
        .padding(.horizontal)
        .parallax(amount: 4)
        .glassGlow(active: $isGlowing) // 👈 applies the glow modifier
        .onTapGesture {
            // Trigger the glow when tapped
            isGlowing = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                isGlowing = false
            }
        }
    }
}

private extension InsightCard {
    var gradientColors: [Color] {
        let palette = theme.colors
        let first = palette.first ?? Color.white
        let last = palette.last ?? Color.white

        return [first.opacity(0.35), last.opacity(0.18)]
    }

    var accentStrokeColor: Color {
        (theme.colors.first ?? Color.white).opacity(0.28)
    }

    var shadowColor: Color {
        (theme.colors.last ?? Color.black).opacity(0.14)
    }
}

#Preview {
    InsightCard(
        insight: Insight(
            id: UUID(),
            author: "Preview",
            text: "Lūmen listens before it illuminates.",
            date: Date(),
            isFavorite: false
        )
    )
    .environmentObject(LumenThemeManager())
}



