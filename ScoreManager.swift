//
//  ScoreManager.swift
//  USCIS Citizenship practice
//
//  Created by Shanique Beckford on 2/22/26.
//

import Foundation
import Combine

struct ScoreRecord: Codable, Identifiable {
    let id: UUID
    let date: Date
    let score: Int
    let totalQuestions: Int
    let categoryPerformance: [String: CategoryPerformance]
    
    var percentage: Int {
        return (score * 100) / totalQuestions
    }
    
    var passed: Bool {
        return score >= 6
    }
}

struct CategoryPerformance: Codable {
    let correct: Int
    let total: Int
    
    var percentage: Int {
        guard total > 0 else { return 0 }
        return (correct * 100) / total
    }
}

class ScoreManager: ObservableObject {
    @Published var scoreHistory: [ScoreRecord] = []
    
    private let userDefaults = UserDefaults.standard
    private let scoresKey = "savedScores"
    
    init() {
        loadScores()
    }
    
    func saveScore(_ record: ScoreRecord) {
        scoreHistory.append(record)
        saveScores()
    }
    
    func getRecommendation() -> String {
        guard !scoreHistory.isEmpty else {
            return "Take a practice test to get personalized recommendations!"
        }
        
        // Get the last 3 test results or all if less than 3
        let recentTests = Array(scoreHistory.suffix(3))
        
        // Calculate average performance by category
        var categoryTotals: [String: (correct: Int, total: Int)] = [:]
        
        for test in recentTests {
            for (category, performance) in test.categoryPerformance {
                let current = categoryTotals[category] ?? (correct: 0, total: 0)
                categoryTotals[category] = (
                    correct: current.correct + performance.correct,
                    total: current.total + performance.total
                )
            }
        }
        
        // Find the weakest category
        var weakestCategory = ""
        var lowestPercentage = 100
        
        for (category, totals) in categoryTotals {
            let percentage = totals.total > 0 ? (totals.correct * 100) / totals.total : 100
            if percentage < lowestPercentage {
                lowestPercentage = percentage
                weakestCategory = category
            }
        }
        
        // Check overall performance
        let averageScore = recentTests.reduce(0) { $0 + $1.percentage } / recentTests.count
        
        if averageScore >= 80 {
            return "Great job! You're doing well. Keep practicing to maintain your score."
        } else if lowestPercentage < 60 && !weakestCategory.isEmpty {
            return "Focus on studying: \(weakestCategory). This is your weakest area."
        } else if averageScore >= 60 {
            return "You're making progress! Review all categories to improve your score."
        } else {
            return "Study all categories with flashcards and practice mode to improve."
        }
    }
    
    func getAverageScore() -> Int? {
        guard !scoreHistory.isEmpty else { return nil }
        let total = scoreHistory.reduce(0) { $0 + $1.percentage }
        return total / scoreHistory.count
    }
    
    func getTotalTestsTaken() -> Int {
        return scoreHistory.count
    }
    
    func resetAllScores() {
        scoreHistory.removeAll()
        saveScores()
    }
    
    private func saveScores() {
        if let encoded = try? JSONEncoder().encode(scoreHistory) {
            userDefaults.set(encoded, forKey: scoresKey)
        }
    }
    
    private func loadScores() {
        if let data = userDefaults.data(forKey: scoresKey),
           let decoded = try? JSONDecoder().decode([ScoreRecord].self, from: data) {
            scoreHistory = decoded
        }
    }
}
