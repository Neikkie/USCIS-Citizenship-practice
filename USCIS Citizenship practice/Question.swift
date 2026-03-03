//
//  Question.swift
//  USCIS Citizenship practice
//
//  Created by Shanique Beckford on 2/22/26.
//

import Foundation

// Represents a USCIS civics question
struct Question: Identifiable, Codable {
    let id: UUID
    let number: Int
    let question: String
    let answers: [String]
    let correctAnswers: [String] // Some questions have multiple acceptable answers
    let category: QuestionCategory
    
    init(id: UUID = UUID(), number: Int, question: String, answers: [String], correctAnswers: [String], category: QuestionCategory) {
        self.id = id
        self.number = number
        self.question = question
        self.answers = answers
        self.correctAnswers = correctAnswers
        self.category = category
    }
    
    // Check if a given answer is correct
    func isCorrect(answer: String) -> Bool {
        return correctAnswers.contains(answer)
    }
}

// Categories based on USCIS civics test structure
enum QuestionCategory: String, Codable, CaseIterable {
    case americanGovernment = "American Government"
    case americanHistory = "American History"
    case integratedCivics = "Integrated Civics (Geography, Symbols, Holidays)"
    
    var icon: String {
        switch self {
        case .americanGovernment:
            return "building.columns.fill"
        case .americanHistory:
            return "book.fill"
        case .integratedCivics:
            return "globe.americas.fill"
        }
    }
}

// Test result model for tracking user performance
struct TestResult: Identifiable, Codable {
    let id: UUID
    let date: Date
    let score: Int
    let totalQuestions: Int
    let timeSpent: TimeInterval
    let questionsAsked: [Int] // Question numbers
    
    var percentage: Double {
        return Double(score) / Double(totalQuestions) * 100
    }
    
    var passed: Bool {
        return score >= 6 // USCIS requires 6 out of 10 correct
    }
}
