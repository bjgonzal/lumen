import SwiftUI

struct InsightCard: View {
    let insight: Insight
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
                    colors: [
                        Color.white.opacity(0.25),
                        Color.white.opacity(0.1)
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                RoundedRectangle(cornerRadius: 24, style: .continuous)
                    .fill(.ultraThinMaterial)
            }
        )
        .cornerRadius(24)
        .shadow(color: .black.opacity(0.08), radius: 8, x: 0, y: 2)
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



