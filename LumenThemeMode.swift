//
//  LumenThemeMode.swift
//  Lumēn
//
//  Created by Brian J Gonzalez on 10/22/25.
//


import SwiftUI

enum LumenThemeMode: String, CaseIterable, Identifiable {
    case timeOfDay = "Daylight Rhythm"
    case emotionalTone = "Noēsis Tone"

    var id: String { self.rawValue }

    var systemImageName: String {
        switch self {
        case .timeOfDay:
            return "sun.max.fill"
        case .emotionalTone:
            return "moon.stars.fill"
        }
    }

    func summary(for tone: NoesisGradient.Tone?) -> String {
        switch self {
        case .timeOfDay:
            return "Follows the sky's rhythm as the hours shift."
        case .emotionalTone:
            if let tone {
                return "Mirrors the Noēsis tone “\(tone.name)”."
            } else {
                return "Listens for the present emotional undercurrent."
            }
        }
    }
}
