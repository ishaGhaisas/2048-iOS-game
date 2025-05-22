//  Nihal Shetty (ndshetty)
//  Isha Ghaisas (ighaisas)
//  App Name: Team06Project (2048Game)
//  GitHub Submission Date: 05/06/2025
//
//  Theme.swift
//  Team06Project
//
//  Created by Nihal Shetty on 5/2/25.
//

import UIKit

enum ColorTheme {
    case green
    case blue
}

class ThemeManager {
    static let shared = ThemeManager()
    
    var currentTheme: ColorTheme = .green
}

extension Notification.Name {
    static let themeChanged = Notification.Name("ThemeChanged")
}
