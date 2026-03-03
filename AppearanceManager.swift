//
//  AppearanceManager.swift
//  USCIS Citizenship practice
//
//  Created by Shanique Beckford on 2/22/26.
//

import SwiftUI
import Combine

enum AppearanceMode: String, CaseIterable, Codable {
    case light = "Light"
    case dark = "Dark"
    case automatic = "Automatic"
    
    var icon: String {
        switch self {
        case .light:
            return "sun.max.fill"
        case .dark:
            return "moon.fill"
        case .automatic:
            return "circle.lefthalf.filled"
        }
    }
    
    var colorScheme: ColorScheme? {
        switch self {
        case .light:
            return .light
        case .dark:
            return .dark
        case .automatic:
            return nil
        }
    }
}

class AppearanceManager: ObservableObject {
    @Published var appearanceMode: AppearanceMode {
        didSet {
            saveAppearance()
        }
    }
    
    private let userDefaults = UserDefaults.standard
    private let appearanceKey = "selectedAppearance"
    
    init() {
        if let data = userDefaults.data(forKey: appearanceKey),
           let decoded = try? JSONDecoder().decode(AppearanceMode.self, from: data) {
            self.appearanceMode = decoded
        } else {
            self.appearanceMode = .automatic
        }
    }
    
    private func saveAppearance() {
        if let encoded = try? JSONEncoder().encode(appearanceMode) {
            userDefaults.set(encoded, forKey: appearanceKey)
        }
    }
}
