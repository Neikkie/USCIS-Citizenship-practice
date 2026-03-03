//
//  CategorySelectionView.swift
//  USCIS Citizenship practice
//
//  Created by Shanique Beckford on 2/22/26.
//

import SwiftUI

struct CategorySelectionView: View {
    @ObservedObject var questionService: QuestionService
    
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
            
            ScrollView {
                VStack(spacing: 24) {
                    // Header
                    VStack(spacing: 8) {
                        Image(systemName: "folder.fill")
                            .font(.system(size: 50))
                            .foregroundStyle(.white)
                            .shadow(color: usBlue.opacity(0.5), radius: 4)
                        
                        Text("Study by Category")
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                        
                        Text("Focus on specific topics")
                            .font(.subheadline)
                            .foregroundColor(.white.opacity(0.9))
                    }
                    .padding(.top, 20)
                    
                    // Category cards
                    VStack(spacing: 16) {
                        ForEach(QuestionCategory.allCases, id: \.self) { category in
                            NavigationLink(destination: CategoryDetailView(
                                category: category,
                                questions: questionService.getQuestions(by: category),
                                questionService: questionService
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
                    .foregroundColor(.white)
                
                Text("\(questionCount) questions")
                    .font(.subheadline)
                    .foregroundColor(.white.opacity(0.8))
            }
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .foregroundColor(.white)
        }
        .padding()
        .background(.white.opacity(0.2))
        .cornerRadius(12)
        .shadow(color: categoryColor.opacity(0.3), radius: 8, y: 4)
    }
}

// Category detail view with questions
struct CategoryDetailView: View {
    let category: QuestionCategory
    let questions: [Question]
    @ObservedObject var questionService: QuestionService
    
    @State private var selectedQuestion: Question?
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
            // American flag-inspired background
            LinearGradient(
                gradient: Gradient(colors: [usBlue, usRed.opacity(0.3), .white]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Category header
                VStack(spacing: 12) {
                    HStack {
                        Image(systemName: category.icon)
                            .font(.system(size: 40))
                            .foregroundStyle(.white)
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text(category.rawValue)
                                .font(.title3)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                            
                            Text("\(filteredQuestions.count) questions")
                                .font(.subheadline)
                                .foregroundColor(.white.opacity(0.9))
                        }
                        
                        Spacer()
                    }
                    .padding()
                    
                    // Search bar
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.white.opacity(0.7))
                        TextField("Search questions...", text: $searchText)
                            .foregroundColor(.white)
                            .tint(.white)
                        
                        if !searchText.isEmpty {
                            Button(action: { searchText = "" }) {
                                Image(systemName: "xmark.circle.fill")
                                    .foregroundColor(.white.opacity(0.7))
                            }
                        }
                    }
                    .padding()
                    .background(.white.opacity(0.2))
                    .cornerRadius(10)
                    .padding(.horizontal)
                }
                .background(categoryColor.opacity(0.8))
                .padding(.bottom, 8)
                
                // Questions list
                ScrollView {
                    LazyVStack(spacing: 12) {
                        ForEach(filteredQuestions) { question in
                            Button(action: {
                                selectedQuestion = question
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
        .sheet(item: $selectedQuestion) { question in
            QuestionDetailSheet(
                question: question,
                showingAnswer: $showingAnswer,
                categoryColor: categoryColor
            )
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
                .foregroundColor(.white)
                .multilineTextAlignment(.leading)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            Image(systemName: "chevron.right")
                .font(.caption)
                .foregroundColor(.white.opacity(0.7))
        }
        .padding()
        .background(.white.opacity(0.15))
        .cornerRadius(10)
    }
}

// Question detail sheet
struct QuestionDetailSheet: View {
    let question: Question
    @Binding var showingAnswer: Bool
    let categoryColor: Color
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            ZStack {
                // Background gradient
                LinearGradient(
                    gradient: Gradient(colors: [categoryColor.opacity(0.6), categoryColor]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
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
                                .background(.white.opacity(0.3))
                                .cornerRadius(20)
                            
                            Spacer()
                            
                            Label(question.category.rawValue, systemImage: question.category.icon)
                                .font(.caption)
                                .foregroundColor(.white)
                                .padding(.horizontal, 12)
                                .padding(.vertical, 6)
                                .background(.white.opacity(0.3))
                                .cornerRadius(20)
                        }
                        
                        // Question
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Question")
                                .font(.caption)
                                .foregroundColor(.white.opacity(0.8))
                                .textCase(.uppercase)
                            
                            Text(question.question)
                                .font(.title3)
                                .fontWeight(.semibold)
                                .foregroundColor(.white)
                        }
                        
                        Divider()
                            .background(.white.opacity(0.5))
                        
                        // Answer section
                        VStack(alignment: .leading, spacing: 12) {
                            HStack {
                                Text("Answer")
                                    .font(.caption)
                                    .foregroundColor(.white.opacity(0.8))
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
                                    .background(.white.opacity(0.3))
                                    .foregroundColor(.white)
                                    .cornerRadius(20)
                                }
                            }
                            
                            if showingAnswer {
                                VStack(alignment: .leading, spacing: 12) {
                                    ForEach(question.correctAnswers, id: \.self) { answer in
                                        HStack(alignment: .top, spacing: 12) {
                                            Image(systemName: "checkmark.circle.fill")
                                                .foregroundColor(.green)
                                            
                                            Text(answer)
                                                .font(.body)
                                                .fontWeight(.medium)
                                                .foregroundColor(.white)
                                        }
                                        .padding()
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                        .background(.white.opacity(0.2))
                                        .cornerRadius(10)
                                    }
                                    
                                    if question.correctAnswers.count > 1 {
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
                                    .background(.white.opacity(0.15))
                                    .cornerRadius(10)
                            }
                        }
                        
                        // All answer options (if available)
                        if !question.answers.isEmpty && question.answers.count > 1 {
                            VStack(alignment: .leading, spacing: 12) {
                                Text("All Options")
                                    .font(.caption)
                                    .foregroundColor(.white.opacity(0.8))
                                    .textCase(.uppercase)
                                
                                ForEach(question.answers, id: \.self) { answer in
                                    HStack {
                                        Image(systemName: question.isCorrect(answer: answer) ? "checkmark.circle.fill" : "circle")
                                            .foregroundColor(question.isCorrect(answer: answer) ? .green : .white.opacity(0.5))
                                        
                                        Text(answer)
                                            .font(.subheadline)
                                            .foregroundColor(.white)
                                    }
                                    .padding()
                                    .background(.white.opacity(0.1))
                                    .cornerRadius(8)
                                }
                            }
                        }
                    }
                    .padding()
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
        CategorySelectionView(questionService: QuestionService())
    }
}
