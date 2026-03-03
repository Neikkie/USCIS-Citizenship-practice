//
//  PracticeView.swift
//  USCIS Citizenship practice
//
//  Created by Shanique Beckford on 2/22/26.
//

import SwiftUI

struct PracticeView: View {
    @ObservedObject var questionService: QuestionService
    @State private var currentIndex = 0
    @State private var selectedAnswer: String?
    @State private var showAnswer = false
    @State private var score = 0
    @State private var answeredQuestions: [Int: Bool] = [:] // Track correct/incorrect answers
    @Environment(\.dismiss) private var dismiss
    
    private let usRed = Color(red: 178/255, green: 34/255, blue: 52/255)
    private let usBlue = Color(red: 60/255, green: 59/255, blue: 110/255)
    
    private var currentQuestion: Question {
        questionService.allQuestions[currentIndex]
    }
    
    private var progress: Double {
        Double(currentIndex + 1) / Double(questionService.allQuestions.count)
    }
    
    var body: some View {
        ZStack {
            // American flag-inspired background
            LinearGradient(
                gradient: Gradient(colors: [usBlue, usRed.opacity(0.3), .white]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Progress header
                VStack(spacing: 12) {
                    HStack {
                        Text("Question \(currentIndex + 1) of \(questionService.allQuestions.count)")
                            .font(.headline)
                            .foregroundColor(.white)
                        
                        Spacer()
                        
                        Text("Score: \(score)/\(answeredQuestions.count)")
                            .font(.headline)
                            .foregroundColor(score >= answeredQuestions.count * 6 / 10 ? .green : .white)
                    }
                    .padding(.horizontal)
                    
                    ProgressView(value: progress)
                        .tint(.white)
                        .padding(.horizontal)
                }
                .padding(.top)
                .padding(.bottom, 12)
                .background(usBlue.opacity(0.8))
                
                ScrollView {
                    VStack(spacing: 24) {
                        // Question card
                        VStack(alignment: .leading, spacing: 20) {
                            // Category badge
                            HStack {
                                Label(currentQuestion.category.rawValue, systemImage: currentQuestion.category.icon)
                                    .font(.caption)
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 6)
                                    .background(.white.opacity(0.9))
                                    .foregroundColor(usBlue)
                                    .cornerRadius(20)
                                
                                Spacer()
                                
                                Text("#\(currentQuestion.number)")
                                    .font(.caption)
                                    .fontWeight(.bold)
                                    .foregroundColor(.white)
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 6)
                                    .background(usRed)
                                    .cornerRadius(20)
                            }
                            
                            // Question text
                            Text(currentQuestion.question)
                                .font(.title2)
                                .fontWeight(.semibold)
                                .foregroundColor(.white)
                                .fixedSize(horizontal: false, vertical: true)
                                .padding(.top, 8)
                            
                            // Answer options
                            VStack(spacing: 12) {
                                ForEach(currentQuestion.answers, id: \.self) { answer in
                                    AnswerButton(
                                        answer: answer,
                                        isSelected: selectedAnswer == answer,
                                        isCorrect: currentQuestion.isCorrect(answer: answer),
                                        showAnswer: showAnswer,
                                        usBlue: usBlue,
                                        usRed: usRed
                                    ) {
                                        selectAnswer(answer)
                                    }
                                }
                            }
                            .padding(.top, 8)
                            
                            // Answer explanation
                            if showAnswer {
                                VStack(alignment: .leading, spacing: 12) {
                                    Divider()
                                        .background(.white.opacity(0.5))
                                    
                                    Text("Correct Answer\(currentQuestion.correctAnswers.count > 1 ? "s" : ""):")
                                        .font(.headline)
                                        .foregroundColor(.white)
                                    
                                    ForEach(currentQuestion.correctAnswers, id: \.self) { correctAnswer in
                                        HStack {
                                            Image(systemName: "checkmark.circle.fill")
                                                .foregroundColor(.green)
                                            Text(correctAnswer)
                                                .font(.body)
                                                .foregroundColor(.white)
                                        }
                                        .padding(.vertical, 4)
                                    }
                                    
                                    if currentQuestion.correctAnswers.count > 1 {
                                        Text("Note: Any of these answers is acceptable")
                                            .font(.caption)
                                            .foregroundColor(.white.opacity(0.8))
                                            .italic()
                                            .padding(.top, 4)
                                    }
                                }
                                .padding()
                                .background(.white.opacity(0.2))
                                .cornerRadius(12)
                                .transition(.opacity.combined(with: .move(edge: .top)))
                            }
                        }
                        .padding(24)
                        .background(.white.opacity(0.15))
                        .cornerRadius(16)
                        .shadow(color: usBlue.opacity(0.3), radius: 10, y: 5)
                        .padding(.horizontal)
                        .padding(.top, 20)
                    }
                    .padding(.bottom, 32)
                }
                
                // Navigation buttons
                HStack(spacing: 16) {
                    if currentIndex > 0 {
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
                    
                    if showAnswer {
                        Button(action: nextQuestion) {
                            Label(
                                currentIndex < questionService.allQuestions.count - 1 ? "Next Question" : "Finish",
                                systemImage: currentIndex < questionService.allQuestions.count - 1 ? "arrow.right" : "checkmark.circle.fill"
                            )
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(usBlue)
                            .foregroundColor(.white)
                            .cornerRadius(12)
                            .fontWeight(.semibold)
                        }
                    } else {
                        Button(action: { 
                            withAnimation { 
                                checkAnswer()
                                showAnswer = true 
                            } 
                        }) {
                            Label("Show Answer", systemImage: "eye.fill")
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(selectedAnswer != nil ? usRed : Color.gray)
                                .foregroundColor(.white)
                                .cornerRadius(12)
                                .fontWeight(.semibold)
                        }
                        .disabled(selectedAnswer == nil)
                    }
                }
                .padding()
                .background(.white.opacity(0.05))
            }
        }
        .navigationTitle("Practice All Questions")
        .navigationBarTitleDisplayMode(.inline)
        .toolbarBackground(.visible, for: .navigationBar)
        .toolbarBackground(usBlue, for: .navigationBar)
        .toolbarColorScheme(.dark, for: .navigationBar)
        .alert("Practice Complete!", isPresented: .constant(currentIndex >= questionService.allQuestions.count - 1 && showAnswer)) {
            Button("Review") {
                currentIndex = 0
                selectedAnswer = nil
                showAnswer = false
            }
            Button("Home") {
                dismiss()
            }
        } message: {
            Text("You've completed all \(questionService.allQuestions.count) questions!\n\nFinal Score: \(score)/\(answeredQuestions.count) (\(Int(Double(score) / Double(max(answeredQuestions.count, 1)) * 100))%)")
        }
    }
    
    private func selectAnswer(_ answer: String) {
        selectedAnswer = answer
    }
    
    private func nextQuestion() {
        if currentIndex < questionService.allQuestions.count - 1 {
            withAnimation {
                currentIndex += 1
                selectedAnswer = nil
                showAnswer = false
            }
        } else {
            // Show completion alert
        }
    }
    
    private func previousQuestion() {
        if currentIndex > 0 {
            withAnimation {
                currentIndex -= 1
                selectedAnswer = answeredQuestions[currentIndex] != nil ? currentQuestion.answers.first(where: { currentQuestion.isCorrect(answer: $0) }) : nil
                showAnswer = false
            }
        }
    }
    
    private func checkAnswer() {
        guard let selected = selectedAnswer else { return }
        
        let isCorrect = currentQuestion.isCorrect(answer: selected)
        answeredQuestions[currentIndex] = isCorrect
        
        if isCorrect {
            score += 1
        }
    }
}

// Answer button component
struct AnswerButton: View {
    let answer: String
    let isSelected: Bool
    let isCorrect: Bool
    let showAnswer: Bool
    let usBlue: Color
    let usRed: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: {
            if !showAnswer {
                action()
            }
        }) {
            HStack {
                Text(answer)
                    .font(.body)
                    .foregroundColor(textColor)
                    .multilineTextAlignment(.leading)
                
                Spacer()
                
                if showAnswer {
                    if isCorrect {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundColor(.green)
                    } else if isSelected && !isCorrect {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.red)
                    }
                } else if isSelected {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(usBlue)
                } else {
                    Image(systemName: "circle")
                        .foregroundColor(.white.opacity(0.5))
                }
            }
            .padding()
            .background(backgroundColor)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(borderColor, lineWidth: 2)
            )
            .cornerRadius(12)
        }
        .disabled(showAnswer)
    }
    
    private var backgroundColor: Color {
        if showAnswer {
            if isCorrect {
                return .green.opacity(0.2)
            } else if isSelected && !isCorrect {
                return .red.opacity(0.2)
            }
        } else if isSelected {
            return usBlue.opacity(0.3)
        }
        return .white.opacity(0.15)
    }
    
    private var borderColor: Color {
        if showAnswer {
            if isCorrect {
                return .green
            } else if isSelected && !isCorrect {
                return .red
            }
        } else if isSelected {
            return usBlue
        }
        return .white.opacity(0.3)
    }
    
    private var textColor: Color {
        if showAnswer {
            if isCorrect || (isSelected && !isCorrect) {
                return .white
            }
        }
        return .white
    }
}

#Preview {
    NavigationStack {
        PracticeView(questionService: QuestionService())
    }
}
