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
}
