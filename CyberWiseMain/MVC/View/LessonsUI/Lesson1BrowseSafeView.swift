import SwiftUI

// MARK: - Lesson 1: Browse Safe
struct Lesson1BrowseSafeView: View {
    @State private var miniQuizAnswer: String = ""
    @State private var showError: Bool = false
    @State private var canNavigate: Bool = false  // Controls navigation to Section2
    @State private var showExitAlert: Bool = false  // Controls exit confirmation
    @State private var navigateToHub: Bool = false    // Controls navigation to LearnPageUI
    
    // Your preferred colors
    private let primaryColor = Color(hex: "6D8FDF")  // Blue
    private let backgroundColor = Color(hex: "F1FFF3") // Soft greenish
    @State private var isFirstSection: Bool = true
    
    var body: some View {
        NavigationStack {
            ZStack {
                backgroundColor
                    .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    // Standard header component
                        StandardLessonHeader( title: "Spotting Fake URLs", isFirstSection: $isFirstSection,  onExitConfirmed: { navigateToHub = true }, onBackPressed: { isFirstSection = true } ).font(.headline) .fontWeight(.bold) .foregroundColor(primaryColor)
                    
                    // MARK: Main White Card
                    VStack(spacing: 16) {
                        
                        Text("Section 1: Introduction to Safe Browsing")
                            .font(.headline)
                            .fontWeight(.bold)
                            .foregroundColor(primaryColor)
                            .multilineTextAlignment(.center)
                            .fixedSize(horizontal: false, vertical: true)
                        
                        Text("""
                        When you browse the internet, it's like walking down a busy street.
                        Some areas are safe, while others are risky.
                        Safe browsing helps protect you from online dangers—just like watching where you're going.
                        """)
                        .font(.body)
                        .foregroundColor(.black)
                        .multilineTextAlignment(.center)
                        .fixedSize(horizontal: false, vertical: true)
                        
                        Text("For example, if you see a dark, deserted street, you'd avoid it. The web is similar!")
                            .font(.body)
                            .foregroundColor(.black)
                            .multilineTextAlignment(.center)
                            .fixedSize(horizontal: false, vertical: true)
                        
                        // Smaller image so everything fits
                        Image(systemName: "globe")
                            .resizable()
                            .scaledToFit()
                            .frame(height: 100)
                            .padding(.horizontal, 40)
                        
                        // Mini Quiz
                        Text("Mini-quiz:")
                            .font(.subheadline)
                            .foregroundColor(primaryColor)
                        
                        Text("Have you ever visited a website that looked suspicious? What did you do?")
                            .font(.body)
                            .foregroundColor(.black)
                            .multilineTextAlignment(.center)
                            .fixedSize(horizontal: false, vertical: true)
                        
                        // Text field with border
                        TextField("Enter your answer here", text: $miniQuizAnswer)
                            .padding()
                            .background(Color.white)
                            .cornerRadius(8)
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(primaryColor, lineWidth: 1)
                            )
                        
                        if showError {
                            Text("Please enter your answer to proceed.")
                                .foregroundColor(.red)
                                .font(.footnote)
                        }
                        
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(12)
                    .shadow(radius: 3)
                    .padding(.horizontal)
                    .padding(.top, 10)
                    
                    Spacer()
                    
                    // MARK: Next Button & Navigation
                    NavigationLink(destination: Section2View(), isActive: $canNavigate) {
                        EmptyView()
                    }
                    
                    Button(action: {
                        if miniQuizAnswer.isEmpty {
                            showError = true
                        } else {
                            showError = false
                            canNavigate = true
                        }
                    }) {
                        Text("Next")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(miniQuizAnswer.isEmpty ? Color.gray : primaryColor)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                            .padding(.horizontal)
                    }
                    .padding(.bottom, 100)
                }
            }
            .background(
                NavigationLink("", destination: LearnPageUI().navigationBarBackButtonHidden(true).environmentObject(LoginManager()), isActive: $navigateToHub)
            )
            .navigationBarHidden(true)
        }
    }
}

import SwiftUI

// MARK: - Section 2: Identifying Secure Websites
struct Section2View: View {
    @EnvironmentObject var loginManager: LoginManager
    @Environment(\.dismiss) private var dismiss // Use dismiss() in Section2
    @State private var navigateToHub: Bool = false // In case you want a hidden link if needed
    @State private var isAnswerCorrect: Bool = false  // Tracks answer correctness

    private let primaryColor = Color(hex: "6D8FDF")
    private let backgroundColor = Color(hex: "F1FFF3")
    @State private var isFirstSection: Bool = false
    @State private var showFeedback: Bool = false
    @State private var feedbackMessage: String = ""

    var body: some View {
        NavigationStack {
            ZStack {
                backgroundColor.ignoresSafeArea()

                VStack(spacing: 16) {
                    // Standard header component
                        StandardLessonHeader( title: "Spotting Fake URLs", isFirstSection: $isFirstSection,  onExitConfirmed: { navigateToHub = true }, onBackPressed: { dismiss() } ).font(.headline) .fontWeight(.bold) .foregroundColor(primaryColor)
                    VStack(spacing: 16) {
                        Text("""
            A secure website will show a padlock icon and have an address that starts with 'https'.
            Select the secure link below:
            """)
                        .font(.body)
                        .foregroundColor(.black)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)

                        Image("facebook_secure")
                            .resizable()
                            .scaledToFit()
                            .frame(height: 180)
                            .padding(.horizontal, 40)

                        Image("facebook_insecure")
                            .resizable()
                            .scaledToFit()
                            .frame(height: 180)
                            .padding(.horizontal, 40)

                        VStack(spacing: 10) {
                            // ✅ Correct Answer Button
                            Button(action: {
                                let currentProgress = loginManager.getProgress(for: "Browse Safe")
                                if currentProgress == 1 {
                                    loginManager.updateProgress(for: "Browse Safe", session: 2)
                                }
                                isAnswerCorrect = true
                                feedbackMessage = "Correct! This website uses “https” and a padlock icon."
                                showFeedback = true
                            }) {
                                Text(AttributedString("https://www.facebook.com"))
                                    .font(.headline)
                                    .frame(maxWidth: 280)
                                    .padding()
                                    .background(Color.blue.opacity(0.2))
                                    .foregroundColor(.black)
                                    .cornerRadius(10)
                            }

                            // ❌ Incorrect Answer Button
                            Button(action: {
                                isAnswerCorrect = false
                                feedbackMessage = "Incorrect. Notice there's no “https” or padlock."
                                showFeedback = true
                            }) {
                                Text(AttributedString("http://www.facebook.mkt1support.cyou"))
                                    .font(.headline)
                                    .frame(maxWidth: 280)
                                    .padding()
                                    .background(Color.yellow.opacity(0.2))
                                    .foregroundColor(.black)
                                    .cornerRadius(10)
                            }
                        }
                        .padding(.horizontal)
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(12)
                    .shadow(radius: 3)
                    .padding(.horizontal)
                    .padding(.top, -10)

                    Spacer()
                }
            }
            .alert("Website Security Check", isPresented: $showFeedback) {
                Button("OK") {
                    if isAnswerCorrect {
                        dismiss()
                    }
                }
            } message: {
                Text(feedbackMessage)
            }
            .navigationBarBackButtonHidden(true)
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}


// MARK: - Preview
#Preview {
    Lesson1BrowseSafeView().environmentObject(LoginManager())
}
