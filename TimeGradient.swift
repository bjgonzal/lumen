//
//  TimeGradient.swift
//  Lumēn
//
//  Created by Brian J Gonzalez on 10/22/25.
//


import SwiftUI

struct TimeGradient {
    static func colors(for date: Date = Date()) -> [Color] {
        let hour = Calendar.current.component(.hour, from: date)
        
        switch hour {
        case 5..<9:   // 🌄 Dawn
            return [Color(.systemYellow).opacity(0.5),
                    Color(.systemOrange).opacity(0.3)]
        case 9..<17:  // 🌞 Day
            return [Color(.systemTeal).opacity(0.4),
                    Color(.systemCyan).opacity(0.2)]
        case 17..<20: // 🌇 Dusk
            return [Color(.systemPink).opacity(0.4),
                    Color(.systemPurple).opacity(0.3)]
        default:      // 🌙 Night
            return [Color(.black),
                    Color(.purple).opacity(0.4)]
        }
    }
}
