import SwiftUI

// MARK: - Phone Verification History
struct PhoneVerificationRecord: Identifiable, Codable {
    var id = UUID()
    let timestamp: Date
    let phoneNumber: String
    let countryCode: String
    let isValid: Bool
    let isRisky: Bool
    let fraudScore: Int
    let carrier: String?
    let formattedNumber: String?
    
    var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        return formatter.string(from: timestamp)
    }
}

// MARK: - History Manager
class VerificationHistoryManager: ObservableObject {
    @Published var verificationHistory: [PhoneVerificationRecord] = []
    
    private let userDefaults = UserDefaults.standard
    private let historyKey = "phoneVerificationHistory"
    
    init() {
        loadHistory()
    }
    
    func addRecord(from response: PhoneValidationResponse, phoneNumber: String, countryCode: String) {
        let newRecord = PhoneVerificationRecord(
            timestamp: Date(),
            phoneNumber: phoneNumber,
            countryCode: countryCode,
            isValid: response.isValid,
            isRisky: response.isRisky,
            fraudScore: response.fraudScore,
            carrier: response.carrier,
            formattedNumber: response.formattedNumber
        )
        
        verificationHistory.insert(newRecord, at: 0)
        saveHistory()
    }
    
    func clearHistory() {
        verificationHistory.removeAll()
        saveHistory()
    }
    
    private func saveHistory() {
        if let encoded = try? JSONEncoder().encode(verificationHistory) {
            userDefaults.set(encoded, forKey: historyKey)
        }
    }
    
    private func loadHistory() {
        if let savedData = userDefaults.data(forKey: historyKey),
           let decoded = try? JSONDecoder().decode([PhoneVerificationRecord].self, from: savedData) {
            verificationHistory = decoded
        }
    }
}

struct VerificationResultCard: View {
    let response: PhoneValidationResponse
    let phoneNumber: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            // Header with simplified risk indicator
            HStack {
                Text("Phone Check Results")
                    .font(.headline)
                    .fontWeight(.bold)
                
                Spacer()
                
                // Status badge changes based on validity first
                HStack(spacing: 4) {
                    Image(systemName: statusIcon)
                        .foregroundColor(statusColor)
                    
                    Text(statusMessage)
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundColor(statusColor)
                }
                .padding(.horizontal, 10)
                .padding(.vertical, 5)
                .background(statusColor.opacity(0.15))
                .cornerRadius(12)
            }
            
            Divider()
            
            // Number with clear formatting
            HStack {
                Text("Phone Number:")
                    .fontWeight(.medium)
                
                Text(response.formattedNumber ?? phoneNumber)
                    .font(.body)
            }
            
            if response.isValid {
                // Only show detailed information if the number is valid
                
                // Simple safety recommendation box
                HStack {
                    Image(systemName: recommendationIcon)
                        .foregroundColor(riskColor)
                        .font(.title2)
                    
                    Text(safetyRecommendation)
                        .font(.body)
                        .fixedSize(horizontal: false, vertical: true)
                }
                .padding()
                .background(riskColor.opacity(0.1))
                .cornerRadius(10)
                
                // Simplified verification details
                VStack(alignment: .leading, spacing: 12) {
                    simpleStatusRow(label: "Safe to answer?", value: isNumberSafe, icon: isNumberSafe ? "checkmark.circle.fill" : "xmark.circle.fill")
                    
                    if let country = response.country {
                        simpleDetailRow(label: "Country", value: country, icon: "globe")
                    }
                    
                    if let carrier = response.carrier {
                        simpleDetailRow(label: "Phone Company", value: carrier, icon: "antenna.radiowaves.left.and.right")
                    }
                    
                    if let lineType = response.lineType {
                        simpleDetailRow(label: "Phone Type", value: lineType == "mobile" ? "Mobile Phone" : lineType.capitalized, icon: lineType == "mobile" ? "iphone" : "phone")
                    }
                }
                .padding(.top, 5)
                
                // Simplified Risk Level Indicator
                VStack(alignment: .leading, spacing: 6) {
                    Text("Risk Level")
                        .font(.subheadline)
                        .fontWeight(.medium)
                    
                    ZStack(alignment: .leading) {
                        // Background bar
                        RoundedRectangle(cornerRadius: 6)
                            .fill(Color.gray.opacity(0.2))
                            .frame(height: 12)
                        
                        // Filled portion
                        RoundedRectangle(cornerRadius: 6)
                            .fill(fraudScoreColor)
                            .frame(width: max(5, CGFloat(response.fraudScore) / 100 * 300), height: 12)
                    }
                    
                    // Simplified legend
                    HStack {
                        Text("Safe")
                            .font(.caption)
                            .foregroundColor(.green)
                        
                        Spacer()
                        
                        Text("Be Careful")
                            .font(.caption)
                            .foregroundColor(.orange)
                        
                        Spacer()
                        
                        Text("Warning")
                            .font(.caption)
                            .foregroundColor(.red)
                    }
                }
                .padding(.top, 10)
            } else {
                // Show simplified message if number is not valid
                VStack(spacing: 15) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.red)
                        .font(.system(size: 50))
                    
                    Text("This phone number does not appear to exist.")
                        .font(.body)
                        .multilineTextAlignment(.center)
                        .padding()
                    
                    Text("If you received a call from this number, it may be using fake caller ID technology.")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                }
                .frame(maxWidth: .infinity)
                .padding()
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(15)
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
    }
    
    private func simpleStatusRow(label: String, value: Bool, icon: String) -> some View {
        HStack(spacing: 8) {
            Image(systemName: icon)
                .foregroundColor(value ? .green : .red)
            
            Text(label)
                .font(.body)
                .fontWeight(.medium)
            
            Text(value ? "Yes" : "No")
                .font(.body)
                .fontWeight(.semibold)
                .foregroundColor(value ? .green : .red)
        }
    }
    
    private func simpleDetailRow(label: String, value: String, icon: String) -> some View {
        HStack(spacing: 8) {
            Image(systemName: icon)
                .foregroundColor(.primary)
            
            Text("\(label):")
                .font(.body)
                .fontWeight(.medium)
            
            Text(value)
                .font(.body)
                .foregroundColor(.black)
        }
    }
    
    // Basic status properties that check validity first
    private var statusIcon: String {
        if !response.isValid {
            return "xmark.circle.fill"
        } else if response.fraudScore >= 75 || response.recentAbuse {
            return "exclamationmark.triangle.fill"
        } else if response.fraudScore >= 30 {
            return "exclamationmark.circle.fill"
        } else {
            return "checkmark.circle.fill"
        }
    }
    
    private var statusColor: Color {
        if !response.isValid {
            return Color.red
        } else if response.fraudScore >= 75 || response.recentAbuse {
            return Color.red
        } else if response.fraudScore >= 30 {
            return Color.orange
        } else {
            return Color.green
        }
    }
    
    private var statusMessage: String {
        if !response.isValid {
            return "Invalid Number"
        } else if response.fraudScore >= 75 || response.recentAbuse {
            return "Warning"
        } else if response.fraudScore >= 30 {
            return "Be Careful"
        } else {
            return "Safe"
        }
    }
    
    // Risk assessment properties only used if the number is valid
    private var isNumberSafe: Bool {
        return response.fraudScore < 30 && !response.recentAbuse
    }
    
    private var recommendationIcon: String {
        if response.fraudScore >= 75 || response.recentAbuse {
            return "hand.raised.fill"
        } else if response.fraudScore >= 30 {
            return "eye.fill"
        } else {
            return "checkmark.shield.fill"
        }
    }
    
    private var safetyRecommendation: String {
        if response.fraudScore >= 75 || response.recentAbuse {
            return "DO NOT ANSWER calls from this number. It appears to be suspicious and might be a scam."
        } else if response.fraudScore >= 30 {
            return "BE CAREFUL with this number. If they ask for personal information or money, hang up and verify who they are."
        } else {
            return "This number appears to be legitimate. However, still be careful about sharing personal information."
        }
    }
    
    private var riskColor: Color {
        if response.fraudScore >= 75 || response.recentAbuse {
            return Color.red
        } else if response.fraudScore >= 30 {
            return Color.orange
        } else {
            return Color.green
        }
    }
    
    private var fraudScoreColor: Color {
        if response.fraudScore >= 75 {
            return Color.red
        } else if response.fraudScore >= 30 {
            return Color.orange
        } else {
            return Color.green
        }
    }
}

// MARK: - History Item Row
struct VerificationHistoryRow: View {
    let record: PhoneVerificationRecord
    
    var body: some View {
        HStack {
            // Indicator dot
            Circle()
                .fill(riskColor)
                .frame(width: 12, height: 12)
            
            VStack(alignment: .leading, spacing: 3) {
                Text("\(record.countryCode) \(record.phoneNumber)")
                    .font(.subheadline)
                    .fontWeight(.medium)
                
                Text(record.formattedDate)
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            
            Spacer()
            
            // Risk score badge
            Text("\(record.fraudScore)")
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
        if record.fraudScore >= 75 {
            return Color.red
        } else if record.fraudScore >= 30 {
            return Color.orange
        } else {
            return Color.green
        }
    }
}

// MARK: - Main View
struct VerifyCallersPageUI: View {
    // Environment
    @Environment(\.dismiss) var dismiss
    
    // State
    @State private var phoneNumber: String = ""
    @State private var selectedCountry: Country
    @State private var isDropdownExpanded = false
    @State private var apiResponse: PhoneValidationResponse? = nil
    @State private var errorMessage: String? = nil
    @State private var isLoading = false
    @State private var showHistory = false
    
    // New state variables for reporting alerts
    @State private var showConfirmReport = false
    @State private var showSecondConfirmReport = false
    @State private var showReportResultAlert = false
    @State private var reportResultMessage: String = ""
    
    // View Model
    @StateObject private var historyManager = VerificationHistoryManager()
    
    // Reordered countries: +1 (USA) and +44 (UK) at the top, rest follow
    private let displayedCountries: [Country]
    
    init() {
        // Identify the "popular" codes
        let popularCodes = ["+1", "+44"]
        
        // Separate out "popular" vs. "others"
        let popular = countries.filter { popularCodes.contains($0.code) }
        let others = countries.filter { !popularCodes.contains($0.code) }
        
        // Combined, so +1 and +44 are at the top
        self.displayedCountries = popular + others
        
        // Default selection is the first in the new array
        _selectedCountry = State(initialValue: displayedCountries.first!)
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                // Background color
                Color(hex: "F1FFF3")
                    .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    StandardLessonHeader(
                        title: "Verify Callers",
                        isFirstSection: .constant(false), // No section tracking
                        showExitAlert: false, // Disable exit confirmation
                        onExitConfirmed: {}, // Not used in general views
                        onBackPressed: { dismiss() } // Normal back action
                    ).font(.headline) .fontWeight(.bold) .foregroundColor(Color(hex: "6D8FDF"))
                    
                    Button {
                        withAnimation(.easeInOut(duration: 0.3)) {
                            showHistory.toggle()
                        }
                    } label: {
                        Image(systemName: showHistory ? "phone.fill" : "clock.arrow.circlepath")
                            .font(.system(size: 25))
                            .foregroundColor(.white)
                    }
                    .padding(.horizontal, 8)
                    .padding(.vertical, 8)
                    .background(Color(hex: "6D8FDF")).offset(x:170, y:-60)
                    
                    if showHistory {
                        historyView
                    } else {
                        mainVerificationView
                    }
                }
            }
            .navigationBarHidden(true)
            // First confirmation alert
            .alert("Report Phone Number", isPresented: $showConfirmReport) {
                Button("Yes, Report this Number", role: .destructive) {
                    showSecondConfirmReport = true
                }
                Button("Cancel", role: .cancel) {}
            } message: {
                Text("Are you sure you want to report this phone number as potentially fraudulent?")
            }
            // Second confirmation alert
            .alert("Confirm Report", isPresented: $showSecondConfirmReport) {
                Button("Yes, I'm Sure", role: .destructive) {
                    reportPhoneNumber()
                }
                Button("Cancel", role: .cancel) {}
            } message: {
                Text("This will submit a report to our database. Continue?")
            }
            // Result alert
            .alert("Report Status", isPresented: $showReportResultAlert) {
                Button("OK", role: .cancel) {}
            } message: {
                Text(reportResultMessage)
            }
            // Add gesture recognizer to dismiss keyboard when tapping outside
            .contentShape(Rectangle())
            .onTapGesture {
                hideKeyboard()
            }
        }
    }
    
    
    private func checkIfNumberWasPreviouslyVerified(phoneNumber: String, countryCode: String) -> PhoneVerificationRecord? {
        return historyManager.verificationHistory.first { record in
            record.phoneNumber == phoneNumber && record.countryCode == countryCode
        }
    }
    
    // MARK: - Main Verification View
    private var mainVerificationView: some View {
        ZStack {
            ScrollView {
                VStack(spacing: 22) {
                    // Info Card
                    VStack(spacing: 12) {
                        Image(systemName: "phone.fill.badge.checkmark")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 50, height: 50)
                            .foregroundColor(Color(hex: "6D8FDF"))
                            .padding(.top, 12)
                        
                        Text("Verify any phone number")
                            .font(.headline)
                            .foregroundColor(Color(hex: "6D8FDF"))
                        
                        Text("Check if a phone number is valid, risky, or potentially fraudulent")
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
                    
                    // Phone Input Section
                    VStack(spacing: 15) {
                        // Country Dropdown + Phone Field
                        HStack(spacing: 10) {
                            // Dropdown
                            VStack {
                                // Selected Country Button
                                Button {
                                    withAnimation {
                                        isDropdownExpanded.toggle()
                                    }
                                } label: {
                                    HStack {
                                        Text(selectedCountry.flag)
                                        Text("\(selectedCountry.code)")
                                            .foregroundColor(.black)
                                            .font(.subheadline)
                                            .fontWeight(.medium)
                                        Spacer()
                                        Image(systemName: isDropdownExpanded ? "chevron.up" : "chevron.down")
                                            .foregroundColor(.black)
                                            .font(.caption)
                                    }
                                    .padding(.horizontal)
                                    .frame(height: 50)
                                    .background(Color.white)
                                    .cornerRadius(10)
                                    .shadow(color: Color.black.opacity(0.05), radius: 2, x: 0, y: 1)
                                }
                                .frame(width: 140)
                            }
                            
                            // Phone Number Field
                            TextField("Enter phone number", text: $phoneNumber)
                                .keyboardType(.numberPad)
                                .padding(.horizontal)
                                .frame(height: 50)
                                .background(Color.white)
                                .cornerRadius(10)
                                .shadow(color: Color.black.opacity(0.05), radius: 2, x: 0, y: 1)
                                .onChange(of: phoneNumber) { _ in
                                    validatePhoneNumberInput()
                                }
                        }
                        .padding(.horizontal, 20)
                        
                        // Error message
                        if let errorMessage = errorMessage {
                            Text(errorMessage)
                                .font(.caption)
                                .foregroundColor(.red)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.horizontal, 25)
                        }
                        
                        // Verify Button
                        Button {
                            verifyPhoneNumber()
                        } label: {
                            Group {
                                if isLoading {
                                    ProgressView()
                                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                } else {
                                    Text("Verify Now")
                                        .fontWeight(.semibold)
                                }
                            }
                            .foregroundColor(.white)
                            .frame(height: 50)
                            .frame(maxWidth: .infinity)
                            .background(Color(hex: "6D8FDF"))
                            .cornerRadius(15)
                            .shadow(color: Color(hex: "6D8FDF").opacity(0.3), radius: 5, x: 0, y: 2)
                            .padding(.horizontal, 20)
                        }
                        .disabled(isLoading || phoneNumber.isEmpty || errorMessage != nil)
                    }
                    
                    // Results Card
                    if let response = apiResponse {
                        VerificationResultCard(response: response, phoneNumber: "\(selectedCountry.code)\(phoneNumber)")
                            .padding(.horizontal, 20)
                            .padding(.top, 10)
                        
                        // Report Button - Added at the bottom of screen when results are present
                        Button {
                            showConfirmReport = true
                        } label: {
                            HStack {
                                Image(systemName: "exclamationmark.triangle.fill")
                                Text("Report This Number")
                                    .fontWeight(.medium)
                            }
                            .foregroundColor(.white)
                            .frame(height: 50)
                            .frame(maxWidth: .infinity)
                            .background(Color.red)
                            .cornerRadius(15)
                            .shadow(color: Color.red.opacity(0.3), radius: 5, x: 0, y: 2)
                            .padding(.horizontal, 20)
                            .padding(.top, 15)
                        }
                    }
                    
                    Spacer(minLength: 30)
                }
            }
            
            // Country selection dropdown overlay
            if isDropdownExpanded {
                Color.black.opacity(0.4)
                    .edgesIgnoringSafeArea(.all)
                    .onTapGesture {
                        withAnimation {
                            isDropdownExpanded = false
                        }
                    }
                    .overlay(
                        ZStack {
                            // Shadow layer that extends slightly beyond the content
                            RoundedRectangle(cornerRadius: 16)
                                .fill(Color.clear)
                                .shadow(color: Color.black.opacity(0.2), radius: 10, x: 0, y: 5)
                                .frame(maxWidth: 340)
                            
                            // Content layer
                            VStack(spacing: 0) {
                                Text("Select Country")
                                    .font(.headline)
                                    .padding(.top, 16)
                                    .padding(.bottom, 8)
                                
                                Divider()
                                
                                ScrollView {
                                    LazyVStack(spacing: 0) {
                                        ForEach(displayedCountries, id: \.id) { country in
                                            Button {
                                                withAnimation {
                                                    selectedCountry = country
                                                    isDropdownExpanded = false
                                                }
                                            } label: {
                                                HStack {
                                                    Text(country.flag)
                                                        .padding(.trailing, 8)
                                                    
                                                    Text("\(country.name)")
                                                        .foregroundColor(.black)
                                                        .font(.subheadline)
                                                        .lineLimit(1)
                                                    
                                                    Spacer()
                                                    
                                                    Text("\(country.code)")
                                                        .foregroundColor(.gray)
                                                        .font(.subheadline)
                                                        .frame(minWidth: 90, alignment: .trailing)
                                                }
                                                .padding(.vertical, 12)
                                                .padding(.horizontal, 16)
                                                .background(selectedCountry.id == country.id ? Color(hex: "E8F5E9") : Color.white)
                                                .contentShape(Rectangle())
                                            }
                                        }
                                    }
                                }
                                .frame(maxHeight: 300)
                                
                                Divider()
                                
                                Button {
                                    withAnimation {
                                        isDropdownExpanded = false
                                    }
                                } label: {
                                    Text("Close")
                                        .fontWeight(.medium)
                                        .foregroundColor(.white)
                                        .frame(maxWidth: .infinity)
                                        .padding(.vertical, 14)
                                        .background(Color(hex: "6D8FDF"))
                                        .cornerRadius(10)
                                }
                                .padding(.horizontal, 16)
                                .padding(.vertical, 12)
                            }
                            .background(Color.white)
                            .cornerRadius(16)
                            .frame(maxWidth: 340)
                        }
                            .padding(.horizontal, 24)
                    )
                    .zIndex(100) // Ensure it appears on top
            }
        }
    }
    
    // New function to report phone number after double confirmation
    func reportPhoneNumber() {
        let sanitizedNumber = phoneNumber.filter(\.isNumber) // remove +, spaces, dashes
        let parameters = [
            "phone": sanitizedNumber,
            "country": selectedCountry.isoCode // "US" for United States, etc.
        ]
        
        FraudReportingAPI().reportFraud(parameters: parameters) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let response):
                    reportResultMessage = "Report successful: \(response.message)"
                case .failure(let error):
                    reportResultMessage = "Reporting error: \(error.localizedDescription)"
                }
                showReportResultAlert = true
            }
        }
    }
    
    // MARK: - History View
    private var historyView: some View {
        VStack(spacing: 0) {
            HStack {
                Text("Verification History")
                    .font(.headline)
                    .foregroundColor(Color(hex: "6D8FDF"))
                
                Spacer()
                
                if !historyManager.verificationHistory.isEmpty {
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
            
            if historyManager.verificationHistory.isEmpty {
                VStack(spacing: 20) {
                    Image(systemName: "clock.arrow.circlepath")
                        .font(.system(size: 60))
                        .foregroundColor(Color(hex: "A9DFBF").opacity(0.8))
                        .padding(.top, 40)
                    
                    Text("No verification history yet")
                        .font(.headline)
                        .foregroundColor(.gray)
                    
                    Text("Verified phone numbers will appear here")
                        .font(.subheadline)
                        .foregroundColor(.gray.opacity(0.8))
                        .multilineTextAlignment(.center)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color(hex: "F1FFF3"))
            } else {
                ScrollView {
                    LazyVStack(spacing: 12) {
                        ForEach(historyManager.verificationHistory) { record in
                            VerificationHistoryRow(record: record)
                                .padding(.horizontal, 20)
                        }
                    }
                    .padding(.vertical, 10)
                }
                .background(Color(hex: "F1FFF3"))
            }
        }
    }
    
    // MARK: - Methods
    private func validatePhoneNumberInput() {
        if !phoneNumber.allSatisfy(\.isNumber) {
            phoneNumber = String(phoneNumber.filter { $0.isNumber })
            errorMessage = "Numbers only"
        } else if phoneNumber.count > 15 {
            phoneNumber = String(phoneNumber.prefix(15))
            errorMessage = "Cannot exceed 15 digits"
        } else if phoneNumber.count < 7 && !phoneNumber.isEmpty {
            errorMessage = "Minimum 7 digits required"
        } else {
            errorMessage = nil
        }
        
        // Clear response when input changes
        if !phoneNumber.isEmpty {
            apiResponse = nil
        }
    }
    
    // Function to hide keyboard
    private func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
    
    // Then modify your verifyPhoneNumber() function
    func verifyPhoneNumber() {
        // Hide keyboard when verifying
        hideKeyboard()
        
        guard !phoneNumber.isEmpty else {
            errorMessage = "Please enter a phone number"
            return
        }
        
        if phoneNumber.count < 7 {
            errorMessage = "Phone numbers must contain at least 7 digits"
            return
        }
        
        // Check if this number was verified before
        if let previousRecord = checkIfNumberWasPreviouslyVerified(phoneNumber: phoneNumber, countryCode: selectedCountry.code) {
            // Create alert for repeated check
            let alert = UIAlertController(
                title: "Number Previously Checked",
                message: "You've checked this number before on \(previousRecord.formattedDate). The risk score was \(previousRecord.fraudScore). Do you want to check it again?",
                preferredStyle: .alert
            )
            
            alert.addAction(UIAlertAction(title: "Yes, Check Again", style: .default) { _ in
                // User wants to proceed, continue with verification
                self.performVerification()
            })
            
            alert.addAction(UIAlertAction(title: "No, Cancel", style: .cancel) { _ in
                // User chose to cancel, do nothing
            })
            
            // Find the current view controller to present the alert
            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
               let rootViewController = windowScene.windows.first?.rootViewController {
                rootViewController.present(alert, animated: true)
            }
            
        } else {
            // No previous check, proceed directly
            performVerification()
        }
    }
    
    // Extract the actual API call to its own method
    private func performVerification() {
        isLoading = true
        errorMessage = nil
        
        let fullPhoneNumber = "\(selectedCountry.code)\(phoneNumber)"
        
        let api = PhoneValidationAPI()
        api.validatePhoneNumber(fullPhoneNumber, countryCode: selectedCountry.code) { result in
            DispatchQueue.main.async {
                isLoading = false
                switch result {
                case .success(let response):
                    apiResponse = response
                    historyManager.addRecord(from: response, phoneNumber: phoneNumber, countryCode: selectedCountry.code)
                case .failure(let error):
                    errorMessage = "Error: \(error.localizedDescription)"
                }
            }
        }
    }
}

// MARK: - Preview
#Preview {
    VerifyCallersPageUI()
}
