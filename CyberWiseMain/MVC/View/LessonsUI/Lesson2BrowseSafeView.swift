import SwiftUI

// MARK: - Main Lesson 2 View
struct Lesson2BrowseSafeView: View {
    @EnvironmentObject var loginManager: LoginManager
    @State private var showExitAlert: Bool = false  // Controls exit confirmation
    @State private var navigateToHub: Bool = false    // Controls navigation to LearnPageUI
    private let primaryColor = Color(hex: "6D8FDF")
    private let backgroundColor = Color(hex: "F1FFF3")
    @State private var isFirstSection: Bool = true

    var body: some View {
        NavigationStack {
            ZStack {
                backgroundColor.ignoresSafeArea()

                VStack(spacing: 0) {
                    // Standard header component
                    StandardLessonHeader( title: "Spotting Fake URLs", isFirstSection: $isFirstSection,  onExitConfirmed: { navigateToHub = true }, onBackPressed: { isFirstSection = true } ).font(.headline) .fontWeight(.bold) .foregroundColor(primaryColor)

                    // White Card Container
                    VStack {
                        if isFirstSection {
                            Lesson2Section1View(primaryColor: primaryColor) {
                                withAnimation {
                                    isFirstSection = false
                                }
                            }
                        } else if !isFirstSection {
                            Lesson2Section2View(primaryColor: primaryColor)
                                .environmentObject(loginManager)
                        }
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(12)
                    .shadow(radius: 3)
                    .padding(.horizontal)
                    .padding(.top)

                    Spacer()
                }
            }.background(
                NavigationLink("", destination: LearnPageUI().navigationBarBackButtonHidden(true), isActive: $navigateToHub)
            )
            .navigationBarHidden(true)
        }
    }
}

// MARK: - Section 1: Understanding URLs
struct Lesson2Section1View: View {
    let primaryColor: Color
    var onComplete: () -> Void

    @EnvironmentObject var loginManager: LoginManager
    @State private var feedbackMessage: String = ""
    @State private var showFeedback: Bool = false
    @State private var isCorrect: Bool = false

    var body: some View {
        VStack(spacing: 16) {
            Text("Section 1: Understanding URLs")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(primaryColor)
                .multilineTextAlignment(.center)

            Text("""
A URL (Uniform Resource Locator) is like the street address for a web page.
Legitimate websites usually have clear domain names and “https://” with a padlock icon for security.
Phishing sites often use subtle misspellings or unusual endings to trick you.
""")
                .font(.body)
                .foregroundColor(.black)
                .multilineTextAlignment(.center)

            // Example boxes
            HStack {
                VStack(spacing: 5) {
                    Text("Legitimate")
                        .font(.caption)
                        .foregroundColor(.green)
                    Text(AttributedString("www.amazon.com"))
                        .padding(6)
                        .background(Color.green.opacity(0.2))
                        .cornerRadius(6)
                }
                Spacer()
                VStack(spacing: 5) {
                    Text("Suspicious")
                        .font(.caption)
                        .foregroundColor(.red)
                    Text(AttributedString("www.amaz0n-support.net"))
                        .padding(6)
                        .background(Color.red.opacity(0.2))
                        .cornerRadius(6)
                }
            }
            .padding(.horizontal)

            Text("Question: Which of these URLs looks suspicious?")
                .font(.headline)
                .padding(.top, 10)

            VStack(spacing: 10) {
                Button(action: {
                    feedbackMessage = "Correct! 'www.googl3.c0m' is suspicious due to misspellings and unusual domain."
                    isCorrect = true
                    showFeedback = true
                }) {
                    Text(AttributedString("www.googl3.c0m"))
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue.opacity(0.2))
                        .cornerRadius(8)
                        .foregroundColor(.black)
                }
                Button(action: {
                    feedbackMessage = "That is actually a legitimate website."
                    isCorrect = false
                    showFeedback = true
                }) {
                    Text(AttributedString("www.google.com"))
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.yellow.opacity(0.2))
                        .cornerRadius(8)
                        .foregroundColor(.black)
                }
            }
        }
        .alert("Feedback", isPresented: $showFeedback) {
            Button("OK") {
                if isCorrect {
                    onComplete()
                }
            }
        } message: {
            Text(feedbackMessage)
        }
    }
}

// MARK: - Section 2: Spot the Fake URLs
struct Lesson2Section2View: View {
    let primaryColor: Color
    @EnvironmentObject var loginManager: LoginManager
    @Environment(\.dismiss) private var dismiss

    @State private var urls: [String] = [
        "www.bankofamerca123.biz",
        "www.google.com",
        "www.faceb00k.com"
    ]
    
    @State private var safeBox: [String] = []
    @State private var warningBox: [String] = []
    @State private var navigateToHub: Bool = false
    @State private var selectedURL: String? = nil
    @State private var showCategoryAlert = false
    @State private var showFeedback = false
    @State private var feedbackMessage = ""
    @State private var showRetryButton = false
    @State private var showSortAllFirstAlert = false

    var body: some View {
        VStack(spacing: 16) {
            Text("Section 2: Spot the Fake URLs")
                .font(.headline)
                .fontWeight(.bold)
                .foregroundColor(primaryColor)
                .multilineTextAlignment(.center)

            Text("""
            Tap each URL to choose if it's safe or suspicious.
            There are only 3 URLs total. Sort all of them before checking answers.
            """)
                .font(.body)
                .multilineTextAlignment(.center)
                .foregroundColor(.black)
            
            // Display the URLs
            VStack(spacing: 10) {
                ForEach(urls, id: \.self) { url in
                    Button {
                        selectedURL = url
                        showCategoryAlert = true
                    } label: {
                        Text(url)
                            .frame(width: 250)
                            .padding()
                            .background(Color.yellow.opacity(0.3))
                            .cornerRadius(8)
                    }
                }
            }
            .padding()
            
            // Safe & Warning Boxes
            HStack(spacing: 10) {
                VStack(spacing: 10) {
                    Text("Safe Websites")
                        .font(.subheadline)
                        .foregroundColor(primaryColor)
                    
                    Rectangle()
                        .fill(Color.green.opacity(0.2))
                        .frame(width: 150, height: 140)
                        .cornerRadius(8)
                        .overlay(
                            VStack(spacing: 0) {
                                ForEach(safeBox, id: \.self) { url in
                                    Text(url)
                                        .font(.caption)
                                        .padding(2)
                                }
                            }
                        )
                }
                
                VStack(spacing: 10) {
                    Text("Suspicious Websites")
                        .font(.subheadline)
                        .foregroundColor(primaryColor)
                    
                    Rectangle()
                        .fill(Color.red.opacity(0.2))
                        .frame(width: 150, height: 140)
                        .cornerRadius(8)
                        .overlay(
                            VStack(spacing: 0) {
                                ForEach(warningBox, id: \.self) { url in
                                    Text(url)
                                        .font(.caption)
                                        .padding(2)
                                }
                            }
                        )
                }
            }
            
            // Check Answers Button
            Button(action: checkAnswers) {
                Text("Check Answers")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(allURLsSorted ? primaryColor : .gray)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .disabled(!allURLsSorted)
            
            // Retry Button
            if showRetryButton {
                Button("Try Again") {
                    safeBox.removeAll()
                    warningBox.removeAll()
                    urls = [
                        "www.bankofamerca123.biz",
                        "www.google.com",
                        "www.faceb00k.com"
                    ]
                    showRetryButton = false
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.red.opacity(0.7))
                .foregroundColor(.white)
                .cornerRadius(10)
            }
        }
        .background(
                       NavigationLink("", destination: LearnPageUI().navigationBarBackButtonHidden(true), isActive: $navigateToHub)
                   )
                   .navigationBarHidden(true)
        .padding()
        .alert("Select Category", isPresented: $showCategoryAlert) {
            Button("Safe") { moveURL(to: &safeBox) }
            Button("Suspicious") { moveURL(to: &warningBox) }
        } message: {
            Text("Where does \(selectedURL ?? "this URL") belong?")
        }
        .alert("Warning", isPresented: $showSortAllFirstAlert) {
            Button("OK", role: .cancel) {}
        } message: {
            Text("Please place all 3 URLs in boxes before checking.")
        }
        .alert("Feedback", isPresented: $showFeedback) {
            Button("OK") {
                if !showRetryButton {
                    let currentProgress = loginManager.getProgress(for: "Browse Safe")
                    if currentProgress < 3 {
                        loginManager.updateProgress(for: "Browse Safe", session: 3)
                    }
                    navigateToHub = true
                }
            }
        } message: {
            Text(feedbackMessage)
        }
        // Custom back arrow for Section 2 that simply dismisses
        .overlay(
            Button(action: {
                dismiss()
            }) {
                Image(systemName: "arrow.left")
                    .font(.system(size: 24))
                    .foregroundColor(.white)
                    .padding(.leading, 20)
            }
            .padding(.top, 10)
            .padding(.leading, 10),
            alignment: .topLeading
        )
    }

    private var allURLsSorted: Bool {
        return (safeBox.count + warningBox.count) == 3
    }
    
    private func moveURL(to box: inout [String]) {
        guard let url = selectedURL else { return }
        box.append(url)
        urls.removeAll { $0 == url }
    }
    
    private func checkAnswers() {
        guard allURLsSorted else {
            showSortAllFirstAlert = true
            return
        }
        let correctSafe = ["www.google.com"]
        let correctWarning = ["www.bankofamerca123.biz", "www.faceb00k.com"]
        
        if Set(safeBox) == Set(correctSafe) && Set(warningBox) == Set(correctWarning) {
            feedbackMessage = "Great job! You correctly sorted all 3 URLs."
            showRetryButton = false
        } else {
            feedbackMessage = """
Some URLs are incorrect.

- 'www.bankofamerca123.biz' is suspicious (misspelling + .biz).
- 'www.faceb00k.com' is suspicious (00 instead of 'o').
- 'www.google.com' is safe.
"""
            showRetryButton = true
        }
        showFeedback = true
    }
}


// MARK: - Preview
struct Lesson2BrowseSafeView_Previews: PreviewProvider {
    static var previews: some View {
        Lesson2BrowseSafeView()
            .environmentObject(LoginManager())
    }
}


// MARK: - Preview
struct Lesson2Browse2SafeView_Previews: PreviewProvider {
    static var previews: some View {
        Lesson2Section2View(primaryColor: Color(hex: "6D8FDF"))
            .environmentObject(LoginManager())
    }
}

