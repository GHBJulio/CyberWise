import SwiftUI

// MARK: - Lesson3AvoidPhishingView
struct Lesson3AvoidPhishingView: View {
    @EnvironmentObject var loginManager: LoginManager
    @State private var isFirstSection: Bool = true
    @State private var showExitAlert: Bool = false  // Controls exit confirmation
    @State private var navigateToHub: Bool = false    // Controls navigation to LearnPageUI
    // Colors to match your style
    private let primaryColor = Color(hex: "6D8FDF")
    private let backgroundColor = Color(hex: "F1FFF3")

    var body: some View {
        NavigationStack {
            ZStack {
                backgroundColor.ignoresSafeArea()

                VStack(spacing: 0) {
                    // Standard header component
                            StandardLessonHeader( title: "Email Traps", isFirstSection: $isFirstSection,  onExitConfirmed: { navigateToHub = true }, onBackPressed: { isFirstSection = true } ).font(.headline) .fontWeight(.bold) .foregroundColor(primaryColor)

                    // White Card Container
                    VStack {
                        if isFirstSection {
                            EmailTrapsSection1View(primaryColor: primaryColor) {
                                withAnimation {
                                    isFirstSection = false
                                }
                            }
                        } else if !isFirstSection {
                            EmailTrapsSection2View(primaryColor: primaryColor)
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
                NavigationLink("", destination: LearnPageUI().navigationBarBackButtonHidden(true).environmentObject(loginManager), isActive: $navigateToHub)
                )
        }
    }
}

// MARK: - Section 1: Advanced Phishing Tactics
struct EmailTrapsSection1View: View {
    let primaryColor: Color
    var onComplete: () -> Void

    var body: some View {
        VStack(spacing: 16) {
            Text("Section 1: Advanced Phishing Tactics")
                .font(.headline)
                .fontWeight(.bold)
                .foregroundColor(primaryColor)
                .multilineTextAlignment(.center)

            Text("""
                Phishers use more than just spelling mistakes or a big “CLICK NOW!” button. They can:
                • Register **look-alike domains**: “paypa1.com” instead of “paypal.com”
                • Use **spoofed** “From” addresses to appear legitimate
                • Embed official logos to seem real
                • Use **HTTPS** with a padlock to trick you into thinking it’s safe
                """)
                .font(.body)
                .foregroundColor(.black)
                .multilineTextAlignment(.center)

            // Optional illustration
            Image("advanced_phishing") // Choose another image.
                .resizable()
                .scaledToFit()
                .frame(width: 300, height: 200)

            Spacer(minLength: 10)

            Button("Next: Final Quiz") {
                onComplete()
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 10)
            .background(primaryColor)
            .foregroundColor(.white)
            .cornerRadius(8).offset(y:-60)

            Spacer(minLength: 10)
        }
        .padding()
    }
}

// MARK: - Section 2: Final Quiz
struct EmailTrapsSection2View: View {
    let primaryColor: Color
    @EnvironmentObject var loginManager: LoginManager

    @State private var showQuizFeedback = false
    @State private var quizFeedbackMessage = ""
    @State private var isAnswerCorrect = false
    @State private var navigateToHub = false

    var body: some View {
        VStack(spacing: 16) {
            Text("Section 2: Final Phishing Quiz")
                .font(.headline)
                .fontWeight(.bold)
                .foregroundColor(primaryColor)
                .multilineTextAlignment(.center)

            Text("""
An email from “support@paypa1.com” asks for your credit card. It has a padlock in the address bar, an official PayPal logo, and urgent language. 
What should you do first?
""")
                .font(.body)
                .foregroundColor(.black)
                .multilineTextAlignment(.center)

            // Multiple Choice
            VStack(spacing: 10) {
                Button {
                    // Wrong
                    isAnswerCorrect = false
                    quizFeedbackMessage = "Not quite. The padlock can be faked or the domain can still be malicious. Don’t trust it blindly."
                    showQuizFeedback = true
                } label: {
                    Text("Trust it because of the padlock icon")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue.opacity(0.2))
                        .cornerRadius(8).foregroundColor(.black)
                }

                Button {
                    // Right
                    isAnswerCorrect = true
                    quizFeedbackMessage = """
            Exactly! Type PayPal’s **real** domain yourself or call them. 
            Never click suspicious links or give personal data to unverified emails.
            """
                    showQuizFeedback = true
                } label: {
                    Text("Go to PayPal by typing the official address yourself")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.yellow.opacity(0.2))
                        .cornerRadius(8).foregroundColor(.black)
                }

                Button {
                    // Wrong
                    isAnswerCorrect = false
                    quizFeedbackMessage = "Sharing personal info is exactly what phishers want. Be careful!"
                    showQuizFeedback = true
                } label: {
                    Text("Send them your info to resolve the issue quickly")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.brown.opacity(0.2))
                        .cornerRadius(8).foregroundColor(.black)
                }
            }

            Spacer()
        }
        .padding()
        .alert("Quiz Feedback", isPresented: $showQuizFeedback) {
            Button("OK") {
                if isAnswerCorrect {
                    // If correct, update progress to 3
                    let currentProgress = loginManager.getProgress(for: "Avoid Phishing")
                    if currentProgress < 3 {
                        loginManager.updateProgress(for: "Avoid Phishing", session: 3)
                    }
                    navigateToHub = true
                }
            }
        } message: {
            Text(quizFeedbackMessage)
        }.background(
            NavigationLink("", destination: LearnPageUI().navigationBarBackButtonHidden(true).environmentObject(loginManager), isActive: $navigateToHub)
                .navigationBarBackButtonHidden(true)
        )
    }
}

// MARK: - Preview
#Preview {
    Lesson3AvoidPhishingView()
        .environmentObject(LoginManager())
}
