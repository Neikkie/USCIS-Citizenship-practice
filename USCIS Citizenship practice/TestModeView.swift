//
//  TestModeView.swift
//  USCIS Citizenship practice
//
//  Created by Shanique Beckford on 2/22/26.
//

import SwiftUI

struct TestModeView: View {
    @ObservedObject var questionService: QuestionService
    @ObservedObject var scoreManager: ScoreManager
    @State private var testQuestions: [Question] = []
    @State private var currentQuestionIndex = 0
    @State private var selectedAnswers: [String?] = []
    @State private var score = 0
    @State private var showingResults = false
    @State private var startTime = Date()
    @Environment(\.dismiss) private var dismiss
    
    private let usRed = Color(red: 178/255, green: 34/255, blue: 52/255)
    private let usBlue = Color(red: 60/255, green: 59/255, blue: 110/255)
    
    var body: some View {
        ZStack {
            // American flag-inspired background
            LinearGradient(
                gradient: Gradient(colors: [usBlue, usRed.opacity(0.3), .white]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            if !showingResults {
                // Test in progress
                VStack(spacing: 0) {
                    // Progress header
                    VStack(spacing: 12) {
                        HStack {
                            Text("Question \(currentQuestionIndex + 1) of \(testQuestions.count)")
                                .font(.headline)
                                .foregroundColor(.white)
                            
                            Spacer()
                            
                            HStack(spacing: 4) {
                                Image(systemName: "clock.fill")
                                    .font(.caption)
                                Text(formatTime(Date().timeIntervalSince(startTime)))
                                    .font(.headline)
                            }
                            .foregroundColor(.white)
                        }
                        .padding(.horizontal)
                        
                        ProgressView(value: Double(currentQuestionIndex + 1), total: Double(testQuestions.count))
                            .tint(.white)
                            .padding(.horizontal)
                    }
                    .padding(.top)
                    .padding(.bottom, 12)
                    .background(usBlue.opacity(0.8))
                    
                    ScrollView {
                        if !testQuestions.isEmpty && currentQuestionIndex < testQuestions.count && currentQuestionIndex < selectedAnswers.count {
                            TestQuestionCard(
                                question: testQuestions[currentQuestionIndex],
                                selectedAnswer: selectedAnswers[currentQuestionIndex],
                                onAnswerSelected: { answer in
                                    selectedAnswers[currentQuestionIndex] = answer
                                },
                                usBlue: usBlue,
                                usRed: usRed
                            )
                            .padding()
                        }
                    }
                    
                    // Navigation buttons
                    HStack(spacing: 16) {
                        if currentQuestionIndex > 0 {
                            Button(action: previousQuestion) {
                                Label("Previous", systemImage: "arrow.left")
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(.white.opacity(0.9))
                                    .foregroundColor(usBlue)
                                    .cornerRadius(12)
                                    .fontWeight(.semibold)
                            }
                        }
                        
                        Button(action: nextQuestion) {
                            Label(
                                currentQuestionIndex < testQuestions.count - 1 ? "Next" : "Submit Test",
                                systemImage: currentQuestionIndex < testQuestions.count - 1 ? "arrow.right" : "checkmark.circle.fill"
                            )
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background((currentQuestionIndex < selectedAnswers.count && selectedAnswers[currentQuestionIndex] != nil) ? usRed : Color.gray.opacity(0.5))
                            .foregroundColor(.white)
                            .cornerRadius(12)
                            .fontWeight(.semibold)
                        }
                        .disabled(currentQuestionIndex >= selectedAnswers.count || selectedAnswers[currentQuestionIndex] == nil)
                    }
                    .padding()
                    .background(.white.opacity(0.1))
                }
            } else {
                // Test results
                TestResultsScreen(
                    score: score,
                    totalQuestions: testQuestions.count,
                    questions: testQuestions,
                    selectedAnswers: selectedAnswers,
                    timeSpent: Date().timeIntervalSince(startTime),
                    usBlue: usBlue,
                    usRed: usRed,
                    onRetake: retakeTest,
                    onDismiss: { dismiss() }
                )
            }
        }
        .navigationTitle("USCIS Test")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(showingResults)
        .toolbarBackground(.visible, for: .navigationBar)
        .toolbarBackground(usBlue, for: .navigationBar)
        .toolbarColorScheme(.dark, for: .navigationBar)
        .onAppear {
            if testQuestions.isEmpty {
                startTest()
            }
        }
    }
    
    private func startTest() {
        // Reset everything - answers reset each time
        testQuestions = questionService.getTestQuestions(count: 10)
        selectedAnswers = Array(repeating: nil, count: testQuestions.count)
        currentQuestionIndex = 0
        score = 0
        showingResults = false
        startTime = Date()
    }
    
    private func nextQuestion() {
        if currentQuestionIndex < testQuestions.count - 1 {
            withAnimation {
                currentQuestionIndex += 1
            }
        } else {
            // Calculate final score
            calculateScore()
            withAnimation {
                showingResults = true
            }
        }
    }
    
    private func previousQuestion() {
        if currentQuestionIndex > 0 {
            withAnimation {
                currentQuestionIndex -= 1
            }
        }
    }
    
    private func calculateScore() {
        score = 0
        var categoryPerformance: [String: CategoryPerformance] = [:]
        
        // Calculate score and track performance by category
        for (index, question) in testQuestions.enumerated() {
            let category = question.category.rawValue
            let isCorrect = selectedAnswers[index] != nil && question.isCorrect(answer: selectedAnswers[index]!)
            
            if isCorrect {
                score += 1
            }
            
            // Track category performance
            let current = categoryPerformance[category] ?? CategoryPerformance(correct: 0, total: 0)
            categoryPerformance[category] = CategoryPerformance(
                correct: current.correct + (isCorrect ? 1 : 0),
                total: current.total + 1
            )
        }
        
        // Save score to history
        let record = ScoreRecord(
            id: UUID(),
            date: Date(),
            score: score,
            totalQuestions: testQuestions.count,
            categoryPerformance: categoryPerformance
        )
        scoreManager.saveScore(record)
    }
    
    private func retakeTest() {
        showingResults = false
        startTest()
    }
    
    private func formatTime(_ interval: TimeInterval) -> String {
        let minutes = Int(interval) / 60
        let seconds = Int(interval) % 60
        return String(format: "%d:%02d", minutes, seconds)
    }
}

// Test question card
struct TestQuestionCard: View {
    let question: Question
    let selectedAnswer: String?
    let onAnswerSelected: (String) -> Void
    let usBlue: Color
    let usRed: Color
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            // Category badge
            HStack {
                Label(question.category.rawValue, systemImage: question.category.icon)
                    .font(.caption)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(.white.opacity(0.9))
                    .foregroundColor(usBlue)
                    .cornerRadius(20)
                
                Spacer()
                
                Text("#\(question.number)")
                    .font(.caption)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(usRed)
                    .cornerRadius(20)
            }
            
            // Question text
            Text(question.question)
                .font(.title3)
                .fontWeight(.semibold)
                .foregroundColor(.white)
                .fixedSize(horizontal: false, vertical: true)
                .padding(.top, 8)
            
            // Answer options
            VStack(spacing: 12) {
                ForEach(question.answers, id: \.self) { answer in
                    Button(action: {
                        onAnswerSelected(answer)
                    }) {
                        HStack {
                            Text(answer)
                                .font(.body)
                                .foregroundColor(.white)
                                .multilineTextAlignment(.leading)
                            
                            Spacer()
                            
                            if selectedAnswer == answer {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundColor(.white)
                            } else {
                                Image(systemName: "circle")
                                    .foregroundColor(.white.opacity(0.5))
                            }
                        }
                        .padding()
                        .background(
                            selectedAnswer == answer ? usBlue.opacity(0.6) : .white.opacity(0.15)
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(selectedAnswer == answer ? .white : .white.opacity(0.3), lineWidth: 2)
                        )
                        .cornerRadius(12)
                    }
                }
            }
            .padding(.top, 8)
        }
        .padding(24)
        .background(.white.opacity(0.15))
        .cornerRadius(16)
        .shadow(color: usBlue.opacity(0.3), radius: 10, y: 5)
    }
}

// Test results screen
struct TestResultsScreen: View {
    let score: Int
    let totalQuestions: Int
    let questions: [Question]
    let selectedAnswers: [String?]
    let timeSpent: TimeInterval
    let usBlue: Color
    let usRed: Color
    let onRetake: () -> Void
    let onDismiss: () -> Void
    
    private var percentage: Double {
        Double(score) / Double(totalQuestions) * 100
    }
    
    private var passed: Bool {
        score >= 6 // USCIS requires 6 out of 10 correct
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // Results header
                VStack(spacing: 16) {
                    Image(systemName: passed ? "checkmark.seal.fill" : "xmark.seal.fill")
                        .font(.system(size: 80))
                        .foregroundStyle(passed ? .green : .red)
                        .shadow(color: .white.opacity(0.3), radius: 4)
                    
                    Text(passed ? "Congratulations!" : "Keep Practicing!")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                    
                    Text(passed ? "You passed the USCIS test!" : "You need 6 or more to pass")
                        .font(.headline)
                        .foregroundColor(.white.opacity(0.9))
                }
                .padding(.top, 40)
                
                // Score card
                VStack(spacing: 20) {
                    HStack(spacing: 40) {
                        VStack(spacing: 8) {
                            Text("\(score)")
                                .font(.system(size: 48, weight: .bold))
                                .foregroundColor(passed ? .green : .red)
                            Text("Correct")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        
                        Divider()
                            .frame(height: 60)
                        
                        VStack(spacing: 8) {
                            Text("\(Int(percentage))%")
                                .font(.system(size: 48, weight: .bold))
                                .foregroundColor(passed ? .green : .red)
                            Text("Score")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        
                        Divider()
                            .frame(height: 60)
                        
                        VStack(spacing: 8) {
                            Text(formatTime(timeSpent))
                                .font(.system(size: 24, weight: .bold))
                                .foregroundColor(usBlue)
                            Text("Time")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                }
                .padding()
                .background(.white.opacity(0.95))
                .cornerRadius(16)
                .shadow(color: usBlue.opacity(0.3), radius: 8, y: 4)
                .padding(.horizontal)
                
                // Pass/Fail indicator
                HStack {
                    Image(systemName: passed ? "checkmark.circle.fill" : "xmark.circle.fill")
                        .foregroundColor(passed ? .green : .red)
                    Text(passed ? "PASSED - Ready for the real test!" : "FAILED - Keep studying")
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                }
                .padding()
                .background(passed ? Color.green.opacity(0.2) : Color.red.opacity(0.2))
                .cornerRadius(12)
                .padding(.horizontal)
                
                // Question review
                VStack(alignment: .leading, spacing: 12) {
                    Text("Review Your Answers")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding(.horizontal)
                    
                    ForEach(Array(questions.enumerated()), id: \.element.id) { index, question in
                        QuestionReviewCard(
                            question: question,
                            selectedAnswer: selectedAnswers[index],
                            questionNumber: index + 1,
                            usBlue: usBlue,
                            usRed: usRed
                        )
                    }
                }
                .padding(.top)
                
                // Action buttons
                VStack(spacing: 12) {
                    Button(action: onRetake) {
                        Label("Retake Test", systemImage: "arrow.counterclockwise")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(usBlue)
                            .foregroundColor(.white)
                            .cornerRadius(12)
                            .fontWeight(.semibold)
                    }
                    
                    Button(action: onDismiss) {
                        Label("Back to Home", systemImage: "house.fill")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(.white.opacity(0.9))
                            .foregroundColor(usBlue)
                            .cornerRadius(12)
                            .fontWeight(.semibold)
                    }
                }
                .padding(.horizontal)
                .padding(.bottom, 32)
            }
        }
    }
    
    private func formatTime(_ interval: TimeInterval) -> String {
        let minutes = Int(interval) / 60
        let seconds = Int(interval) % 60
        return String(format: "%d:%02d", minutes, seconds)
    }
}

// Question review card
struct QuestionReviewCard: View {
    let question: Question
    let selectedAnswer: String?
    let questionNumber: Int
    let usBlue: Color
    let usRed: Color
    
    private var isCorrect: Bool {
        guard let selected = selectedAnswer else { return false }
        return question.isCorrect(answer: selected)
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Question \(questionNumber)")
                    .font(.caption)
                    .fontWeight(.semibold)
                    .foregroundColor(.white.opacity(0.8))
                
                Spacer()
                
                HStack(spacing: 4) {
                    Image(systemName: isCorrect ? "checkmark.circle.fill" : "xmark.circle.fill")
                    Text(isCorrect ? "Correct" : "Incorrect")
                        .font(.caption)
                        .fontWeight(.semibold)
                }
                .foregroundColor(isCorrect ? .green : .red)
            }
            
            Text(question.question)
                .font(.subheadline)
                .fontWeight(.medium)
                .foregroundColor(.white)
            
            if let selected = selectedAnswer {
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Text("Your answer:")
                            .font(.caption)
                            .foregroundColor(.white.opacity(0.7))
                        Text(selected)
                            .font(.caption)
                            .fontWeight(.medium)
                            .foregroundColor(isCorrect ? .green : .red)
                    }
                    
                    if !isCorrect {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Correct answer(s):")
                                .font(.caption)
                                .foregroundColor(.white.opacity(0.7))
                            ForEach(question.correctAnswers, id: \.self) { answer in
                                HStack {
                                    Image(systemName: "checkmark.circle.fill")
                                        .font(.caption)
                                    Text(answer)
                                        .font(.caption)
                                }
                                .foregroundColor(.green)
                            }
                        }
                    }
                }
            }
        }
        .padding()
        .background(.white.opacity(0.15))
        .cornerRadius(12)
        .padding(.horizontal)
    }
}

#Preview {
    NavigationStack {
        TestModeView(questionService: QuestionService(), scoreManager: ScoreManager())
    }
}
