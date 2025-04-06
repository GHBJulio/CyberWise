import SwiftUI

struct CheckForScamsPageUI: View {
    // Environment
    @Environment(\.dismiss) var dismiss
    
    // State variables
    @State private var linkToCheck: String = ""
    @State private var isLinkLoading: Bool = false
    @State private var linkResultMessage: String = ""
    @State private var linkResultColor: Color = .clear
    
    @State private var emailToCheck: String = ""
    @State private var isEmailLoading: Bool = false
    @State private var emailResultMessage: String = ""
    @State private var emailResultColor: Color = .clear
    
    @State private var showHistory = false
    @StateObject private var historyManager = ScamCheckHistoryManager()
    
    // Add this FocusState for keyboard management
    @FocusState private var isLinkFieldFocused: Bool
    @FocusState private var isEmailFieldFocused: Bool
    
    var body: some View {
        NavigationStack {
            ZStack {
                // Background color
                Color(hex: "F1FFF3")
                    .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    StandardLessonHeader(
                        title: "Check For Scams",
                        isFirstSection: .constant(false),
                        showExitAlert: false,
                        onExitConfirmed: {},
                        onBackPressed: { dismiss() }
                    )
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundColor(Color(hex: "6D8FDF"))
                    
                    Button {
                        // Dismiss keyboard when switching views
                        dismissKeyboard()
                        withAnimation(.easeInOut(duration: 0.3)) {
                            showHistory.toggle()
                        }
                    } label: {
                        Image(systemName: showHistory ? "magnifyingglass" : "clock.arrow.circlepath")
                            .font(.system(size: 25))
                            .foregroundColor(.white)
                    }
                    .padding(.horizontal, 8)
                    .padding(.vertical, 8)
                    .background(Color(hex: "6D8FDF"))
                    .offset(x: 170, y: -60)
                    
                    if showHistory {
                        historyView
                    } else {
                        mainScamCheckerView
                    }
                }
            }
            .navigationBarHidden(true)
            // Add this gesture to dismiss keyboard when tapping anywhere on the screen
            .onTapGesture {
                dismissKeyboard()
            }
        }
    }
    
    // MARK: - Function to dismiss keyboard
    private func dismissKeyboard() {
        isLinkFieldFocused = false
        isEmailFieldFocused = false
    }
    
    // MARK: - Main Scam Checker View
    private var mainScamCheckerView: some View {
        ScrollView {
            VStack(spacing: 22) {
                // Info Card
                VStack(spacing: 12) {
                    Image(systemName: "shield.lefthalf.filled")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 50, height: 50)
                        .foregroundColor(Color(hex: "6D8FDF"))
                        .padding(.top, 12)
                    
                    Text("Check for online scams")
                        .font(.headline)
                        .foregroundColor(Color(hex: "6D8FDF"))
                    
                    Text("Verify websites and emails before providing personal information")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                        .padding(.bottom, 8)
                }
                .padding()
                .background(Color.white)
                .cornerRadius(15)
                .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
                .padding(.horizontal, 20)
                .padding(.top, 20)
                
                // Website Checker Section
                websiteCheckerSection
                
                // Email Checker Section
                emailCheckerSection
                
                // Safety Tips Card
                safetyTipsCard
            }
            .padding(.bottom, 30)
        }
    }
    
    // MARK: - Website Checker Section
    private var websiteCheckerSection: some View {
        VStack(alignment: .leading, spacing: 15) {
            HStack {
                Image(systemName: "globe")
                    .foregroundColor(Color(hex: "6D8FDF"))
                
                Text("Website Checker")
                    .font(.headline)
                    .foregroundColor(Color(hex: "6D8FDF"))
            }
            
            Text("Verify a website before visiting or sharing information")
                .font(.subheadline)
                .foregroundColor(.gray)
            
            TextField("Enter website URL", text: $linkToCheck)
                .focused($isLinkFieldFocused) // Add focus binding
                .padding()
                .background(Color.white)
                .cornerRadius(10)
                .shadow(color: Color.black.opacity(0.05), radius: 2, x: 0, y: 1)
                .autocapitalization(.none)
                .disableAutocorrection(true)
            
            Button {
                dismissKeyboard() // Dismiss keyboard when button is pressed
                checkLink()
            } label: {
                HStack {
                    if isLinkLoading {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: .white))
                    } else {
                        Text("Verify Website")
                            .fontWeight(.semibold)
                    }
                }
                .foregroundColor(.white)
                .frame(height: 50)
                .frame(maxWidth: .infinity)
                .background(Color(hex: "6D8FDF"))
                .cornerRadius(15)
                .shadow(color: Color(hex: "6D8FDF").opacity(0.3), radius: 5, x: 0, y: 2)
            }
            .disabled(isLinkLoading || linkToCheck.isEmpty)
            
            if !linkResultMessage.isEmpty {
                websiteResultCard
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(15)
        .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
        .padding(.horizontal, 20)
    }
    
    // MARK: - Email Checker Section
    private var emailCheckerSection: some View {
        VStack(alignment: .leading, spacing: 15) {
            HStack {
                Image(systemName: "envelope")
                    .foregroundColor(Color(hex: "6D8FDF"))
                
                Text("Email Checker")
                    .font(.headline)
                    .foregroundColor(Color(hex: "6D8FDF"))
            }
            
            Text("Verify an email address before responding or interacting")
                .font(.subheadline)
                .foregroundColor(.gray)
            
            TextField("Enter email address", text: $emailToCheck)
                .focused($isEmailFieldFocused) // Add focus binding
                .padding()
                .background(Color.white)
                .cornerRadius(10)
                .shadow(color: Color.black.opacity(0.05), radius: 2, x: 0, y: 1)
                .autocapitalization(.none)
                .disableAutocorrection(true)
                .keyboardType(.emailAddress)
            
            Button {
                dismissKeyboard() // Dismiss keyboard when button is pressed
                checkEmailSafety()
            } label: {
                HStack {
                    if isEmailLoading {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: .white))
                    } else {
                        Text("Verify Email")
                            .fontWeight(.semibold)
                    }
                }
                .foregroundColor(.white)
                .frame(height: 50)
                .frame(maxWidth: .infinity)
                .background(Color(hex: "6D8FDF"))
                .cornerRadius(15)
                .shadow(color: Color(hex: "6D8FDF").opacity(0.3), radius: 5, x: 0, y: 2)
            }
            .disabled(isEmailLoading || emailToCheck.isEmpty)
            
            if !emailResultMessage.isEmpty {
                emailResultCard
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(15)
        .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
        .padding(.horizontal, 20)
    }
    
    // MARK: - Safety Tips Card
    private var safetyTipsCard: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("Security Recommendations")
                .font(.headline)
                .foregroundColor(Color(hex: "6D8FDF"))
            
            VStack(alignment: .leading, spacing: 12) {
                securityTipRow(icon: "exclamationmark.triangle", tip: "Never share personal information or passwords with unverified sources")
                securityTipRow(icon: "creditcard", tip: "Be cautious of unexpected payment requests from unknown senders")
                securityTipRow(icon: "gift", tip: "Be skeptical of offers that seem unusually favorable or implausible")
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(15)
        .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
        .padding(.horizontal, 20)
    }
    
    // MARK: - Result Cards
    private var websiteResultCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: getStatusIcon(for: linkResultColor))
                    .foregroundColor(.white)
                
                Text(getStatusMessage(for: linkResultColor, isWebsite: true))
                    .font(.headline)
                    .foregroundColor(.white)
            }
            
            Divider()
                .background(Color.white.opacity(0.5))
            
            Text(formatResultMessage(linkResultMessage, isWebsite: true))
                .foregroundColor(.white)
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(linkResultColor)
        .cornerRadius(12)
    }
    
    private var emailResultCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: getStatusIcon(for: emailResultColor))
                    .foregroundColor(.white)
                
                Text(getStatusMessage(for: emailResultColor, isWebsite: false))
                    .font(.headline)
                    .foregroundColor(.white)
            }
            
            Divider()
                .background(Color.white.opacity(0.5))
            
            Text(formatResultMessage(emailResultMessage, isWebsite: false))
                .foregroundColor(.white)
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(emailResultColor)
        .cornerRadius(12)
    }
    
    // MARK: - History View
    private var historyView: some View {
        VStack(spacing: 0) {
            HStack {
                Text("Verification History")
                    .font(.headline)
                    .foregroundColor(Color(hex: "6D8FDF"))
                
                Spacer()
                
                if !historyManager.scamCheckHistory.isEmpty {
                    Button {
                        historyManager.clearHistory()
                    } label: {
                        Text("Clear All")
                            .font(.subheadline)
                            .foregroundColor(.red.opacity(0.8))
                    }
                }
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 15)
            
            if historyManager.scamCheckHistory.isEmpty {
                VStack(spacing: 20) {
                    Image(systemName: "clock.arrow.circlepath")
                        .font(.system(size: 60))
                        .foregroundColor(Color(hex: "A9DFBF").opacity(0.8))
                        .padding(.top, 40)
                    
                    Text("No verification history yet")
                        .font(.headline)
                        .foregroundColor(.gray)
                    
                    Text("Verified websites and emails will appear here")
                        .font(.subheadline)
                        .foregroundColor(.gray.opacity(0.8))
                        .multilineTextAlignment(.center)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color(hex: "F1FFF3"))
            } else {
                ScrollView {
                    LazyVStack(spacing: 12) {
                        ForEach(historyManager.scamCheckHistory) { record in
                            ScamCheckHistoryRow(record: record)
                                .padding(.horizontal, 20)
                        }
                    }
                    .padding(.vertical, 10)
                }
                .background(Color(hex: "F1FFF3"))
            }
        }
    }
    
    // MARK: - Helper Functions
    private func securityTipRow(icon: String, tip: String) -> some View {
        HStack(alignment: .top, spacing: 10) {
            Image(systemName: icon)
                .foregroundColor(Color(hex: "6D8FDF"))
                .frame(width: 24)
            
            Text(tip)
                .font(.subheadline)
                .foregroundColor(.primary)
        }
    }
    
    private func getStatusIcon(for color: Color) -> String {
        if color == .green {
            return "checkmark.shield.fill"
        } else if color == .orange {
            return "exclamationmark.triangle.fill"
        } else {
            return "xmark.shield.fill"
        }
    }
    
    private func getStatusMessage(for color: Color, isWebsite: Bool) -> String {
        if color == .green {
            return isWebsite ? "SAFE TO VISIT" : "SAFE EMAIL"
        } else if color == .orange {
            return "PROCEED WITH CAUTION"
        } else {
            return isWebsite ? "POTENTIALLY UNSAFE" : "SUSPICIOUS EMAIL"
        }
    }
    
    private func formatResultMessage(_ message: String, isWebsite: Bool) -> String {
        let simplifiedMessage = message.replacingOccurrences(of: "Risk Score: ", with: "Safety Rating: ")
        
        if isWebsite {
            if linkResultColor == .green {
                return "This website appears to be safe.\n\n" + simplifiedMessage
            } else if linkResultColor == .orange {
                return "Exercise caution with this website.\n\n" + simplifiedMessage
            } else {
                return "This website may be unsafe. Avoid visiting it.\n\n" + simplifiedMessage
            }
        } else {
            if emailResultColor == .green {
                return "This email address appears to be legitimate.\n\n" + simplifiedMessage
            } else if emailResultColor == .orange {
                return "Be careful with emails from this address.\n\n" + simplifiedMessage
            } else {
                return "This email address may be suspicious.\n\n" + simplifiedMessage
            }
        }
    }
    
    // MARK: - API Functions
    private func checkLink() {
        linkResultMessage = ""
        linkResultColor = .clear
        isLinkLoading = true
        
        // Add HTTPS if missing
        var urlToCheck = linkToCheck
        if !urlToCheck.lowercased().hasPrefix("http://") && !urlToCheck.lowercased().hasPrefix("https://") {
            urlToCheck = "https://\(urlToCheck)"
        }
        
        guard isValidURL(urlToCheck) else {
            linkResultMessage = "Invalid website address. Please check and try again."
            linkResultColor = .red
            isLinkLoading = false
            return
        }
        
        let api = MaliciousURLAPI()
        api.checkURL(urlToCheck) { result in
            DispatchQueue.main.async {
                self.isLinkLoading = false
                switch result {
                case .success(let data):
                    var details: [String] = []
                    
                    if let riskScore = data["risk_score"] as? Int {
                        linkResultMessage = "Safety Rating: \(riskScore)/100"
                        linkResultColor = riskScore <= 25 ? .green : riskScore <= 70 ? .orange : .red
                        
                        // Add to history
                        historyManager.addRecord(
                            type: .website,
                            value: urlToCheck,
                            riskScore: riskScore,
                            isRisky: riskScore > 25
                        )
                    }
                    
                    let flags = ["phishing": "Phishing detected", "malware": "Malware detected"]
                    flags.forEach { key, label in
                        if let flag = data[key] as? Bool, flag {
                            details.append("Warning: \(label)")
                        } else {
                            details.append("No \(key) detected")
                        }
                    }
                    
                    linkResultMessage += "\n\n" + details.joined(separator: "\n")
                case .failure:
                    linkResultMessage = "Unable to verify this website at this time. Please try again later."
                    linkResultColor = .red
                }
            }
        }
    }
    
    private func checkEmailSafety() {
        emailResultMessage = ""
        emailResultColor = .clear
        isEmailLoading = true
        
        guard isValidEmail(emailToCheck) else {
            emailResultMessage = "Invalid email address. Please check and try again."
            emailResultColor = .red
            isEmailLoading = false
            return
        }
        
        let api = EmailValidatorAPI()
        api.validateEmail(emailToCheck) { result in
            DispatchQueue.main.async {
                self.isEmailLoading = false
                switch result {
                case .success(let data):
                    var details: [String] = []
                    
                    emailResultMessage = "Safety Rating: \(data.riskScore)/100"
                    emailResultColor = data.riskScore <= 25 ? .green : data.riskScore <= 70 ? .orange : .red
                    
                    // Add to history
                    historyManager.addRecord(
                        type: .email,
                        value: emailToCheck,
                        riskScore: data.riskScore,
                        isRisky: data.riskScore > 25 || data.isDisposable || data.isSpamTrap
                    )
                    
                    if data.isDisposable {
                        details.append("Warning: This is a temporary email address")
                    } else {
                        details.append("Not a temporary email address")
                    }
                    
                    if data.isSpamTrap {
                        details.append("Warning: This email address is associated with spam")
                    } else {
                        details.append("No spam associations detected")
                    }
                    
                    emailResultMessage += "\n\n" + details.joined(separator: "\n")
                case .failure:
                    emailResultMessage = "Unable to verify this email address at this time. Please try again later."
                    emailResultColor = .red
                }
            }
        }
    }
    
    private func isValidURL(_ url: String) -> Bool {
        guard let url = URL(string: url), url.scheme != nil else { return false }
        return true
    }
    
    private func isValidEmail(_ email: String) -> Bool {
        let regex = "^[A-Z0-9a-z._%+-]+@[A-Z0-9a-z.-]+\\.[A-Za-z]{2,}$"
        return NSPredicate(format: "SELF MATCHES %@", regex).evaluate(with: email)
    }
}

// MARK: - Scam Check History
struct ScamCheckRecord: Identifiable, Codable {
    var id = UUID()
    let timestamp: Date
    let type: ScamCheckType
    let value: String
    let riskScore: Int
    let isRisky: Bool
    
    var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        return formatter.string(from: timestamp)
    }
    
    enum ScamCheckType: String, Codable {
        case website, email
    }
}

// MARK: - History Manager
class ScamCheckHistoryManager: ObservableObject {
    @Published var scamCheckHistory: [ScamCheckRecord] = []
    
    private let userDefaults = UserDefaults.standard
    private let historyKey = "scamCheckHistory"
    
    init() {
        loadHistory()
    }
    
    func addRecord(type: ScamCheckRecord.ScamCheckType, value: String, riskScore: Int, isRisky: Bool) {
        let newRecord = ScamCheckRecord(
            timestamp: Date(),
            type: type,
            value: value,
            riskScore: riskScore,
            isRisky: isRisky
        )
        
        scamCheckHistory.insert(newRecord, at: 0)
        saveHistory()
    }
    
    func clearHistory() {
        scamCheckHistory.removeAll()
        saveHistory()
    }
    
    private func saveHistory() {
        if let encoded = try? JSONEncoder().encode(scamCheckHistory) {
            userDefaults.set(encoded, forKey: historyKey)
        }
    }
    
    private func loadHistory() {
        if let savedData = userDefaults.data(forKey: historyKey),
           let decoded = try? JSONDecoder().decode([ScamCheckRecord].self, from: savedData) {
            scamCheckHistory = decoded
        }
    }
}

// MARK: - History Item Row
struct ScamCheckHistoryRow: View {
    let record: ScamCheckRecord
    
    var body: some View {
        HStack {
            // Indicator dot
            Circle()
                .fill(riskColor)
                .frame(width: 12, height: 12)
            
            // Icon
            Image(systemName: record.type == .website ? "globe" : "envelope")
                .foregroundColor(.gray)
                .frame(width: 24)
            
            VStack(alignment: .leading, spacing: 3) {
                Text(record.value)
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .lineLimit(1)
                
                Text(record.formattedDate)
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            
            Spacer()
            
            // Risk score badge
            Text("\(record.riskScore)")
                .font(.caption)
                .fontWeight(.bold)
                .foregroundColor(.white)
                .frame(width: 32, height: 24)
                .background(riskColor)
                .cornerRadius(12)
        }
        .padding(.vertical, 8)
        .padding(.horizontal)
        .background(Color.white)
        .cornerRadius(10)
        .shadow(color: Color.black.opacity(0.05), radius: 2, x: 0, y: 1)
    }
    
    private var riskColor: Color {
        if record.riskScore >= 75 {
            return Color.red
        } else if record.riskScore >= 30 {
            return Color.orange
        } else {
            return Color.green
        }
    }
}

#Preview {
    CheckForScamsPageUI()
}
