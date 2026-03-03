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
    @State private var selectedWebLink: WebLink?
    @Environment(\.dismiss) private var dismiss
    
    private let usRed = Color(red: 178/255, green: 34/255, blue: 52/255)
    private let usBlue = Color(red: 60/255, green: 59/255, blue: 110/255)
    
    enum WebLink: Identifiable {
        case about, home, privacyPolicy, termsAndConditions, usage
        
        var id: String {
            switch self {
            case .about: return "about"
            case .home: return "home"
            case .privacyPolicy: return "privacy"
            case .termsAndConditions: return "terms"
            case .usage: return "usage"
            }
        }
        
        var title: String {
            switch self {
            case .about: return "About"
            case .home: return "Home"
            case .privacyPolicy: return "Privacy Policy"
            case .termsAndConditions: return "Terms and Conditions"
            case .usage: return "Usage"
            }
        }
        
        var url: URL {
            switch self {
            case .about:
                return URL(string: "https://dinerdapps.wixsite.com/website-4/about")!
            case .home:
                return URL(string: "https://dinerdapps.wixsite.com/website-4")!
            case .privacyPolicy:
                return URL(string: "https://dinerdapps.wixsite.com/website-4/privacy-policy")!
            case .termsAndConditions:
                return URL(string: "https://dinerdapps.wixsite.com/website-4/blank-page")!
            case .usage:
                return URL(string: "https://dinerdapps.wixsite.com/website-4/about-1")!
            }
        }
    }
    
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
                
                // App Information Section
                Section {
                    HStack {
                        Label("Version", systemImage: "info.circle.fill")
                            .foregroundColor(usBlue)
                        Spacer()
                        Text("1.0.0")
                            .foregroundColor(.secondary)
                    }
                    
                    HStack {
                        Label("Questions Version", systemImage: "doc.text.fill")
                            .foregroundColor(.green)
                        Spacer()
                        Text("2026")
                            .foregroundColor(.secondary)
                    }
                    
                    HStack {
                        Label("Total Questions", systemImage: "list.number")
                            .foregroundColor(.orange)
                        Spacer()
                        Text("100")
                            .foregroundColor(.secondary)
                    }
                    
                    HStack {
                        Label("Passing Score", systemImage: "star.fill")
                            .foregroundColor(.yellow)
                        Spacer()
                        Text("6/10")
                            .foregroundColor(.secondary)
                    }
                } header: {
                    Text("App Information")
                } footer: {
                    Text("This app uses the official 2026 USCIS citizenship test questions.")
                        .font(.caption)
                }
                
                // Links Section
                Section {
                    Button(action: {
                        selectedWebLink = .home
                    }) {
                        HStack {
                            Label("Home", systemImage: "house.fill")
                                .foregroundColor(usBlue)
                            Spacer()
                            Image(systemName: "arrow.up.right")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                    
                    Button(action: {
                        selectedWebLink = .about
                    }) {
                        HStack {
                            Label("About Us", systemImage: "info.circle.fill")
                                .foregroundColor(.purple)
                            Spacer()
                            Image(systemName: "arrow.up.right")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                    
                    Button(action: {
                        selectedWebLink = .usage
                    }) {
                        HStack {
                            Label("Usage Guide", systemImage: "book.fill")
                                .foregroundColor(.orange)
                            Spacer()
                            Image(systemName: "arrow.up.right")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                } header: {
                    Text("Resources")
                }
                
                // Legal Section
                Section {
                    Button(action: {
                        selectedWebLink = .privacyPolicy
                    }) {
                        HStack {
                            Label("Privacy Policy", systemImage: "lock.shield.fill")
                                .foregroundColor(.green)
                            Spacer()
                            Image(systemName: "arrow.up.right")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                    
                    Button(action: {
                        selectedWebLink = .termsAndConditions
                    }) {
                        HStack {
                            Label("Terms and Conditions", systemImage: "doc.text.fill")
                                .foregroundColor(usRed)
                            Spacer()
                            Image(systemName: "arrow.up.right")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                } header: {
                    Text("Legal")
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
            .sheet(item: $selectedWebLink) { link in
                WebViewSheet(url: link.url, title: link.title)
            }
        }
    }
}

// Web View Sheet for in-app browsing
struct WebViewSheet: View {
    let url: URL
    let title: String
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            WebView(url: url)
                .navigationTitle(title)
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button("Done") {
                            dismiss()
                        }
                        .fontWeight(.semibold)
                    }
                }
        }
    }
}

// WebView wrapper using WKWebView
import WebKit

struct WebView: UIViewRepresentable {
    let url: URL
    
    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        webView.navigationDelegate = context.coordinator
        return webView
    }
    
    func updateUIView(_ webView: WKWebView, context: Context) {
        let request = URLRequest(url: url)
        webView.load(request)
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator()
    }
    
    class Coordinator: NSObject, WKNavigationDelegate {
        func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
            // Show loading indicator if needed
        }
        
        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            // Hide loading indicator if needed
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
