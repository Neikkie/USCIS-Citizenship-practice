//
//  CategorySelectionView.swift
//  USCIS Citizenship practice
//
//  Created by Shanique Beckford on 2/22/26.
//

import SwiftUI

struct CategorySelectionView: View {
    @ObservedObject var questionService: QuestionService
    @ObservedObject var stateManager: StateManager
    
    private let usRed = Color(red: 178/255, green: 34/255, blue: 52/255)
    private let usBlue = Color(red: 60/255, green: 59/255, blue: 110/255)
    
    var body: some View {
        ZStack {
            // Solid background for better readability
            usBlue.opacity(0.15)
                .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 24) {
                    // Header
                    VStack(spacing: 8) {
                        Image(systemName: "folder.fill")
                            .font(.system(size: 50))
                            .foregroundStyle(usBlue)
                            .shadow(color: usBlue.opacity(0.3), radius: 2)
                        
                        Text("Study by Category")
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(.primary)
                        
                        Text("Focus on specific topics")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    .padding(.top, 20)
                    
                    // Category cards
                    VStack(spacing: 16) {
                        ForEach(QuestionCategory.allCases, id: \.self) { category in
                            NavigationLink(destination: CategoryDetailView(
                                category: category,
                                questions: questionService.getQuestions(by: category),
                                questionService: questionService,
                                stateManager: stateManager
                            )) {
                                CategoryCard(
                                    category: category,
                                    questionCount: questionService.getQuestions(by: category).count,
                                    usBlue: usBlue,
                                    usRed: usRed
                                )
                            }
                        }
                    }
                    .padding(.horizontal)
                }
                .padding(.bottom, 32)
            }
        }
        .navigationTitle("Categories")
        .navigationBarTitleDisplayMode(.inline)
        .toolbarBackground(.visible, for: .navigationBar)
        .toolbarBackground(usBlue, for: .navigationBar)
        .toolbarColorScheme(.dark, for: .navigationBar)
    }
}

// Category card component
struct CategoryCard: View {
    let category: QuestionCategory
    let questionCount: Int
    let usBlue: Color
    let usRed: Color
    
    private var categoryColor: Color {
        switch category {
        case .americanGovernment:
            return usBlue
        case .americanHistory:
            return usRed
        case .integratedCivics:
            return .purple
        }
    }
    
    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: category.icon)
                .font(.system(size: 36))
                .foregroundStyle(.white)
                .frame(width: 70, height: 70)
                .background(categoryColor)
                .cornerRadius(12)
            
            VStack(alignment: .leading, spacing: 6) {
                Text(category.rawValue)
                    .font(.headline)
                    .foregroundColor(.primary)
                
                Text("\(questionCount) questions")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .foregroundColor(.secondary)
        }
        .padding()
        .background(Color(UIColor.secondarySystemGroupedBackground))
        .cornerRadius(12)
        .shadow(color: categoryColor.opacity(0.3), radius: 8, y: 4)
    }
}

// Category detail view with questions
struct CategoryDetailView: View {
    let category: QuestionCategory
    let questions: [Question]
    @ObservedObject var questionService: QuestionService
    @ObservedObject var stateManager: StateManager
    
    @State private var selectedQuestionIndex: Int?
    @State private var showingAnswer = false
    @State private var searchText = ""
    
    private let usRed = Color(red: 178/255, green: 34/255, blue: 52/255)
    private let usBlue = Color(red: 60/255, green: 59/255, blue: 110/255)
    
    private var categoryColor: Color {
        switch category {
        case .americanGovernment:
            return usBlue
        case .americanHistory:
            return usRed
        case .integratedCivics:
            return .purple
        }
    }
    
    private var filteredQuestions: [Question] {
        if searchText.isEmpty {
            return questions
        }
        return questions.filter { question in
            question.question.localizedCaseInsensitiveContains(searchText) ||
            question.correctAnswers.contains { $0.localizedCaseInsensitiveContains(searchText) }
        }
    }
    
    var body: some View {
        ZStack {
            // Solid background for better readability
            categoryColor.opacity(0.15)
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Category header
                VStack(spacing: 12) {
                    HStack {
                        Image(systemName: category.icon)
                            .font(.system(size: 40))
                            .foregroundStyle(categoryColor)
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text(category.rawValue)
                                .font(.title3)
                                .fontWeight(.bold)
                                .foregroundColor(.primary)
                            
                            Text("\(filteredQuestions.count) questions")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                        
                        Spacer()
                    }
                    .padding()
                    
                    // Search bar
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.secondary)
                        TextField("Search questions...", text: $searchText)
                            .foregroundColor(.primary)
                            .tint(categoryColor)
                        
                        if !searchText.isEmpty {
                            Button(action: { searchText = "" }) {
                                Image(systemName: "xmark.circle.fill")
                                    .foregroundColor(.secondary)
                            }
                        }
                    }
                    .padding()
                    .background(Color(UIColor.secondarySystemGroupedBackground))
                    .cornerRadius(10)
                    .padding(.horizontal)
                }
                .background(categoryColor.opacity(0.8))
                .padding(.bottom, 8)
                
                // Questions list
                ScrollView {
                    LazyVStack(spacing: 12) {
                        ForEach(Array(filteredQuestions.enumerated()), id: \.element.id) { index, question in
                            Button(action: {
                                selectedQuestionIndex = index
                                showingAnswer = false
                            }) {
                                QuestionListItem(
                                    question: question,
                                    categoryColor: categoryColor
                                )
                            }
                        }
                    }
                    .padding()
                }
            }
        }
        .navigationTitle(category.rawValue)
        .navigationBarTitleDisplayMode(.inline)
        .toolbarBackground(.visible, for: .navigationBar)
        .toolbarBackground(categoryColor, for: .navigationBar)
        .toolbarColorScheme(.dark, for: .navigationBar)
        .sheet(isPresented: Binding(
            get: { selectedQuestionIndex != nil },
            set: { if !$0 { selectedQuestionIndex = nil } }
        )) {
            if let index = selectedQuestionIndex {
                QuestionDetailSheet(
                    questions: filteredQuestions,
                    currentIndex: Binding(
                        get: { index },
                        set: { selectedQuestionIndex = $0 }
                    ),
                    showingAnswer: $showingAnswer,
                    categoryColor: categoryColor,
                    stateManager: stateManager
                )
            }
        }
    }
}

// Question list item
struct QuestionListItem: View {
    let question: Question
    let categoryColor: Color
    
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Text("#\(question.number)")
                .font(.caption)
                .fontWeight(.bold)
                .foregroundColor(.white)
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .background(categoryColor)
                .cornerRadius(6)
            
            Text(question.question)
                .font(.subheadline)
                .foregroundColor(.primary)
                .multilineTextAlignment(.leading)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            Image(systemName: "chevron.right")
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .padding()
        .background(Color(UIColor.tertiarySystemGroupedBackground))
        .cornerRadius(10)
    }
}

// Question detail sheet
struct QuestionDetailSheet: View {
    let questions: [Question]
    @Binding var currentIndex: Int
    @Binding var showingAnswer: Bool
    let categoryColor: Color
    @ObservedObject var stateManager: StateManager
    @Environment(\.dismiss) private var dismiss
    
    private var question: Question {
        questions[currentIndex]
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                // Solid background for better readability
                categoryColor.opacity(0.15)
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(alignment: .leading, spacing: 24) {
                        // Question number badge
                        HStack {
                            Text("Question #\(question.number)")
                                .font(.caption)
                                .fontWeight(.semibold)
                                .foregroundColor(.white)
                                .padding(.horizontal, 12)
                                .padding(.vertical, 6)
                                .background(categoryColor)
                                .cornerRadius(20)
                            
                            Spacer()
                            
                            Label(question.category.rawValue, systemImage: question.category.icon)
                                .font(.caption)
                                .foregroundColor(.white)
                                .padding(.horizontal, 12)
                                .padding(.vertical, 6)
                                .background(categoryColor)
                                .cornerRadius(20)
                        }
                        
                        // Question
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Question")
                                .font(.caption)
                                .foregroundColor(.secondary)
                                .textCase(.uppercase)
                            
                            Text(question.question)
                                .font(.title3)
                                .fontWeight(.semibold)
                                .foregroundColor(.primary)
                        }
                        
                        Divider()
                            .background(Color.secondary.opacity(0.5))
                        
                        // Answer section
                        VStack(alignment: .leading, spacing: 12) {
                            HStack {
                                Text("Answer")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                                    .textCase(.uppercase)
                                
                                Spacer()
                                
                                Button(action: {
                                    withAnimation {
                                        showingAnswer.toggle()
                                    }
                                }) {
                                    Label(
                                        showingAnswer ? "Hide" : "Show",
                                        systemImage: showingAnswer ? "eye.slash.fill" : "eye.fill"
                                    )
                                    .font(.caption)
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 6)
                                    .background(categoryColor)
                                    .foregroundColor(.white)
                                    .cornerRadius(20)
                                }
                            }
                            
                            if showingAnswer {
                                VStack(alignment: .leading, spacing: 12) {
                                    ForEach(question.getCorrectAnswers(stateManager: stateManager), id: \.self) { answer in
                                        HStack(alignment: .top, spacing: 12) {
                                            Image(systemName: "checkmark.circle.fill")
                                                .foregroundColor(.green)
                                            
                                            Text(answer)
                                                .font(.body)
                                                .fontWeight(.medium)
                                                .foregroundColor(.primary)
                                        }
                                        .padding()
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                        .background(Color(UIColor.secondarySystemGroupedBackground))
                                        .cornerRadius(10)
                                    }
                                    
                                    if question.getCorrectAnswers(stateManager: stateManager).count > 1 {
                                        Text("Note: Any of these answers is acceptable")
                                            .font(.caption)
                                            .foregroundColor(.white.opacity(0.8))
                                            .italic()
                                            .padding(.top, 4)
                                    }
                                }
                                .transition(.opacity.combined(with: .move(edge: .top)))
                            } else {
                                Text("Tap 'Show' to reveal the answer")
                                    .font(.body)
                                    .foregroundColor(.white.opacity(0.8))
                                    .italic()
                                    .frame(maxWidth: .infinity, alignment: .center)
                                    .padding()
                                    .background(Color(UIColor.tertiarySystemGroupedBackground))
                                    .cornerRadius(10)
                            }
                        }
                    }
                    .padding()
                    .padding(.bottom, 80) // Space for navigation buttons
                }
                
                // Navigation buttons at bottom
                VStack {
                    Spacer()
                    
                    HStack(spacing: 16) {
                        // Previous button
                        Button(action: {
                            withAnimation {
                                if currentIndex > 0 {
                                    currentIndex -= 1
                                    showingAnswer = false
                                }
                            }
                        }) {
                            HStack {
                                Image(systemName: "chevron.left")
                                Text("Previous")
                            }
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(currentIndex > 0 ? categoryColor : Color.gray.opacity(0.3))
                            .foregroundColor(currentIndex > 0 ? .white : .secondary)
                            .cornerRadius(12)
                            .fontWeight(.semibold)
                        }
                        .disabled(currentIndex <= 0)
                        
                        // Next button
                        Button(action: {
                            withAnimation {
                                if currentIndex < questions.count - 1 {
                                    currentIndex += 1
                                    showingAnswer = false
                                }
                            }
                        }) {
                            HStack {
                                Text("Next")
                                Image(systemName: "chevron.right")
                            }
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(currentIndex < questions.count - 1 ? categoryColor : Color.gray.opacity(0.3))
                            .foregroundColor(currentIndex < questions.count - 1 ? .white : .secondary)
                            .cornerRadius(12)
                            .fontWeight(.semibold)
                        }
                        .disabled(currentIndex >= questions.count - 1)
                    }
                    .padding()
                    .background(Color(UIColor.systemBackground))
                    .shadow(color: .black.opacity(0.1), radius: 10, y: -5)
                }
            }
            .navigationTitle("Question Details")
            .navigationBarTitleDisplayMode(.inline)
            .toolbarBackground(.visible, for: .navigationBar)
            .toolbarBackground(categoryColor, for: .navigationBar)
            .toolbarColorScheme(.dark, for: .navigationBar)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                    .foregroundColor(.white)
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        CategorySelectionView(questionService: QuestionService(), stateManager: StateManager())
    }
}
