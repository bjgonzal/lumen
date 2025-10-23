//
//  NoesisGradient.swift
//  Lumēn
//
//  Created by Brian J Gonzalez on 10/22/25.
//


import SwiftUI

struct NoesisGradient {
    // In a real build, this could come from emotion-analysis or user input
    static func currentTone() -> [Color] {
        // placeholder: emotional “mood palette”
        let tones: [[Color]] = [
            [Color.pink.opacity(0.4), Color.orange.opacity(0.3)],  // passion
            [Color.blue.opacity(0.4), Color.cyan.opacity(0.3)],    // calm
            [Color.purple.opacity(0.4), Color.indigo.opacity(0.3)],// introspective
            [Color.green.opacity(0.4), Color.teal.opacity(0.3)]    // renewal
        ]
        return tones.randomElement() ?? tones[0]
    }
}
