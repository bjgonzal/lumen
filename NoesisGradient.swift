//
//  NoesisGradient.swift
//  Lūmen
//
//  Created by Brian J Gonzalez on 10/22/25.
//

import SwiftUI

struct NoesisGradient {
    struct Tone: Equatable {
        let name: String
        let mantra: String
        let colors: [Color]
    }

    private static let toneLibrary: [Tone] = [
        Tone(
            name: "Ignition",
            mantra: "Creativity hums with kinetic warmth.",
            colors: [
                Color(red: 0.99, green: 0.44, blue: 0.59).opacity(0.75),
                Color(red: 1.00, green: 0.72, blue: 0.45).opacity(0.55)
            ]
        ),
        Tone(
            name: "Still Waters",
            mantra: "Breath settles; awareness becomes glassy.",
            colors: [
                Color(red: 0.33, green: 0.59, blue: 0.98).opacity(0.65),
                Color(red: 0.36, green: 0.82, blue: 0.97).opacity(0.45)
            ]
        ),
        Tone(
            name: "Inner Orbit",
            mantra: "Attention spirals gently inward.",
            colors: [
                Color(red: 0.59, green: 0.42, blue: 0.93).opacity(0.70),
                Color(red: 0.36, green: 0.32, blue: 0.71).opacity(0.50)
            ]
        ),
        Tone(
            name: "Veridian Rise",
            mantra: "New growth stirs beneath the surface.",
            colors: [
                Color(red: 0.35, green: 0.77, blue: 0.63).opacity(0.65),
                Color(red: 0.19, green: 0.56, blue: 0.73).opacity(0.45)
            ]
        )
    ]

    static var fallbackTone: Tone {
        toneLibrary.first ?? Tone(
            name: "Equilibrium",
            mantra: "Light returns to neutral.",
            colors: [
                Color.white.opacity(0.35),
                Color.gray.opacity(0.25)
            ]
        )
    }

    static func currentTone() -> Tone {
        toneLibrary.randomElement() ?? fallbackTone
    }
}
