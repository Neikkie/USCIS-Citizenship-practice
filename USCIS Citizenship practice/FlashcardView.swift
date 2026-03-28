//
//  FlashcardView.swift
//  USCIS Citizenship practice
//
//  Created by Shanique Beckford on 2/22/26.
//

import SwiftUI
import GoogleMobileAds

struct FlashcardView: View {
    @ObservedObject var questionService: QuestionService
    @ObservedObject var stateManager: StateManager
    @State private var currentIndex = 0
    @State private var isShowingAnswer = false
    @State private var offset = CGSize.zero
    @State private var rotation: Double = 0
    @State private var shuffledQuestions: [Question] = []
    @Environment(\.dismiss) private var dismiss
    
    private let usRed = Color(red: 178/255, green: 34/255, blue: 52/255)
    private let usBlue = Color(red: 60/255, green: 59/255, blue: 110/255)
    
    private var currentQuestion: Question {
        shuffledQuestions.isEmpty ? questionService.allQuestions[currentIndex] : shuffledQuestions[currentIndex]
    }
    
    private var questionCount: Int {
        shuffledQuestions.isEmpty ? questionService.allQuestions.count : shuffledQuestions.count
    }
    
    var body: some View {
        ZStack {
            // Solid background for better readability
            usBlue.opacity(0.15)
                .ignoresSafeArea()
            
            VStack(spacing: 20) {
                // Progress indicator
                HStack {
                    Text("Card \(currentIndex + 1) of \(questionCount)")
                        .font(.headline)
                        .foregroundColor(.primary)
                    
                    Spacer()
                    
                    Button(action: {
                        shuffledQuestions = questionService.allQuestions.shuffled()
                        currentIndex = 0
                        isShowingAnswer = false
                    }) {
                        Label("Shuffle", systemImage: "shuffle")
                            .font(.subheadline)
                            .foregroundColor(.white)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(usBlue)
                            .cornerRadius(20)
                    }
                }
                .padding(.horizontal)
                .padding(.top)
                
                // Progress bar
                ProgressView(value: Double(currentIndex + 1), total: Double(questionCount))
                    .tint(usBlue)
                    .padding(.horizontal)
                
                Spacer()
                
                // Flashcard
                FlashcardContentView(
                    question: currentQuestion,
                    isShowingAnswer: $isShowingAnswer,
                    usRed: usRed,
                    usBlue: usBlue,
                    stateManager: stateManager
                )
                .padding(.horizontal, 20)
                
                Spacer()
                
                // Controls
                HStack(spacing: 40) {
                    Button(action: previousCard) {
                        Image(systemName: "arrow.left.circle.fill")
                            .font(.system(size: 50))
                            .foregroundStyle(usBlue)
                            .shadow(color: usBlue.opacity(0.3), radius: 2)
                    }
                    .disabled(currentIndex == 0)
                    .opacity(currentIndex == 0 ? 0.3 : 1.0)
                    
                    Button(action: { 
                        withAnimation(.spring(response: 0.6, dampingFraction: 0.7)) {
                            isShowingAnswer.toggle()
                        }
                    }) {
                        Image(systemName: isShowingAnswer ? "eye.slash.fill" : "eye.fill")
                            .font(.system(size: 50))
                            .foregroundStyle(usRed)
                            .shadow(color: usRed.opacity(0.3), radius: 2)
                    }
                    
                    Button(action: nextCard) {
                        Image(systemName: "arrow.right.circle.fill")
                            .font(.system(size: 50))
                            .foregroundStyle(usBlue)
                            .shadow(color: usBlue.opacity(0.3), radius: 2)
                    }
                    .disabled(currentIndex >= questionCount - 1)
                    .opacity(currentIndex >= questionCount - 1 ? 0.3 : 1.0)
                }
                .padding(.bottom, 40)
                
                BannerViewContainer(bannerAdType: .flashCardAd)
                .frame(height: 50)
            }
        }
        .navigationTitle("Flashcards")
        .navigationBarTitleDisplayMode(.inline)
        .toolbarBackground(.visible, for: .navigationBar)
        .toolbarBackground(usBlue, for: .navigationBar)
        .toolbarColorScheme(.dark, for: .navigationBar)
        .onAppear {
            if shuffledQuestions.isEmpty {
                shuffledQuestions = questionService.allQuestions
            }
        }
    }
    
    private func nextCard() {
        if currentIndex < questionCount - 1 {
            withAnimation(.spring()) {
                currentIndex += 1
                isShowingAnswer = false
            }
        }
    }
    
    private func previousCard() {
        if currentIndex > 0 {
            withAnimation(.spring()) {
                currentIndex -= 1
                isShowingAnswer = false
            }
        }
    }
}

// Flashcard content with flip animation
struct FlashcardContentView: View {
    let question: Question
    @Binding var isShowingAnswer: Bool
    let usRed: Color
    let usBlue: Color
    @ObservedObject var stateManager: StateManager
    
    var body: some View {
        ZStack {
            // Card background
            RoundedRectangle(cornerRadius: 20)
                .fill(
                    LinearGradient(
                        gradient: Gradient(colors: [
                            isShowingAnswer ? usRed.opacity(0.8) : usBlue.opacity(0.8),
                            isShowingAnswer ? usRed : usBlue
                        ]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .shadow(color: .black.opacity(0.3), radius: 15, x: 0, y: 10)
            
            VStack(spacing: 20) {
                // Category badge
                HStack {
                    Label(question.category.rawValue, systemImage: question.category.icon)
                        .font(.caption)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(.black.opacity(0.3))
                        .foregroundColor(.white)
                        .cornerRadius(20)
                    
                    Spacer()
                    
                    Text("#\(question.number)")
                        .font(.caption)
                        .fontWeight(.bold)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(.black.opacity(0.3))
                        .foregroundColor(.white)
                        .cornerRadius(20)
                }
                
                Spacer()
                
                // Question or Answer
                VStack(spacing: 16) {
                    if !isShowingAnswer {
                        // Question side
                        VStack(spacing: 12) {
                            Image(systemName: "questionmark.circle.fill")
                                .font(.system(size: 40))
                                .foregroundColor(.white.opacity(0.8))
                            
                            Text("Question")
                                .font(.caption)
                                .fontWeight(.semibold)
                                .foregroundColor(.white.opacity(0.8))
                                .textCase(.uppercase)
                                .tracking(2)
                            
                            Text(question.question)
                                .font(.title2)
                                .fontWeight(.semibold)
                                .multilineTextAlignment(.center)
                                .foregroundColor(.white)
                                .padding(.horizontal)
                        }
                    } else {
                        // Answer side
                        VStack(spacing: 12) {
                            Image(systemName: "checkmark.seal.fill")
                                .font(.system(size: 40))
                                .foregroundColor(.white.opacity(0.8))
                            
                            Text("Answer")
                                .font(.caption)
                                .fontWeight(.semibold)
                                .foregroundColor(.white.opacity(0.8))
                                .textCase(.uppercase)
                                .tracking(2)
                            
                            VStack(alignment: .center, spacing: 12) {
                                ForEach(question.getCorrectAnswers(stateManager: stateManager), id: \.self) { answer in
                                    HStack {
                                        Image(systemName: "star.fill")
                                            .foregroundColor(.white)
                                            .font(.caption)
                                        Text(answer)
                                            .font(.title3)
                                            .fontWeight(.medium)
                                            .foregroundColor(.white)
                                            .multilineTextAlignment(.center)
                                    }
                                }
                            }
                            .padding(.horizontal)
                            
                            if question.correctAnswers.count > 1 {
                                Text("Any answer is acceptable")
                                    .font(.caption)
                                    .foregroundColor(.white.opacity(0.7))
                                    .italic()
                                    .padding(.top, 4)
                            }
                        }
                        .rotation3DEffect(
                            .degrees(180),
                            axis: (x: 0, y: 1, z: 0)
                        )
                    }
                }
                
                Spacer()
                
                // Tap instruction with pulsing animation
                HStack(spacing: 8) {
                    Image(systemName: "hand.tap.fill")
                        .font(.caption)
                    Text(isShowingAnswer ? "Tap to see question" : "Tap to reveal answer")
                        .font(.caption)
                }
                .foregroundColor(.white.opacity(0.7))
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(.black.opacity(0.3))
                .cornerRadius(20)
            }
            .padding(30)
        }
        .frame(height: 500)
        .rotation3DEffect(
            .degrees(isShowingAnswer ? 180 : 0),
            axis: (x: 0, y: 1, z: 0),
            perspective: 0.5
        )
        .onTapGesture {
            withAnimation(.spring(response: 0.6, dampingFraction: 0.7)) {
                isShowingAnswer.toggle()
            }
        }
    }
}

#Preview {
    NavigationStack {
        FlashcardView(questionService: QuestionService(), stateManager: StateManager())
    }
}
