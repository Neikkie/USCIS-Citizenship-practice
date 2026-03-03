//
//  SettingsView.swift
//  USCIS Citizenship practice
//
//  Created by Shanique Beckford on 2/22/26.
//

import SwiftUI

struct SettingsView: View {
    @ObservedObject var scoreManager: ScoreManager
    @ObservedObject var appearanceManager: AppearanceManager
    @State private var showingResetAlert = false
    @State private var showingScoreHistory = false
    @Environment(\.dismiss) private var dismiss
    
    private let usRed = Color(red: 178/255, green: 34/255, blue: 52/255)
    private let usBlue = Color(red: 60/255, green: 59/255, blue: 110/255)
    
    var body: some View {
        NavigationStack {
            List {
                // Appearance Section
                Section {
                    ForEach(AppearanceMode.allCases, id: \.self) { mode in
                        Button(action: {
                            appearanceManager.appearanceMode = mode
                        }) {
                            HStack {
                                Image(systemName: mode.icon)
                                    .foregroundColor(usBlue)
                                    .frame(width: 24)
                                
                                Text(mode.rawValue)
                                    .foregroundColor(.primary)
                                
                                Spacer()
                                
                                if appearanceManager.appearanceMode == mode {
                                    Image(systemName: "checkmark")
                                        .foregroundColor(usBlue)
                                        .fontWeight(.semibold)
                                }
                            }
                        }
                    }
                } header: {
                    Text("Appearance")
                } footer: {
                    Text("Choose how the app looks. Automatic follows your system settings.")
                        .font(.caption)
                }
                
                // Statistics Section
                Section {
                    HStack {
                        Label("Total Tests Taken", systemImage: "checkmark.circle.fill")
                            .foregroundColor(usBlue)
                        Spacer()
                        Text("\(scoreManager.getTotalTestsTaken())")
                            .foregroundColor(.secondary)
                            .fontWeight(.semibold)
                    }
                    
                    if let avgScore = scoreManager.getAverageScore() {
                        HStack {
                            Label("Average Score", systemImage: "chart.bar.fill")
                                .foregroundColor(.orange)
                            Spacer()
                            Text("\(avgScore)%")
                                .foregroundColor(avgScore >= 60 ? .green : .orange)
                                .fontWeight(.semibold)
                        }
                    }
                    
                    Button(action: {
                        showingScoreHistory = true
                    }) {
                        HStack {
                            Label("View Score History", systemImage: "clock.fill")
                                .foregroundColor(.purple)
                            Spacer()
                            Image(systemName: "chevron.right")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                } header: {
                    Text("Statistics")
                } footer: {
                    if let avgScore = scoreManager.getAverageScore() {
                        Text("You need 60% or higher to pass the USCIS test.")
                            .font(.caption)
                    }
                }
                
                // About Section
                Section {
                    HStack {
                        Label("Questions Version", systemImage: "doc.text.fill")
                        Spacer()
                        Text("2026")
                            .foregroundColor(.secondary)
                    }
                    
                    HStack {
                        Label("Total Questions", systemImage: "list.number")
                        Spacer()
                        Text("100")
                            .foregroundColor(.secondary)
                    }
                    
                    HStack {
                        Label("Passing Score", systemImage: "star.fill")
                        Spacer()
                        Text("6/10")
                            .foregroundColor(.secondary)
                    }
                } header: {
                    Text("About")
                } footer: {
                    Text("This app uses the official 2026 USCIS citizenship test questions.")
                        .font(.caption)
                }
                
                // Data Management Section
                Section {
                    Button(role: .destructive, action: {
                        showingResetAlert = true
                    }) {
                        Label("Reset All Score Data", systemImage: "trash.fill")
                    }
                } header: {
                    Text("Data Management")
                } footer: {
                    Text("This will permanently delete all your test scores and history.")
                        .font(.caption)
                }
                
                // Disclaimer Section
                Section {
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Image(systemName: "exclamationmark.triangle.fill")
                                .foregroundColor(.orange)
                            Text("Practice Only")
                                .font(.subheadline)
                                .fontWeight(.semibold)
                        }
                        
                        Text("This app is for practice purposes only. While we strive for accuracy, we cannot guarantee that you will pass your citizenship exam. Please use official USCIS resources for the most up-to-date information.")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    .padding(.vertical, 4)
                }
            }
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                    .fontWeight(.semibold)
                }
            }
            .alert("Reset Score Data?", isPresented: $showingResetAlert) {
                Button("Cancel", role: .cancel) { }
                Button("Reset", role: .destructive) {
                    scoreManager.resetAllScores()
                }
            } message: {
                Text("This will permanently delete all your test scores and history. This action cannot be undone.")
            }
            .sheet(isPresented: $showingScoreHistory) {
                ScoreHistoryView(scoreManager: scoreManager)
            }
        }
    }
}

// Score History View
struct ScoreHistoryView: View {
    @ObservedObject var scoreManager: ScoreManager
    @Environment(\.dismiss) private var dismiss
    
    private let usRed = Color(red: 178/255, green: 34/255, blue: 52/255)
    private let usBlue = Color(red: 60/255, green: 59/255, blue: 110/255)
    
    var body: some View {
        NavigationStack {
            if scoreManager.scoreHistory.isEmpty {
                VStack(spacing: 16) {
                    Image(systemName: "tray.fill")
                        .font(.system(size: 60))
                        .foregroundColor(.secondary)
                    
                    Text("No Test History")
                        .font(.title3)
                        .fontWeight(.semibold)
                    
                    Text("Take a practice test to see your scores here")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                }
                .padding()
                .navigationTitle("Score History")
                .navigationBarTitleDisplayMode(.large)
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button("Done") {
                            dismiss()
                        }
                    }
                }
            } else {
                List {
                    ForEach(scoreManager.scoreHistory.reversed()) { record in
                        ScoreHistoryRow(record: record, usBlue: usBlue, usRed: usRed)
                    }
                }
                .navigationTitle("Score History")
                .navigationBarTitleDisplayMode(.large)
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button("Done") {
                            dismiss()
                        }
                    }
                }
            }
        }
    }
}

// Score History Row
struct ScoreHistoryRow: View {
    let record: ScoreRecord
    let usBlue: Color
    let usRed: Color
    @State private var showingDetail = false
    
    var body: some View {
        Button(action: {
            showingDetail = true
        }) {
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(formatDate(record.date))
                            .font(.subheadline)
                            .fontWeight(.semibold)
                        
                        Text("\(record.score)/\(record.totalQuestions) Correct")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    
                    Spacer()
                    
                    VStack(alignment: .trailing, spacing: 4) {
                        Text("\(record.percentage)%")
                            .font(.title3)
                            .fontWeight(.bold)
                            .foregroundColor(record.passed ? .green : .red)
                        
                        Text(record.passed ? "PASSED" : "FAILED")
                            .font(.caption)
                            .fontWeight(.semibold)
                            .foregroundColor(record.passed ? .green : .red)
                    }
                }
                
                // Category performance
                if !record.categoryPerformance.isEmpty {
                    VStack(spacing: 6) {
                        ForEach(Array(record.categoryPerformance.keys.sorted()), id: \.self) { category in
                            if let performance = record.categoryPerformance[category] {
                                HStack {
                                    Text(category)
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                    
                                    Spacer()
                                    
                                    Text("\(performance.correct)/\(performance.total)")
                                        .font(.caption)
                                        .fontWeight(.medium)
                                        .foregroundColor(performance.percentage >= 60 ? .green : .orange)
                                }
                            }
                        }
                    }
                    .padding(.top, 4)
                }
            }
            .padding(.vertical, 4)
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

// Score Detail View
struct ScoreDetailView: View {
    let record: ScoreRecord
    let usBlue: Color
    let usRed: Color
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    // Score Summary
                    VStack(spacing: 16) {
                        Image(systemName: record.passed ? "checkmark.seal.fill" : "xmark.seal.fill")
                            .font(.system(size: 60))
                            .foregroundColor(record.passed ? .green : .red)
                        
                        Text("\(record.percentage)%")
                            .font(.system(size: 48, weight: .bold))
                            .foregroundColor(record.passed ? .green : .red)
                        
                        Text("\(record.score) out of \(record.totalQuestions) correct")
                            .font(.headline)
                            .foregroundColor(.secondary)
                        
                        Text(formatDate(record.date))
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    .padding()
                    
                    // Category Breakdown
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Performance by Category")
                            .font(.headline)
                            .padding(.horizontal)
                        
                        ForEach(Array(record.categoryPerformance.keys.sorted()), id: \.self) { category in
                            if let performance = record.categoryPerformance[category] {
                                VStack(alignment: .leading, spacing: 8) {
                                    HStack {
                                        Text(category)
                                            .font(.subheadline)
                                            .fontWeight(.semibold)
                                        
                                        Spacer()
                                        
                                        Text("\(performance.percentage)%")
                                            .font(.subheadline)
                                            .fontWeight(.bold)
                                            .foregroundColor(performance.percentage >= 60 ? .green : .orange)
                                    }
                                    
                                    HStack {
                                        Text("\(performance.correct)/\(performance.total) correct")
                                            .font(.caption)
                                            .foregroundColor(.secondary)
                                        
                                        Spacer()
                                    }
                                    
                                    ProgressView(value: Double(performance.correct), total: Double(performance.total))
                                        .tint(performance.percentage >= 60 ? .green : .orange)
                                }
                                .padding()
                                .background(Color(.systemGray6))
                                .cornerRadius(12)
                                .padding(.horizontal)
                            }
                        }
                    }
                    
                    // Status Badge
                    HStack {
                        Image(systemName: record.passed ? "checkmark.circle.fill" : "xmark.circle.fill")
                        Text(record.passed ? "PASSED" : "FAILED")
                            .fontWeight(.semibold)
                    }
                    .foregroundColor(record.passed ? .green : .red)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(record.passed ? Color.green.opacity(0.1) : Color.red.opacity(0.1))
                    .cornerRadius(12)
                    .padding(.horizontal)
                }
                .padding(.vertical)
            }
            .navigationTitle("Test Results")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}

#Preview {
    SettingsView(scoreManager: ScoreManager(), appearanceManager: AppearanceManager())
}
