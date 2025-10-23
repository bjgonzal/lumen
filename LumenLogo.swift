import SwiftUI

struct LumenLogo: View {
    private let tone: NoesisGradient.Tone

    init(tone: NoesisGradient.Tone = NoesisGradient.currentTone()) {
        self.tone = tone
    }

    private var gradientColors: [Color] {
        let colors = tone.colors
        switch colors.count {
        case 0:
            return [
                Color.white.opacity(0.65),
                Color.white.opacity(0.25)
            ]
        case 1:
            let color = colors[0]
            return [color, color.opacity(0.5)]
        default:
            return colors
        }
    }

    private var luminousGradient: AngularGradient {
        let colors = gradientColors + [gradientColors.first ?? Color.white.opacity(0.6)]
        return AngularGradient(gradient: Gradient(colors: colors), center: .center)
    }

    private var radialHighlight: RadialGradient {
        RadialGradient(
            gradient: Gradient(colors: [
                Color.white.opacity(0.85),
                gradientColors.last?.opacity(0.25) ?? Color.white.opacity(0.15)
            ]),
            center: .center,
            startRadius: 0,
            endRadius: 70
        )
    }

    var body: some View {
        ZStack {
            Circle()
                .fill(luminousGradient)
                .opacity(0.45)
                .blur(radius: 28)
                .scaleEffect(1.35)

            Circle()
                .strokeBorder(luminousGradient, lineWidth: 8)
                .opacity(0.55)
                .blur(radius: 10)

            Circle()
                .fill(radialHighlight)
                .overlay(
                    Circle()
                        .strokeBorder(Color.white.opacity(0.35), lineWidth: 1.5)
                        .blur(radius: 0.5)
                        .opacity(0.9)
                )
                .shadow(
                    color: gradientColors.first?.opacity(0.4) ?? Color.white.opacity(0.4),
                    radius: 16,
                    x: 0,
                    y: 12
                )

            Circle()
                .strokeBorder(Color.white.opacity(0.5), lineWidth: 2.5)
                .frame(width: 48, height: 48)
                .blur(radius: 0.8)
                .opacity(0.8)

            Image(systemName: "sparkles")
                .font(.system(size: 32, weight: .semibold))
                .foregroundStyle(
                    LinearGradient(
                        gradient: Gradient(colors: [
                            Color.white,
                            gradientColors.first ?? Color.white.opacity(0.8)
                        ]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .shadow(color: Color.white.opacity(0.6), radius: 8, x: 0, y: 2)
        }
        .frame(width: 160, height: 160)
        .accessibilityHidden(true)
    }
}

#Preview {
    LumenLogo(tone: NoesisGradient.fallbackTone)
        .padding()
        .background(Color.black)
}
