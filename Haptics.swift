//
//  Haptics.swift
//  Lumēn
//
//  Created by Brian J Gonzalez on 10/22/25.
//


import UIKit

enum Haptics {
    static func tap() {
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
    }

    static func selection() {
        let generator = UISelectionFeedbackGenerator()
        generator.selectionChanged()
    }

    static func success() {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.success)
    }
}
