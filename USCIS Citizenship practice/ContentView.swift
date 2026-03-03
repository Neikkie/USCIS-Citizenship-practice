//
//  ContentView.swift
//  USCIS Citizenship practice
//
//  Created by Shanique Beckford on 2/22/26.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var questionService = QuestionService()
    @StateObject private var scoreManager = ScoreManager()
    @StateObject private var appearanceManager = AppearanceManager()
    @State private var showingDisclaimer = true
    @State private var showingSettings = false
    
    // US Flag colors
    private let usRed = Color(red: 178/255, green: 34/255, blue: 52/255)
    private let usBlue = Color(red: 60/255, green: 59/255, blue: 110/255)
    
    var body: some View {
        NavigationStack {
            ZStack {
                // Clean white background
                Color.white
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 20) {
                        // Header
                        VStack(spacing: 8) {
                            Image(systemName: "star.circle.fill")
                                .font(.system(size: 50))
                                .foregroundStyle(usBlue)
                            
                            Text("USCIS Citizenship")
                                .font(.system(size: 26, weight: .bold))
                                .foregroundColor(usBlue)
                            
                            Text("Practice & Study Guide")
                                .font(.headline)
                                .foregroundColor(.primary)
                            
                            Text("All 100 Official Questions • 2026")
                                .font(.caption)
                                .foregroundColor(.secondary)
                                .padding(.top, 2)
                        }
                        .padding(.top, 20)
                        
                        // Test Overview card
                        VStack(spacing: 14) {
                            Text("📊 Test Overview")
                                .font(.system(size: 17, weight: .semibold))
                                .foregroundColor(.primary)
                            
                            HStack(spacing: 12) {
                                StatItemView(
                                    value: "\(questionService.allQuestions.count)",
                                    label: "Total Questions",
                                    color: usBlue
                                )
                                
                                Divider()
                                    .frame(height: 40)
                                
                                StatItemView(
                                    value: "\(QuestionCategory.allCases.count)",
                                    label: "Categories",
                                    color: .orange
                                )
                                
                                Divider()
                                    .frame(height: 40)
                                
                                StatItemView(
                                    value: "6/10",
                                    label: "To Pass",
                                    color: .green
                                )
                            }
                        }
                        .padding(.vertical, 20)
                        .padding(.horizontal, 20)
                        .background(.thickMaterial)
                        .clipShape(RoundedRectangle(cornerRadius: 18))
                        .shadow(color: Color.black.opacity(0.1), radius: 10, y: 4)
                        .padding(.horizontal, 20)
                        
                        // Your Statistics card (if user has taken tests)
                        if scoreManager.getTotalTestsTaken() > 0 {
                            VStack(spacing: 14) {
                                Text("📈 Your Statistics")
                                    .font(.system(size: 17, weight: .semibold))
                                    .foregroundColor(.primary)
                                
                                HStack(spacing: 12) {
                                    StatItemView(
                                        value: "\(scoreManager.getTotalTestsTaken())",
                                        label: "Tests Taken",
                                        color: usBlue
                                    )
                                    
                                    Divider()
                                        .frame(height: 40)
                                    
                                    if let avgScore = scoreManager.getAverageScore() {
                                        StatItemView(
                                            value: "\(avgScore)%",
                                            label: "Average Score",
                                            color: avgScore >= 60 ? .green : .orange
                                        )
                                    }
                                }
                            }
                            .padding(.vertical, 20)
                            .padding(.horizontal, 20)
                            .background(.thickMaterial)
                            .clipShape(RoundedRectangle(cornerRadius: 18))
                            .shadow(color: Color.black.opacity(0.1), radius: 10, y: 4)
                            .padding(.horizontal, 20)
                        }
                        
                        // Test History Section (Always Visible)
                        VStack(alignment: .leading, spacing: 12) {
                            HStack {
                                Text("📝 Test History")
                                    .font(.system(size: 17, weight: .semibold))
                                    .foregroundColor(.primary)
                                Spacer()
                            }
                            .padding(.horizontal, 20)
                            
                            if scoreManager.scoreHistory.isEmpty {
                                // Empty state
                                VStack(spacing: 12) {
                                    Image(systemName: "doc.text.fill")
                                        .font(.system(size: 40))
                                        .foregroundColor(.secondary)
                                    
                                    Text("No tests taken yet")
                                        .font(.system(size: 15, weight: .medium))
                                        .foregroundColor(.primary)
                                    
                                    Text("Take a practice test to see your results here")
                                        .font(.system(size: 13))
                                        .foregroundColor(.secondary)
                                        .multilineTextAlignment(.center)
                                }
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 30)
                                .padding(.horizontal, 20)
                                .background(.thickMaterial)
                                .clipShape(RoundedRectangle(cornerRadius: 16))
                                .padding(.horizontal, 20)
                            } else {
                                VStack(spacing: 10) {
                                    ForEach(scoreManager.scoreHistory.reversed().prefix(3)) { record in
                                        CompactScoreHistoryRow(record: record, usBlue: usBlue, usRed: usRed)
                                    }
                                    
                                    if scoreManager.getTotalTestsTaken() > 3 {
                                        NavigationLink(destination: ScoreHistoryView(scoreManager: scoreManager)) {
                                            HStack {
                                                Text("View All History")
                                                    .font(.system(size: 14, weight: .semibold))
                                                    .foregroundColor(.purple)
                                                Spacer()
                                                Image(systemName: "chevron.right")
                                                    .font(.caption)
                                                    .foregroundColor(.secondary)
                                            }
                                            .padding(16)
                                            .background(.ultraThinMaterial)
                                            .clipShape(RoundedRectangle(cornerRadius: 12))
                                        }
                                    }
                                }
                                .padding(.horizontal, 20)
                            }
                        }
                        
                        // Section title
                        HStack {
                            Text("Choose Your Study Method")
                                .font(.headline)
                                .fontWeight(.bold)
                                .foregroundColor(.primary)
                            Spacer()
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 4)
                        
                        // Recommendation card (if available)
                        if scoreManager.getTotalTestsTaken() > 0 {
                            VStack(alignment: .leading, spacing: 10) {
                                HStack {
                                    Image(systemName: "lightbulb.fill")
                                        .foregroundColor(.orange)
                                        .font(.system(size: 18))
                                    Text("Recommendation")
                                        .font(.system(size: 16, weight: .semibold))
                                        .foregroundColor(.primary)
                                }
                                
                                Text(scoreManager.getRecommendation())
                                    .font(.system(size: 14))
                                    .foregroundColor(.primary)
                                    .opacity(0.8)
                                
                                if let avgScore = scoreManager.getAverageScore() {
                                    HStack {
                                        Text("Average Score:")
                                            .font(.system(size: 13))
                                            .foregroundColor(.primary)
                                            .opacity(0.7)
                                        Text("\(avgScore)%")
                                            .font(.system(size: 13, weight: .bold))
                                            .foregroundColor(avgScore >= 60 ? .green : .orange)
                                        
                                        Spacer()
                                        
                                        Text("Tests Taken: \(scoreManager.getTotalTestsTaken())")
                                            .font(.system(size: 13))
                                            .foregroundColor(.primary)
                                            .opacity(0.7)
                                    }
                                    .padding(.top, 4)
                                }
                            }
                            .padding(18)
                            .background(.thickMaterial)
                            .clipShape(RoundedRectangle(cornerRadius: 16))
                            .overlay(
                                RoundedRectangle(cornerRadius: 16)
                                    .strokeBorder(Color.orange.opacity(0.3), lineWidth: 1)
                            )
                            .padding(.horizontal, 20)
                        }
                        
                        // Action buttons with Liquid Glass container
                        GlassEffectContainer(spacing: 20.0) {
                            VStack(spacing: 12) {
                                // Categories button
                                NavigationLink(destination: CategorySelectionView(questionService: questionService)) {
                                    StudyMethodCard(
                                        icon: "folder.fill",
                                        title: "Study by Category",
                                        description: "Browse by Government, History & Civics",
                                        color: .orange
                                    )
                                }

                                
                                // Flashcards button
                                NavigationLink(destination: FlashcardView(questionService: questionService)) {
                                    StudyMethodCard(
                                        icon: "rectangle.stack.fill",
                                        title: "Flashcards",
                                        description: "Flip cards to memorize answers",
                                        color: usBlue
                                    )
                                }
                                
                                // Practice All Questions button
                                NavigationLink(destination: PracticeView(questionService: questionService)) {
                                    StudyMethodCard(
                                        icon: "book.fill",
                                        title: "Practice Mode",
                                        description: "Study all 100 questions with instant feedback",
                                        color: .purple
                                    )
                                }
                                
                                // Test Mode button (10 random questions)
                                NavigationLink(destination: TestModeView(questionService: questionService, scoreManager: scoreManager)) {
                                    StudyMethodCard(
                                        icon: "checkmark.seal.fill",
                                        title: "Practice Test",
                                        description: "10 random questions • Get your score",
                                        color: usRed
                                    )
                                }
                            }
                            .padding(.horizontal, 20)
                        }
                    }
                    .padding(.bottom, 32)
                }
            }
            .navigationBarHidden(false)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: {
                        showingSettings = true
                    }) {
                        Image(systemName: "gear")
                            .foregroundColor(usBlue)
                    }
                }
            }
            .alert("Important Disclaimer", isPresented: $showingDisclaimer) {
                Button("I Understand", role: .cancel) { }
            } message: {
                Text("This app is solely for practice purposes using 2026 USCIS questions. While we strive for accuracy, this app cannot guarantee that you will pass your citizenship exam. Please use official USCIS resources for the most up-to-date information.")
            }
            .sheet(isPresented: $showingSettings) {
                SettingsView(scoreManager: scoreManager, appearanceManager: appearanceManager)
            }
            .preferredColorScheme(appearanceManager.appearanceMode.colorScheme)
        }
    }
}

// Study method card component with Liquid Glass
struct StudyMethodCard: View {
    let icon: String
    let title: String
    let description: String
    let color: Color
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        HStack(spacing: 14) {
            // Icon with Liquid Glass effect
            ZStack {
                Circle()
                    .fill(color.opacity(0.2))
                    .frame(width: 48, height: 48)
                
                Image(systemName: icon)
                    .font(.system(size: 22))
                    .foregroundStyle(.white)
            }
            .background(
                Circle()
                    .fill(color)
                    .frame(width: 48, height: 48)
            )
            .glassEffect(.regular.tint(color))
            
            // Text content
            VStack(alignment: .leading, spacing: 5) {
                Text(title)
                    .font(.system(size: 17, weight: .semibold))
                    .foregroundColor(colorScheme == .dark ? .white : .black)
                
                Text(description)
                    .font(.system(size: 13))
                    .foregroundColor(colorScheme == .dark ? Color(white: 0.8) : Color(white: 0.3))
                    .lineLimit(2)
                    .fixedSize(horizontal: false, vertical: true)
            }
            
            Spacer(minLength: 8)
            
            // Arrow
            Image(systemName: "chevron.right")
                .font(.system(size: 15, weight: .semibold))
                .foregroundColor(colorScheme == .dark ? Color(white: 0.7) : Color(white: 0.4))
        }
        .padding(18)
        .background(.thickMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .strokeBorder(color.opacity(0.3), lineWidth: 1)
        )
        .glassEffect(.regular.tint(color).interactive(), in: .rect(cornerRadius: 16))
    }
}

// Statistics item view
struct StatItemView: View {
    let value: String
    let label: String
    var color: Color = Color.blue
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        VStack(spacing: 8) {
            Text(value)
                .font(.system(size: 32, weight: .bold))
                .foregroundColor(color)
            
            Text(label)
                .font(.system(size: 12, weight: .semibold))
                .foregroundColor(colorScheme == .dark ? Color(white: 0.7) : Color(white: 0.4))
                .multilineTextAlignment(.center)
                .lineLimit(2)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 8)
    }
}

// Compact Score History Row for home screen
struct CompactScoreHistoryRow: View {
    let record: ScoreRecord
    let usBlue: Color
    let usRed: Color
    @State private var showingDetail = false
    
    var body: some View {
        Button(action: {
            showingDetail = true
        }) {
            HStack(spacing: 12) {
                // Pass/Fail indicator
                ZStack {
                    Circle()
                        .fill(record.passed ? Color.green.opacity(0.15) : Color.red.opacity(0.15))
                        .frame(width: 44, height: 44)
                    
                    Image(systemName: record.passed ? "checkmark.circle.fill" : "xmark.circle.fill")
                        .font(.system(size: 22))
                        .foregroundColor(record.passed ? .green : .red)
                }
                
                // Date and score info
                VStack(alignment: .leading, spacing: 4) {
                    Text(formatDate(record.date))
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(.primary)
                    
                    Text("\(record.score)/\(record.totalQuestions) correct")
                        .font(.system(size: 12))
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                // Percentage
                VStack(alignment: .trailing, spacing: 4) {
                    Text("\(record.percentage)%")
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(record.passed ? .green : .red)
                    
                    Text(record.passed ? "PASSED" : "FAILED")
                        .font(.system(size: 10, weight: .semibold))
                        .foregroundColor(record.passed ? .green : .red)
                }
                
                Image(systemName: "chevron.right")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            .padding(16)
            .background(.thickMaterial)
            .clipShape(RoundedRectangle(cornerRadius: 14))
            .overlay(
                RoundedRectangle(cornerRadius: 14)
                    .strokeBorder((record.passed ? Color.green : Color.red).opacity(0.2), lineWidth: 1)
            )
        }
        .buttonStyle(.plain)
        .sheet(isPresented: $showingDetail) {
            ScoreDetailView(record: record, usBlue: usBlue, usRed: usRed)
        }
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}

#Preview {
    ContentView()
}
