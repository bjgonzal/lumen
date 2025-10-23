import SwiftUI

struct ParallaxMotionModifier: ViewModifier {
    var amount: Double
    @State private var motionX: Double = 0
    @State private var motionY: Double = 0

    func body(content: Content) -> some View {
        content
            .rotation3DEffect(
                .degrees(motionY * amount),
                axis: (x: 1, y: 0, z: 0)
            )
            .rotation3DEffect(
                .degrees(motionX * amount),
                axis: (x: 0, y: 1, z: 0)
            )
            .onAppear {
                // Simulate slow oscillation when testing on simulator
                withAnimation(.easeInOut(duration: 10).repeatForever(autoreverses: true)) {
                    motionX = 0.8
                    motionY = -0.6
                }
            }
    }
}

extension View {
    func parallax(amount: Double = 5) -> some View {
        self.modifier(ParallaxMotionModifier(amount: amount))
    }
}

