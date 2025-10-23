//
//  GlassGlowModifier.swift
//  Lumēn
//
//  Created by Brian J Gonzalez on 10/22/25.
//


import SwiftUI

struct GlassGlowModifier: ViewModifier {
    @Binding var isActive: Bool
    
    func body(content: Content) -> some View {
        content
            .overlay(
                RoundedRectangle(cornerRadius: 24, style: .continuous)
                    .strokeBorder(
                        LinearGradient(
                            colors: [.white.opacity(0.8), .cyan.opacity(0.4)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        lineWidth: isActive ? 3 : 0
                    )
                    .blur(radius: isActive ? 8 : 0)
                    .opacity(isActive ? 1 : 0)
                    .animation(.easeOut(duration: 0.4), value: isActive)
            )
    }
}

extension View {
    func glassGlow(active: Binding<Bool>) -> some View {
        self.modifier(GlassGlowModifier(isActive: active))
    }
}
