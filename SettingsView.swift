//
//  SettingsView.swift
//  USCIS Citizenship practice
//
//  Created by Shanique Beckford on 2/22/26.
//

import SwiftUI
import StoreKit

struct SettingsView: View {
    @ObservedObject var scoreManager: ScoreManager
    @ObservedObject var appearanceManager: AppearanceManager
    @ObservedObject var stateManager: StateManager
    @State private var showingResetAlert = false
    @State private var showingStateSelector = false
    @State private var showingTipSheet = false
    @State private var selectedWebLink: WebLink?
    @Environment(\.dismiss) private var dismiss
    
    private let usRed = Color(red: 178/255, green: 34/255, blue: 52/255)
    private let usBlue = Color(red: 60/255, green: 59/255, blue: 110/255)
    
    enum WebLink: Identifiable {
        case about, home, privacyPolicy, termsAndConditions, usage, responsibleGaming
        
        var id: String {
            switch self {
            case .about: return "about"
            case .home: return "home"
            case .privacyPolicy: return "privacy"
            case .termsAndConditions: return "terms"
            case .usage: return "usage"
            case .responsibleGaming: return "responsible"
            }
        }
        
        var title: String {
            switch self {
            case .about: return "About"
            case .home: return "Home"
            case .privacyPolicy: return "Privacy Policy"
            case .termsAndConditions: return "Terms and Conditions"
            case .usage: return "Usage"
            case .responsibleGaming: return "Responsible Use"
            }
        }
        
        var url: URL {
            switch self {
            case .about:
                return URL(string: "https://neikkie.github.io/USCIS-Citizenship-practice/about.html")!
            case .home:
                return URL(string: "https://neikkie.github.io/USCIS-Citizenship-practice/index.html")!
            case .privacyPolicy:
                return URL(string: "https://neikkie.github.io/USCIS-Citizenship-practice/privacy.html")!
            case .termsAndConditions:
                return URL(string: "https://neikkie.github.io/USCIS-Citizenship-practice/terms.html")!
            case .usage:
                return URL(string: "https://neikkie.github.io/USCIS-Citizenship-practice/usage.html")!
            case .responsibleGaming:
                return URL(string: "https://neikkie.github.io/USCIS-Citizenship-practice/")!
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
                
                // State Selection Section
                Section {
                    Button(action: {
                        showingStateSelector = true
                    }) {
                        HStack {
                            Label("Your State", systemImage: "map.fill")
                                .foregroundColor(.green)
                            
                            Spacer()
                            
                            if let state = stateManager.selectedState {
                                Text(state.name)
                                    .foregroundColor(.secondary)
                            } else {
                                Text("Not Selected")
                                    .foregroundColor(.orange)
                            }
                            
                            Image(systemName: "chevron.right")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                } header: {
                    Text("Location")
                } footer: {
                    Text("Select your state to get accurate answers for state-specific questions (capital, governor, senators).")
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
                
                // Support Section with Tips
                Section {
                    Button(action: {
                        showingTipSheet = true
                    }) {
                        HStack {
                            Label("Leave a Tip", systemImage: "heart.fill")
                                .foregroundColor(.pink)
                            Spacer()
                            Image(systemName: "chevron.right")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                } header: {
                    Text("Support")
                } footer: {
                    Text("Support future updates and improvements by leaving a tip.")
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
            .sheet(item: $selectedWebLink) { link in
                WebViewSheet(url: link.url, title: link.title)
            }
            .sheet(isPresented: $showingStateSelector) {
                StateSelectorView(stateManager: stateManager)
            }
            .sheet(isPresented: $showingTipSheet) {
                TipJarView()
            }
        }
    }
}

// State Selector View
struct StateSelectorView: View {
    @ObservedObject var stateManager: StateManager
    @Environment(\.dismiss) private var dismiss
    @State private var searchText = ""
    
    private var filteredStates: [USState] {
        if searchText.isEmpty {
            return stateManager.allStates
        } else {
            return stateManager.allStates.filter { state in
                state.name.localizedCaseInsensitiveContains(searchText)
            }
        }
    }
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(filteredStates) { state in
                    Button(action: {
                        stateManager.selectedState = state
                        dismiss()
                    }) {
                        HStack {
                            VStack(alignment: .leading, spacing: 4) {
                                Text(state.name)
                                    .font(.system(size: 17, weight: .semibold))
                                    .foregroundColor(.primary)
                                
                                Text("Capital: \(state.capital)")
                                    .font(.system(size: 13))
                                    .foregroundColor(.secondary)
                            }
                            
                            Spacer()
                            
                            if stateManager.selectedState?.id == state.id {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundColor(.green)
                            }
                        }
                        .padding(.vertical, 4)
                    }
                }
            }
            .searchable(text: $searchText, prompt: "Search states")
            .navigationTitle("Select Your State")
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

// Tip Jar View
struct TipJarView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var isAnimating = false
    @State private var showContent = false
    
    private let usRed = Color(red: 178/255, green: 34/255, blue: 52/255)
    private let usBlue = Color(red: 60/255, green: 59/255, blue: 110/255)
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 32) {
                    // Header with animated heart
                    VStack(spacing: 20) {
                        ZStack {
                            // Pulsing circles behind heart
                            Circle()
                                .fill(
                                    LinearGradient(
                                        colors: [.pink.opacity(0.3), .red.opacity(0.2)],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                                .frame(width: 140, height: 140)
                                .scaleEffect(isAnimating ? 1.1 : 0.9)
                                .opacity(isAnimating ? 0.5 : 0.8)
                                .animation(
                                    .easeInOut(duration: 2.0).repeatForever(autoreverses: true),
                                    value: isAnimating
                                )
                            
                            Circle()
                                .fill(
                                    LinearGradient(
                                        colors: [.pink.opacity(0.2), .red.opacity(0.1)],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                                .frame(width: 170, height: 170)
                                .scaleEffect(isAnimating ? 1.2 : 0.8)
                                .opacity(isAnimating ? 0.3 : 0.6)
                                .animation(
                                    .easeInOut(duration: 2.5).repeatForever(autoreverses: true),
                                    value: isAnimating
                                )
                            
                            // Main heart icon
                            Image(systemName: "heart.fill")
                                .font(.system(size: 70))
                                .foregroundStyle(
                                    LinearGradient(
                                        colors: [.pink, .red],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                                .scaleEffect(isAnimating ? 1.05 : 1.0)
                                .animation(
                                    .easeInOut(duration: 1.5).repeatForever(autoreverses: true),
                                    value: isAnimating
                                )
                                .shadow(color: .pink.opacity(0.5), radius: 20, x: 0, y: 10)
                        }
                        .opacity(showContent ? 1 : 0)
                        .scaleEffect(showContent ? 1 : 0.5)
                        .animation(.spring(response: 0.6, dampingFraction: 0.7), value: showContent)
                        
                        VStack(spacing: 12) {
                            Text("Support This App")
                                .font(.title)
                                .fontWeight(.bold)
                                .opacity(showContent ? 1 : 0)
                                .offset(y: showContent ? 0 : 20)
                                .animation(.easeOut(duration: 0.5).delay(0.2), value: showContent)
                            
                            Text("Help keep this app free and ad-free for everyone")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                                .multilineTextAlignment(.center)
                                .padding(.horizontal, 24)
                                .opacity(showContent ? 1 : 0)
                                .offset(y: showContent ? 0 : 20)
                                .animation(.easeOut(duration: 0.5).delay(0.3), value: showContent)
                        }
                    }
                    .padding(.top, 40)
                    
                    // Store View - Main Focus
                    VStack(spacing: 20) {
                        Text("Leave a Tip")
                            .font(.title2)
                            .fontWeight(.bold)
                            .opacity(showContent ? 1 : 0)
                            .offset(y: showContent ? 0 : 20)
                            .animation(.easeOut(duration: 0.5).delay(0.4), value: showContent)
                        
                        StoreView(ids: ["smalltip.citizpractice"])
                            .productViewStyle(.large)
                            .storeButton(.visible, for: .redeemCode)
                            .opacity(showContent ? 1 : 0)
                            .scaleEffect(showContent ? 1 : 0.9)
                            .animation(.spring(response: 0.6, dampingFraction: 0.8).delay(0.5), value: showContent)
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 24)
                    .background(
                        RoundedRectangle(cornerRadius: 20)
                            .fill(Color(UIColor.secondarySystemGroupedBackground))
                            .shadow(color: .pink.opacity(0.1), radius: 15, x: 0, y: 5)
                    )
                    .padding(.horizontal)
                    
                    // Simplified Benefits - Less prominent
                    VStack(spacing: 10) {
                        Text("Your support helps with:")
                            .font(.caption)
                            .foregroundColor(.secondary)
                            .textCase(.uppercase)
                            .tracking(1)
                        
                        HStack(spacing: 20) {
                            BenefitChip(icon: "arrow.clockwise", text: "Updates")
                            BenefitChip(icon: "sparkles", text: "Features")
                            BenefitChip(icon: "globe.americas", text: "Community")
                        }
                    }
                    .opacity(showContent ? 1 : 0)
                    .offset(y: showContent ? 0 : 20)
                    .animation(.easeOut(duration: 0.5).delay(0.6), value: showContent)
                    .padding(.horizontal)
                    
                    // Thank you message
                    VStack(spacing: 12) {
                        Image(systemName: "sparkles")
                            .font(.system(size: 30))
                            .foregroundStyle(
                                LinearGradient(
                                    colors: [.yellow, .orange],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                        
                        Text("Every tip makes a difference")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                    }
                    .opacity(showContent ? 1 : 0)
                    .offset(y: showContent ? 0 : 20)
                    .animation(.easeOut(duration: 0.5).delay(0.7), value: showContent)
                    .padding(.bottom, 40)
                }
            }
            .background(Color(UIColor.systemGroupedBackground))
            .navigationTitle("Tip Jar")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                    .fontWeight(.semibold)
                }
            }
            .onAppear {
                isAnimating = true
                showContent = true
            }
        }
    }
}

// Simplified Benefit Chip
struct BenefitChip: View {
    let icon: String
    let text: String
    
    var body: some View {
        VStack(spacing: 6) {
            Image(systemName: icon)
                .font(.title3)
                .foregroundColor(.secondary)
            
            Text(text)
                .font(.caption2)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 12)
        .background(Color(UIColor.tertiarySystemGroupedBackground))
        .cornerRadius(12)
    }
}

#Preview {
    SettingsView(scoreManager: ScoreManager(), appearanceManager: AppearanceManager(), stateManager: StateManager())
}
